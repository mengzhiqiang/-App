//
//  UIButton+Extenxion.h
//  ehome
//
//  Created by WONG on 16/6/20.
//  Copyright © 2016年 hongsui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (Extenxion)
/**
 *  快速创建button，包括：title、字体大小、默认字体颜色、选中字体颜色、高亮字体颜色
 *   fontSize  字体大小 若不设置 传0
 *   fontWeight ：若不设置 传0
                  UIFontWeightUltraLight  - 超细字体
                  UIFontWeightThin  - 纤细字体
                  UIFontWeightRegular  - 常规字体
                  UIFontWeightMedium  - 介于Regular和Semibold之间
                  UIFontWeightSemibold  - 半粗字体
                  UIFontWeightBold  - 加粗字体
                  UIFontWeightHeavy  - 介于Bold和Black之间
                  UIFontWeightBlack  - 最粗字体
 *   颜色不设置 传nil
 */
+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize fontWeight:(UIFontWeight)fontWeight defaultTitleColor:(UIColor *)normalColor defaultBgColor:(UIColor *)defaultBgColor selectedBgColor:(UIColor *)selectedColor;
/**
 *  快速创建button，包括：title、image、默认字体颜色、背景、字体
 */
+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor fontSize:(CGFloat)fontSize;

/**
 *  快速创建button，包括：title、image、默认字体颜色、背景、字体13
 */
+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName;

/**
 *  快速创建button，包括：title、字体大小、默认字体颜色、选中字体颜色、高亮字体颜色
 */
+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize defaultTitleColor:(UIColor *)normalColor selectedTitleColor:(UIColor *)selectedColor highlightTitleColor:(UIColor *)highlightColor;

/**
 *  颜色平铺图片
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  验证码倒计时
 */
- (void)startWithTime:(NSInteger)timeCount title:(NSString *)title countDownTitle:(NSString *)subTitle;

- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

- (void)buttonSetGradientStarColor:(UIColor *)starColor endColor:(UIColor *)endColor;

@end
