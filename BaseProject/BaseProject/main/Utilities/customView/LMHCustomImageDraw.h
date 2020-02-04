//
//  LMHCustomImageDraw.h
//  BaseProject
//
//  Created by zhiqiang meng on 16/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMHGoodDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMHCustomImageDraw : NSObject
/**
 主图
 */
+(UIImage*)DrawMainImageWithModel:(LMHGoodDetailModel*)model andimages:(NSArray*)images addPrice:(NSString*)addPrice;

/**
 尺码图
 */
+(UIImage*)DrawSizeImageWithModel:(LMHGoodDetailModel*)model andimages:(NSArray*)images addPrice:(NSString*)addPrice;

/**
 单图
 */
+(UIImage*)DrawSigleImageWithModel:(LMHGoodDetailModel*)model andimages:(NSArray*)images addPrice:(NSString*)addPrice;

/**
 四张图
 */
+(NSArray*)DrawFoureImageWithModel:(LMHGoodDetailModel*)model andimages:(NSArray*)images addPrice:(NSString*)addPrice;

@end

NS_ASSUME_NONNULL_END
