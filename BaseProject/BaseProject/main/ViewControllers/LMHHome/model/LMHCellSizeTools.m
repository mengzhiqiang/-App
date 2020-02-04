//
//  LMHCellSizeTools.m
//  BaseProject
//
//  Created by zhiqiang meng on 7/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHCellSizeTools.h"

@implementation LMHCellSizeTools


/**
 
 根据规格宽度判断是一行展示多少个
 宽度大于一半cell宽度 一行显示一个
 宽度小于一半cell宽度  大于三分之一cell宽度 一行显示两个
 否则 一行显示3个
 */
+(NSInteger)cellWith:(NSString*)string{
    
    if (string==nil || [string isEqualToString:@""]) {
        return 1;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
    CGFloat titleWith;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, 20)options:options context:nil];
    titleWith = ceilf(rect.size.width);
    
    if (titleWith>=(SCREEN_WIDTH-60)/2) {
        return  1;
    }else  if (titleWith<(SCREEN_WIDTH-60)/2 && titleWith>(SCREEN_WIDTH-60)/3) {
        return  2;
    }else {
        return 3;
    }
    
}

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
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, CGFLOAT_MAX)options:options context:nil];
    titleHeight = ceilf(rect.size.height);
    return  titleHeight ;
}

+(CGFloat)cellHeightOfModel:(LMHGoodDetailModel*)model{
    
//    NSString * string = [NSString stringWithFormat:@"%@ \n%@ \n款号：%@" ,model.goodsName ,model.goodsDesc,model.goodsNote];
//    NSString * string = [NSString stringWithFormat:@"%@ \n%@" ,model.goodsName ,model.goodsDesc];
    NSString * string = [NSString stringWithFormat:@"%@、%@-¥%@ \n%@" ,model.goodsNote,model.goodsName,model.recommendedPrice ,model.goodsDesc];

    NSInteger contentH = [self  cellHight:string];
    
    NSString * specificationName;NSInteger count=0;
    if (model.specifications.count) {
        count = model.specifications.count;
        specificationName = [model.specifications.firstObject objectForKey:@"specificationName"];
    }else if(model.goodsSpecifications.count){
        count = model.goodsSpecifications.count;
        specificationName = [model.goodsSpecifications.firstObject objectForKey:@"specificationName"];
    }else{
        specificationName = @"1";
    }
    long  guigeCount = (count%[self cellWith:specificationName]==0? count/[self cellWith:specificationName]:count/[self cellWith:specificationName]+1);
    
    NSInteger cout = model.goodsPicList.count;
    if (cout<1) {
        cout = model.goodsPics.count;
    }
    CGFloat collectHeight = (cout>6?3:2)*(95*RATIO_IPHONE6+5) + guigeCount*45+35;
    
    return collectHeight+contentH;
}

@end
