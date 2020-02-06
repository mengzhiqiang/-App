//
//  SAWithdrawRequest.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/24.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "SAWithdrawRequest.h"

@implementation SAWithdrawRequest
- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"api/user/with";
    self.addToken = YES;
}
@end
