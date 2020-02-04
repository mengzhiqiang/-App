//
//  LMHOrderListModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 6/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMHOrderbandsModel.h"
NS_ASSUME_NONNULL_BEGIN

//@class LMHOrderbandsModel;
@interface LMHOrderListModel : NSObject

@property(nonatomic , strong) NSString  * orderSn;
@property(nonatomic , strong) NSString  * creatTime;
@property (nonatomic, copy) NSString * identifier;
@property(nonatomic , strong) NSString  * orderCode;  //订单号


@property(nonatomic , strong) NSString  * pricePay;
@property(nonatomic , strong) NSString  * orderStatus;
@property(nonatomic , strong) NSString  * pricePostage;

@property(nonatomic , strong) NSString  * logisticsCompany;
@property(nonatomic , strong) NSString  * postageSn;
@property(nonatomic , strong) NSString  * logisticsCode;

@property(nonatomic , strong) NSString  * deliveryTime;
@property(nonatomic , strong) NSString  * payTime;
@property(nonatomic , strong) NSString  * takeTime;
@property(nonatomic , strong) NSString  * finishTime;



/* 售后*/
@property(nonatomic , strong) NSString  * orderId;
@property(nonatomic , strong) NSString  * cause;
@property(nonatomic , strong) NSString  * schedule;      // 处理进度(1处理中 2同意 3不同意 4退货中 5退款中 6已完成)
@property(nonatomic , strong) NSString  * refuseCause;  //拒绝原因


@property(nonatomic , strong) LMHOrderbandsModel  * brand;

@end


NS_ASSUME_NONNULL_END
