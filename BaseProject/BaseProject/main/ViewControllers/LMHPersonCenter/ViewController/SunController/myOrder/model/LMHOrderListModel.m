//
//  LMHOrderListModel.m
//  BaseProject
//
//  Created by zhiqiang meng on 6/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHOrderListModel.h"

@implementation LMHOrderListModel

+ (void)load
{
    [LMHOrderListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identifier" : @"id"};
    }];
    
}

@end
