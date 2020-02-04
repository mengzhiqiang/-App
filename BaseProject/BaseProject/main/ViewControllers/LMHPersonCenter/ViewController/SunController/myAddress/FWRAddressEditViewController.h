//
//  FWRAddressEditViewController.h
//  FindWorker
//
//  Created by zhiqiang meng on 18/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBaseViewController.h"
#import "LMHAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FWRAddressEditViewController : LMHBaseViewController

@property(nonatomic, strong) NSDictionary * addressData ;

@property(nonatomic, strong) LMHAddressModel * addressModel ;

@end

NS_ASSUME_NONNULL_END
