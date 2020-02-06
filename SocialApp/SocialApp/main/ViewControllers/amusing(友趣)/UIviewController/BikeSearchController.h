//
//  BikeSearchController.h
//  BikeUser
//
//  Created by libj on 2019/11/16.
//  Copyright © 2019 gwp. All rights reserved.
//

#import "LMHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BikeSearchController : LMHBaseViewController
@property (nonatomic, assign) NSInteger type; //0 赛事搜索 1 门店搜索 2 赛事回顾搜索
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@end

NS_ASSUME_NONNULL_END
