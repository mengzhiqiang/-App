//
//  UILabel+Extension.m
//  PieLifeApp
//
//  Created by libj on 2019/7/31.
//  Copyright © 2019 Libj. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)color fontSize:(CGFloat)size {
    
    UILabel *label = [[self alloc] init];
    [label setText:text];
    [label setTextColor:color ? : Main_title_Color];
//    [label setFont:[UIFont fontWithFontSize:size]];
    [label setFont:[UIFont systemFontOfSize:size]];
    return label;
}

+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font {
    
    UILabel *label = [[self alloc] init];
    [label setText:text];
    [label setTextColor:color ? : Main_title_Color];
    [label setFont:font];
    return label;
}
@end
