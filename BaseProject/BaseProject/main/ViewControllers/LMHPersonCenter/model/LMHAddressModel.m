//
//  LMHAddressModel.m
//  BaseProject
//
//  Created by zhiqiang meng on 4/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAddressModel.h"

@implementation LMHAddressModel

+ (void)load
{
    [LMHAddressModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identifier" : @"id"};
    }];
    
}
@end
