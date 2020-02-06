//
//  AppDelegate.m
//  BaseProject
//
//  Created by zhiqiang meng on 19/6/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>

#import "AppDelegate.h"
#import "LMHTabBarViewController.h"
#import "CheckNetwordStatus.h"
#import "DCNewFeatureViewController.h"
#import "AppDelegate+Update.h"
#import "AppDelegate+APNS.h"

#import "WXApi.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <Bugly/Bugly.h>
#import <ShareSDK/ShareSDK.h>
#import "EMDemoHelper.h"
#import "EMGlobalVariables.h"

#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import <AMapFoundationKit/AMapFoundationKit.h>


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [CheckNetwordStatus sharedInstance].isNetword = YES;
    [HttpEngine checkAFNetworkStatus];

    self.window.backgroundColor = [UIColor whiteColor];
//    [self setUpRootVC];

//    [WXApi registerApp:WX_APPID universalLink:@""];
    [Bugly startWithAppId:buglyID];
    [AMapServices sharedServices].apiKey = AMAP_apiKey;

    
    
    [self _initDemo];
    [self _initHyphenate];
    //注册推送
    [self setupPushWithLaunchOptions:launchOptions];
    //检查更新
//    [AppDelegate  checkAppVersion:YES];
    [self ininFaceSDK];
    
    EMOptions *options = [EMOptions optionsWithAppkey:@"1117191030148229#youqu"];
    // apnsCertName是证书名称，可以先传nil，等后期配置apns推送时在传入证书名称
    options.apnsCertName = nil;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    return YES;
}

-(void)ininFaceSDK{
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
     NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
     [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
     NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
     NSLog(@"version = %@",[[FaceVerifier sharedInstance] getVersion]);
}
#pragma mark - 根控制器
- (void)setUpRootVC
{
//    if ([BUNDLE_VERSION isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppVersion"]]) {//判断是否当前版本号等于上一次储存版本号
        
//        self.window.rootViewController = [[LMHTabBarViewController alloc] init];
//        self.window.backgroundColor = [UIColor whiteColor];
//    }else{
//        [[NSUserDefaults standardUserDefaults] setObject:BUNDLE_VERSION forKey:@"AppVersion"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//                // 设置窗口的根控制器
//                DCNewFeatureViewController *dcFVc = [[DCNewFeatureViewController alloc] init];
//                [dcFVc setUpFeatureAttribute:^(NSArray *__autoreleasing *imageArray, UIColor *__autoreleasing *selColor, BOOL *showSkip, BOOL *showPageCount) {
//                    if (iphoneXTop==0) {
//                    *imageArray = @[@"引导页01_X.png",@"引导页02_X.png",@"引导页03_X.png",@"引导页04_X.png"];
//                    }else{
//                        *imageArray = @[@"引导页01.jpg",@"引导页02.jpg",@"引导页03.jpg",@"引导页04.jpg"];
//                    }
//                    *showPageCount = YES;
//                    *showSkip = YES;
//                }];
//                self.window.rootViewController = dcFVc;
//            }
    }

#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送内容" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark - Hyphenate

- (void)_initHyphenate
{
    EMDemoOptions *demoOptions = [EMDemoOptions sharedOptions];
    if (demoOptions.isAutoLogin){
        gIsInitializedSDK = YES;
        [[EMClient sharedClient] initializeSDKWithOptions:[demoOptions toOptions]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNT_LOGIN_CHANGED object:@(YES)];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNT_LOGIN_CHANGED object:@(NO)];
    }
}

#pragma mark - Demo

- (void)_initDemo
{
        //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:ACCOUNT_LOGIN_CHANGED object:nil];
    
 //注册推送
    [self _registerRemoteNotification];
}
//注册远程通知
- (void)_registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

- (void)loginStateChange:(NSNotification *)aNotif
{
    UINavigationController *navigationController = nil;
    
    BOOL loginSuccess = [aNotif.object boolValue];
    
    [EMDemoHelper shareHelper];
    [EMNotificationHelper shared];
    if (loginSuccess) {//登录成功加载主窗口控制器
        
//        navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
        
        [EMDemoHelper shareHelper];
        [EMNotificationHelper shared];
//        [DemoCallManager sharedManager];
//        [DemoConfManager sharedManager];
    } else {//登录失败加载登录页面控制器
//        LMHTabBarViewController *controller = [[LMHTabBarViewController alloc] init];
//        navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    }
    
    LMHTabBarViewController *homeController = [[LMHTabBarViewController alloc] init];
    homeController.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = homeController;
    [self.window makeKeyAndVisible];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.scheme hasPrefix:WX_APPID]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.scheme hasPrefix:@"LMHalipay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"options=result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayResult" object:resultDic];
        }];
    }else   if ([url.scheme hasPrefix:WX_APPID]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

// NOTE: 9.0以前使用新API接口
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.scheme hasPrefix:@"LMHalipay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"sourceApplication=result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayResult" object:resultDic];
        }];
    }
    return YES;
}

+ (AppDelegate *)delegateGet
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
}
@end
