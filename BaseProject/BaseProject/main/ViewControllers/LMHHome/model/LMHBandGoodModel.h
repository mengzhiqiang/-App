//
//  LMHBandGoodModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 23/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHBandGoodModel : NSObject

@property(nonatomic , strong)NSString * content;

@property(nonatomic , strong)NSString * brandName;
@property(nonatomic , strong)NSString * brandLogo;
@property(nonatomic , strong)NSString * endTime;
@property(nonatomic , strong)NSArray * goods;

@property(nonatomic , strong)NSString * brandId;  //品牌id

@property(nonatomic , strong)NSString * scheduleId;  //品牌id

@end

NS_ASSUME_NONNULL_END
