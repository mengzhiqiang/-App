//
//  SAUserPointsRequest.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/19.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "SAUserPointsRequest.h"

@implementation SAUserPointsRequest
- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"api/Users/getUserPointList";
    self.addToken = YES;
    self.cate = 1;
    self.page = 1;
}
@end
