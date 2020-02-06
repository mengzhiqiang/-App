//
//  LMHHomeTableViewController.h
//  BaseProject
//
//  Created by zhiqiang meng on 21/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMHHomeTableViewController : LMHBaseViewController

@property(nonatomic ,copy) NSString  * cityName;

@property(nonatomic ,assign) NSInteger  Index;

@property(nonatomic ,assign) CLLocationCoordinate2D  locition;


-(void)loadNewData;

@end

NS_ASSUME_NONNULL_END
