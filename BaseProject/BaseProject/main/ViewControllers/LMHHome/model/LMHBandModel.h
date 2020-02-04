//
//  LMHBandModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 3/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHBandModel : NSObject

@property(nonatomic , strong)NSString * brandName;
@property(nonatomic , strong)NSString * brandLogo;

@property(nonatomic , strong)NSString * brandDetails;
@property(nonatomic , strong)NSString * brandId;
@property(nonatomic , strong)NSString * createTime;
@property(nonatomic , strong)NSString * endTime;
@property(nonatomic , strong)NSString * goodsCount;
@property(nonatomic , strong)NSString * startTime;

@property(nonatomic , strong)NSString * isShelves;
////活动信息
@property(nonatomic , strong)NSString * url;
@property(nonatomic , strong)NSString * name;
@property(nonatomic , strong)NSString * desc;

@end

NS_ASSUME_NONNULL_END
