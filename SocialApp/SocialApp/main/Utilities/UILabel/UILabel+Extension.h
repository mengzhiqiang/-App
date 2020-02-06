//
//  UILabel+Extension.h
//  PieLifeApp
//
//  Created by libj on 2019/7/31.
//  Copyright © 2019 Libj. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Extension)


/**
 自定义文字大小与颜色

 @param text 内容
 @param color 字体颜色
 @param size 字体大小
 @return 返回label
 */
+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)color fontSize:(CGFloat)size;

/**
 自定义文字大小与颜色

 @param text 内容
 @param color 字体颜色
 @param font 字体
 @return 返回label
 */
+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
