//
//  LMHOrderbandsModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 7/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHOrderbandsModel : NSObject
@property(nonatomic , strong) NSString  * brandLogo;
@property(nonatomic , strong) NSString  * brandName;
@property(nonatomic , strong) NSString  * goodsCount;
@property(nonatomic , strong) NSString  * order;

@property(nonatomic , strong) NSString  * goodName;
@property(nonatomic , strong) NSString  * goodLogo;

@property(nonatomic , strong) NSString  * specificationName;
@property(nonatomic , strong) NSString  * sellPrice;

@property(nonatomic , strong) NSString  * num;
@property(nonatomic , strong) NSString  * url;

@property(nonatomic , strong) NSString  * price;
@property(nonatomic , strong) NSString  * createTime;
@property(nonatomic , strong) NSString  * schedule;      ///处理进度(1处理中 2同意 3不同意 4退货中 5退款中 6已完成

@property(nonatomic , strong) NSMutableArray  * goodInfos;     


@end

NS_ASSUME_NONNULL_END
