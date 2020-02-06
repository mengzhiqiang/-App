//
//  SARechargeRequest.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/19.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "SARechargeRequest.h"

@implementation SARechargeRequest
- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"api/user/recharge";
    self.addToken = YES;
    self.source = @"2";
}
@end
