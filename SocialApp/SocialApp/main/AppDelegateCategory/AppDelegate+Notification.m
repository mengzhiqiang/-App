//
//  AppDelegate+Notification.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/8/16.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AppDelegate+Notification.h"
#import "UIViewController+Extension.h"
//#import "BENLoginViewController.h"
#import "AppDelegate.h"


@implementation AppDelegate (Notification)

+ (void) postSwitchRootViewControllerNotificationWithIsLogin:(BOOL)islogin{
    
    UIViewController * viewControl = [UIViewController  getCurrentController];
//    [viewControl.navigationController pushViewController:[BENLoginViewController new] animated:YES];
}

@end
