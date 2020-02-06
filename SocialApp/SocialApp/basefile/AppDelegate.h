//
//  AppDelegate.h
//  BaseProject
//
//  Created by zhiqiang meng on 19/6/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,EMChatManagerDelegate>
{
    EMConnectionState _connectionState;

}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL allowRotation; //是否允许全方向旋转
@property (nonatomic, assign) BOOL landscapeRotation; //是否允许左右方向旋转

+ (AppDelegate *)delegateGet;

@end

