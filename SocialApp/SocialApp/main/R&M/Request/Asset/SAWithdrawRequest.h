//
//  SAWithdrawRequest.h
//  SallyDiMan
//
//  Created by wfg on 2019/10/24.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "GeneralParamRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SAWithdrawRequest : GeneralParamRequest
@property (nonatomic, strong) NSString *price;
/// 提现类型 2=微信；3=支付宝
@property (nonatomic, strong) NSString *type;
///     手机验证码
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *tel;
/// 支付宝收款账户，提现类型=支付宝的必须传；
@property (nonatomic, strong) NSString *receipt;
/// 支付宝账户收款人姓名，提现类型=支付宝的必须传；
@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
