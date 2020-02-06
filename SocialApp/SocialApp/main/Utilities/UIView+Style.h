//
//  UIView+Style.h
//
//  Created by kunge on 15/11/20.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE  // 动态刷新

@interface UIView (Style)
/**设置圆角边框*/
-(void)setBorderwithColor:(UIColor *)color withWidth:(CGFloat)width withRadius:(CGFloat)radius;
/**设置圆角*/
-(void)setRadius:(CGFloat)radius;
/**设置边框*/
-(void)setBorderwithColor:(UIColor *)color withWidth:(CGFloat)width;
/**设置阴影*/
-(void)setShadowWithColour:(UIColor *)color withOffset:(CGSize)offset withOpacity:(CGFloat)opacity withRadius:(CGFloat)radius;

// 注意: 加上IBInspectable就可以可视化显示相关的属性哦
/** 可视化设置边框宽度 */
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
/** 可视化设置边框颜色 */
@property (nonatomic, strong)IBInspectable UIColor *borderColor;
/** 可视化设置圆角 */
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
/** 可视化设置阴影颜色*/
@property (nonatomic, assign)IBInspectable UIColor *shadowColor;
/** 可视化设置阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用*/
@property (nonatomic, assign)IBInspectable CGSize shadowOffset;
/** 可视化设置阴影透明度*/
@property (nonatomic, assign)IBInspectable CGFloat shadowOpacity;
/** 可视化设置阴影半径*/
@property (nonatomic, assign)IBInspectable CGFloat shadowRadius;
/** 可视化设置是否切掉圆角*/
@property (nonatomic, assign)IBInspectable BOOL masksToBounds;
@end
