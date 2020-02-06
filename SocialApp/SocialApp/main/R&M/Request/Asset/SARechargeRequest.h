//
//  SARechargeRequest.h
//  SallyDiMan
//
//  Created by wfg on 2019/10/19.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "GeneralParamRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SARechargeRequest : GeneralParamRequest
@property (nonatomic, strong) NSString *price;
/// 充值类型 2=微信；3=支付宝
@property (nonatomic, strong) NSString *pay_type;
/// 小程序支付需要传code
@property (nonatomic, strong) NSString *code;
/// 来源 1=小程序；2=app
@property (nonatomic, strong) NSString *source;

@end

NS_ASSUME_NONNULL_END
