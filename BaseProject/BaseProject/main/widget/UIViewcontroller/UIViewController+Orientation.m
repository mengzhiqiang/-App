//
//  UIViewController+Orientation.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/29.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "UIViewController+Orientation.h"
#import "AppDelegate.h"

@implementation UIViewController (Orientation)


//转横屏
- (void)setupInterfaceOrientationMaskLandscape
{
//    AppDelegate *appdelegate = [AppDelegate delegateGet];
//    appdelegate.landscapeRotation = YES;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//转竖屏
- (void)setupInterfaceOrientationMaskPortrait
{
    AppDelegate *appdelegate = [AppDelegate delegateGet];
    appdelegate.landscapeRotation = NO;
    appdelegate.allowRotation = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)setupDeviceOrientationPortrait
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)setupDeviceOrientationLandscape
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
}

- (void)setupLandscapeRotationWithRotation:(BOOL)rotation
{
    AppDelegate *appdelegate = [AppDelegate delegateGet];
    appdelegate.landscapeRotation = rotation;
}

- (void)setupAllowRotationWithRotation:(BOOL)rotation
{
    AppDelegate *appdelegate = [AppDelegate delegateGet];
    appdelegate.allowRotation = rotation;
}



@end
