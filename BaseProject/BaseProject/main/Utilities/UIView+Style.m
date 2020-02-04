//
//  UIView+Style.m
//
//  Created by kunge on 15/11/20.
//

#import "UIView+Style.h"


@implementation UIView (Style)

-(void)setBorderwithColor:(UIColor *)color withWidth:(CGFloat)width withRadius:(CGFloat)radius
{
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

-(void)setShadowWithColour:(UIColor *)color withOffset:(CGSize)offset withOpacity:(CGFloat)opacity withRadius:(CGFloat)radius
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.cornerRadius = radius;
}

-(void)setRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

-(void)setBorderwithColor:(UIColor *)color withWidth:(CGFloat)width
{
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
    self.layer.masksToBounds = YES;
}



/**
 *  设置边框宽度
 *
 *  @param borderWidth 可视化视图传入的值
 */
- (void)setBorderWidth:(CGFloat)borderWidth
{
    if (borderWidth < 0) return;
    self.layer.borderWidth = borderWidth;
}

-(CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

/**
 *  设置边框颜色
 *
 *  @param borderColor 可视化视图传入的值
 */
- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

-(UIColor *)borderColor
{
    return self.layer.borderColor;
}

/**
 *  设置圆角
 *
 *  @param cornerRadius 可视化视图传入的值
 */
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

//shadowColor阴影颜色
-(UIColor *)shadowColor
{
    return self.layer.shadowColor;
}

-(void)setShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}

//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
-(CGSize)shadowOffset
{
    return self.layer.shadowOffset;
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
    self.layer.shadowOffset = shadowOffset;
}

//阴影透明度，默认0
-(CGFloat)shadowOpacity
{
    return self.layer.shadowOpacity;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity;
}

//阴影半径，默认3
-(CGFloat)shadowRadius
{
    return self.layer.shadowRadius;
}

-(void)setShadowRadius:(CGFloat)shadowRadius
{
    self.layer.shadowRadius = shadowRadius;
}

-(BOOL)masksToBounds
{
    return self.layer.masksToBounds;
}

-(void)setMasksToBounds:(BOOL)masksToBounds
{
    self.layer.masksToBounds = masksToBounds;
}

@end
