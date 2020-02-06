//
//  SAUserWalletRequest.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/19.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "SAUserWalletRequest.h"

@implementation SAUserWalletRequest
- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/app/user/money/detail";
    self.addToken = YES;
    self.type = @"1";
    self.page = 1;
}
@end
