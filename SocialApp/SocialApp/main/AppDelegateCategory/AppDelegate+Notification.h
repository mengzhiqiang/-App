//
//  AppDelegate+Notification.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/8/16.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Notification)<CAAnimationDelegate>

- (void)setupAppDelegateNotification;


+ (void) postSwitchRootViewControllerNotificationWithIsLogin:(BOOL)islogin;

@end
