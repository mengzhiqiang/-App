//
//  SAUserWalletRequest.h
//  SallyDiMan
//
//  Created by wfg on 2019/10/19.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "GeneralParamRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SAUserWalletRequest : GeneralParamRequest
/// 类型；1=收入明细；2=支出明细
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger page;

@end

NS_ASSUME_NONNULL_END
