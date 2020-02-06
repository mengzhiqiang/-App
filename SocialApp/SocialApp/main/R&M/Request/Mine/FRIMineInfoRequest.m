//
//  FRIMineInfoRequest.m
//  SocialApp
//
//  Created by wfg on 2020/1/8.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "FRIMineInfoRequest.h"

@implementation FRIMineInfoRequest
- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/app/user/me";
    self.addToken = YES;
}
@end
