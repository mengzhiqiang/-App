//
//  AppDelegate.m
//  BaseProject
//
//  Created by zhiqiang meng on 19/6/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "AppDelegate.h"
#import "LMHTabBarViewController.h"
#import "CheckNetwordStatus.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <Bugly/Bugly.h>
#import <ShareSDK/ShareSDK.h>
#import "DCNewFeatureViewController.h"

#import "AppDelegate+Update.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [CheckNetwordStatus sharedInstance].isNetword = YES;
    [HttpEngine checkAFNetworkStatus];
//    LMHTabBarViewController *tabbarVC = [[LMHTabBarViewController alloc]init];
//    self.window.rootViewController = tabbarVC;
    [self setUpRootVC];
    [self.window makeKeyAndVisible];

    [WXApi registerApp:WX_APPID];

    [Bugly startWithAppId:buglyID];

    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:QQ_APPKey appkey:QQ_APPSeret];
        //微信
        [platformsRegister setupWeChatWithAppId:WX_APPID appSecret:WX_APPsecret];
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"568898243" appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3" redirectUrl:@"http://www.sharesdk.cn"];
    }];
    
    //检查更新
    [AppDelegate  checkAppVersion:YES];
    return YES;
}
#pragma mark - 根控制器
- (void)setUpRootVC
{
    if ([BUNDLE_VERSION isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppVersion"]]) {//判断是否当前版本号等于上一次储存版本号
        
        self.window.rootViewController = [[LMHTabBarViewController alloc] init];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:BUNDLE_VERSION forKey:@"AppVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
                // 设置窗口的根控制器
                DCNewFeatureViewController *dcFVc = [[DCNewFeatureViewController alloc] init];
                [dcFVc setUpFeatureAttribute:^(NSArray *__autoreleasing *imageArray, UIColor *__autoreleasing *selColor, BOOL *showSkip, BOOL *showPageCount) {
                    if (iphoneXTop==0) {
                    *imageArray = @[@"引导页01_X.png",@"引导页02_X.png",@"引导页03_X.png",@"引导页04_X.png"];
                    }else{
                        *imageArray = @[@"引导页01.jpg",@"引导页02.jpg",@"引导页03.jpg",@"引导页04.jpg"];
                    }
                    *showPageCount = YES;
                    *showSkip = YES;
                }];
                self.window.rootViewController = dcFVc;
            }
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
