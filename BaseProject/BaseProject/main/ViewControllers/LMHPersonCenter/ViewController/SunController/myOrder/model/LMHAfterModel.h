//
//  LMHAfterModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 21/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHAfterModel : NSObject

@property(nonatomic , strong) NSString  * cause;
@property(nonatomic , strong) NSString  * creatTime;
@property(nonatomic , strong) NSString  * saleType;
@property(nonatomic , strong) NSString  * orderSn;
@property(nonatomic , strong) NSString  * schedule;   ///处理进度(1处理中 2同意 3不同意 4退货中 5退款中 6已完成

@property(nonatomic , strong) NSString  * returnAddress;
@property(nonatomic , strong) NSString  * postcode;

@property(nonatomic , strong) NSString  * deliveryTime;
@property(nonatomic , strong) NSString  * finishTime;

@property(nonatomic , strong) NSString  * userName;


@end

NS_ASSUME_NONNULL_END
