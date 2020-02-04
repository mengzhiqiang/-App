//
//  UIAlertController+Simple.h
//  ZCBus
//
//  Created by wfg on 2019/8/23.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Simple)
+ (UIAlertController *)showWithMessage:(NSString *)message;
+ (UIAlertController *)showWithMessage:(NSString *)message confirm:(void (^ __nullable)(UIAlertAction *action))confirm;
+ (UIAlertController *)showWithTitle:(NSString *)title message:(NSString *)message confirm:(void (^ _Nullable)(UIAlertAction * _Nonnull))confirm;


+ (UIAlertController *)showSheetTitles:(NSArray *)titles;
+ (UIAlertController *)showSheetTitles:(NSArray *)titles titleColor:(UIColor *)titleColor cancelColor:(UIColor *)cancelColor backIndex:(void(^)(UIAlertAction *UIAlertAction, NSInteger index))backIndex;

+ (UIAlertController *)showSheetShare:(NSArray *)titles titleColor:(UIColor *)titleColor cancelColor:(UIColor *)cancelColor backIndex:(void(^)(UIAlertAction *UIAlertAction, NSInteger index))backIndex;
@end

NS_ASSUME_NONNULL_END
