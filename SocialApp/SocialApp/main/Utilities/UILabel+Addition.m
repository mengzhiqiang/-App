//
//  UILabel+Addition.m
//  SocialApp
//
//  Created by zhiqiang meng on 15/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "UILabel+Addition.h"


@implementation UILabel (Addition)

#pragma mark 高度设置
+(CGFloat)cellHight:(NSString*)string{
    
    if (string==nil || [string isEqualToString:@""]) {
        return 1;
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
    CGFloat titleHeight;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX)options:options context:nil];
    titleHeight = ceilf(rect.size.height);
    return  titleHeight ;
}

-(CGFloat)contentHight{
    
   NSString*  string = self.text;
    if (string==nil || [string isEqualToString:@""]) {
        return 1;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:self.font range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:self.textColor range:allRange];
    CGFloat titleHeight;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX)options:options context:nil];
    titleHeight = ceilf(rect.size.height);
    return  titleHeight ;
}
@end
