//
//  AlipayManager.h
//  FindWorker
//
//  Created by zhiqiang meng on 26/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^BackBlockResult)(NSString *result);

NS_ASSUME_NONNULL_BEGIN

@interface AlipayManager : NSObject


@property (nonatomic, copy) BackBlockResult backResult;

+ (instancetype)sharedManager;

/**
 支付宝支付
 order  订单号   支付金额
 backResult  返回状态
 */
-(void)requestAliPayWithOrder:(NSString*)order sum:(NSString*)sum backResult:(BackBlockResult)backResult;
@end

NS_ASSUME_NONNULL_END
