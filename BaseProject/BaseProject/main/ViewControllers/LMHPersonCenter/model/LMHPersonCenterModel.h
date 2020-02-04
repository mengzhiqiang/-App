//
//  LMHPersonCenterModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 11/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHPersonCenterModel : NSObject

/** 余额 */
@property (nonatomic, copy) NSString *balance;
/** 奖金累计 */
@property (nonatomic, copy) NSString * rebateMoney;
/** 今日销售 */
@property (nonatomic, copy) NSString * dayConsume;
/** 本月销售  */
@property (nonatomic, copy) NSString * monthConsume;

/** 待付款数据 */
@property (nonatomic, copy) NSString * waitPayment;
/** dai 发货 */
@property (nonatomic, copy) NSString * waitDeliver;
/** 待收货 */
@property (nonatomic, copy) NSString * waitTake;
/** 售后 */
@property (nonatomic, copy) NSString * afterSales;

/** 用户名 */
@property (nonatomic, copy) NSString * userName;
/** portrait头像 */
@property (nonatomic, copy) NSString * portrait;
/** 当前等级 */
@property (nonatomic, copy) NSString * levelName;
/** 下一级等级名称 */
@property (nonatomic, copy) NSString * uplevelName;
/** 下一级等级需金额 */
@property (nonatomic, copy) NSString * requiredMoney;

/** 未读消息数 */
@property (nonatomic, copy) NSString * unreadAmount;

@end

NS_ASSUME_NONNULL_END
