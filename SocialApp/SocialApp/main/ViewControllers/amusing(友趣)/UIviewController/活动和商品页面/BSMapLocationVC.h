//
//  BSMapLocationVC.h
//  BikeStore
//
//  Created by wfg on 2019/11/22.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBaseViewController.h"
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSMapLocationVC : LMHBaseViewController

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

NS_ASSUME_NONNULL_END
