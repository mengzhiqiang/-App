//
//  AppDelegate+Update.m
//  SmartDevice
//
//  Created by singelet on 16/6/20.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "AppDelegate+Update.h"
//#import "HttpEngine.h"

@implementation AppDelegate (Update)


+ (void)checkAppVersion:(BOOL)isHome
{
    [self checkAppVersionWithAppId:@"1481799121" isHome:isHome];
    
}

+ (void)checkAppVersionWithAppId:(NSString*)appid isHome:(BOOL)isHome
{
    NSString* path = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",appid];
    [HttpEngine requestPostWithURL:path params:nil isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        NSDictionary *resDict   = (NSDictionary*)responseObject;
        [self  checkAppVersionWithInfo:resDict isHome:isHome];
    } failure:^(NSError *error) {
        NSDictionary *resDict   = [[NSDictionary alloc]initWithObjectsAndKeys:@"服务器连接异常，请重新再试",@"msg",@"100",@"code", nil];
        [self  checkAppVersionWithInfo:resDict isHome:isHome];
    }];
}

+ (void)checkAppVersionWithInfo:(NSDictionary *)info isHome:(BOOL)isHome
{
    AppDelegate *appdelegate = [AppDelegate delegateGet];
    if ([info objectForKey:@"code"]) {
        return;
    }
    else {
        if ([(NSArray*)([info objectForKey:@"results"]) count]==0) {
            return;
        }
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *OldVersionID = [infoDic objectForKey:@"CFBundleShortVersionString"];
        NSString *NewversonID=[[[info objectForKey:@"results"] objectAtIndex:0] objectForKey:@"version"];
    
        if (![OldVersionID isEqualToString:NewversonID]) {
            
            NSString * string=[[[info objectForKey:@"results"] objectAtIndex:0] objectForKey:@"trackViewUrl"];
            string=  [string stringByReplacingOccurrencesOfString:@"https://" withString:@"itms-apps://"];
            [AFAlertViewHelper alertViewWithTitle:nil message:[NSString stringWithFormat:@"已有新版本%@，现在去AppStore更新吧！",NewversonID] delegate:[UIViewController getCurrentController] cancelTitle:@"取消" otherTitle:@"确定" clickBlock:^(NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
                }

            }];
            
        }else{
            if (!isHome) {
                 [AFAlertViewHelper alertViewWithTitle:nil message:[NSString stringWithFormat:@"暂无更新"] delegate:[UIViewController getCurrentController] cancelTitle:@"确定" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
                               
               }];
            }
           
        }
      
    }
 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//     AppDelegate *appdelegate = [AppDelegate delegateGet];
//    if (buttonIndex == 1) {//更新
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appdelegate.refreshUrl]];
//    }
}


@end
