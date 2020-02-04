//
//  LMHVideoModel.m
//  BaseProject
//
//  Created by zhiqiang meng on 22/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHVideoModel.h"

@implementation LMHVideoModel

+ (void)load
{
    [LMHVideoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identifier" : @"id"};
    }];
    
}
@end
