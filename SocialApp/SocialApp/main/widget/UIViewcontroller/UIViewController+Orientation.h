//
//  UIViewController+Orientation.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/29.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Orientation)

//转横屏
- (void)setupInterfaceOrientationMaskLandscape;

//转竖屏
- (void)setupInterfaceOrientationMaskPortrait;

- (void)setupLandscapeRotationWithRotation:(BOOL)rotation;

- (void)setupAllowRotationWithRotation:(BOOL)rotation;

- (void)setupDeviceOrientationPortrait;

- (void)setupDeviceOrientationLandscape;

@end
