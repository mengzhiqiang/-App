//
//  UIButton+Extenxion.m
//  ehome
//
//  Created by WONG on 16/6/20.
//  Copyright © 2016年 hongsui. All rights reserved.
//

#import "UIButton+Extenxion.h"
//#import "UIColor+Hex.h"

@implementation UIButton (Extenxion)

+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor fontSize:(CGFloat)fontSize {
    UIButton *button = [[UIButton alloc] init];
    
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (bgColor) {
        button.backgroundColor = bgColor;
    }
    if (fontSize) {
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    return button;
}


+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] init];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:Black_Color forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    return button;
}

+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize defaultTitleColor:(UIColor *)normalColor selectedTitleColor:(UIColor *)selectedColor highlightTitleColor:(UIColor *)highlightColor {
    UIButton *button = [[UIButton alloc] init];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (fontSize) {
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    if (normalColor) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if (selectedColor) {
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
    }
    if (highlightColor) {
        [button setTitleColor:highlightColor forState:UIControlStateHighlighted];
    }
    return button;
}
+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize fontWeight:( UIFontWeight )fontWeight defaultTitleColor:(UIColor *)normalColor defaultBgColor:(UIColor *)defaultBgColor selectedBgColor:(UIColor *)selectedColor
{
    UIButton *button = [[UIButton alloc] init];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (fontSize!=0) {
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    if (defaultBgColor) {
        [button setBackgroundColor:defaultBgColor forState:UIControlStateNormal];
    }
    if (normalColor) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if (selectedColor) {
        [button setBackgroundColor:selectedColor forState:UIControlStateHighlighted];
    }
    if (fontWeight!=0) {
        [UIFont systemFontOfSize:fontSize weight:fontWeight];
    }
    return button;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//验证码倒计时
- (void)startWithTime:(NSInteger)timeCount title:(NSString *)title countDownTitle:(NSString *)subTitle {
//    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    //倒计时时间
    __block NSInteger timeOut = timeCount;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{

        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:title forState:UIControlStateNormal];
//                [self setTitleColor:[UIColor colorWithHexString:BlackString] forState:UIControlStateNormal];
                self.enabled = YES;
            });
        } else {
            NSInteger seconds = timeOut;
            NSString *timeStr = [NSString stringWithFormat:@"%2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                self.enabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}


- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space
{
    //    self.backgroundColor = [UIColor cyanColor];
    
    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case MKButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case MKButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case MKButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case MKButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}


- (void)buttonSetGradientStarColor:(UIColor *)starColor endColor:(UIColor *)endColor{
        
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, self.width, self.height);
    gl.startPoint = CGPointMake(0.56, 1);
    gl.endPoint = CGPointMake(0.56, 0);
    gl.colors = @[(__bridge id)starColor.CGColor, (__bridge id)endColor.CGColor];
//    gl.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.layer addSublayer:gl];
    [self.layer insertSublayer:gl atIndex:0];

}

@end
