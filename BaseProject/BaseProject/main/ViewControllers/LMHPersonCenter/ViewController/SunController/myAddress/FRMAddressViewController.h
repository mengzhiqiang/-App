//
//  FRMAddressViewController.h
//  FindWorker
//
//  Created by zhiqiang meng on 18/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBaseViewController.h"
#import "LMHAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FRMAddressViewController : LMHBaseViewController

@property(nonatomic,strong)LMHAddressModel * addressModel;

@property(nonatomic,assign)BOOL IsCarSelect;

@property(nonatomic,copy)void (^backAddress)(LMHAddressModel*model);

@end

NS_ASSUME_NONNULL_END
