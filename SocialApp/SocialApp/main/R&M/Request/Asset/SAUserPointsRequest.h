//
//  SAUserPointsRequest.h
//  SallyDiMan
//
//  Created by wfg on 2019/10/19.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "GeneralParamRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SAUserPointsRequest : GeneralParamRequest

/// 1收入，2支出
@property (nonatomic, assign) NSInteger cate;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *month;
@end

NS_ASSUME_NONNULL_END
