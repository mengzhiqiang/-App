//
//  LMHCellSizeTools.h
//  BaseProject
//
//  Created by zhiqiang meng on 7/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMHGoodDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMHCellSizeTools : NSObject


/**
 
 根据规格宽度判断是一行展示多少个
 宽度大于一半cell宽度 一行显示一个
 宽度小于一半cell宽度  大于三分之一cell宽度 一行显示两个
 否则 一行显示3个
 */
+(NSInteger)cellWith:(NSString*)string;

/**
   字符串
   返回高度
 */
+(CGFloat)cellHight:(NSString*)string;

+(CGFloat)cellHeightOfModel:(LMHGoodDetailModel*)model;
@end

NS_ASSUME_NONNULL_END
