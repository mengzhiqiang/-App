//
//  FRIMineInfoEditRequest.m
//  SocialApp
//
//  Created by wfg on 2020/1/8.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "FRIMineInfoEditRequest.h"

@implementation FRIMineInfoEditRequest
- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/app/user/set";
    self.addToken = YES;
}
@end
