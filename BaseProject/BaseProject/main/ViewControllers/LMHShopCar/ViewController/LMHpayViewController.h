//
//  LMHpayViewController.h
//  BaseProject
//
//  Created by zhiqiang meng on 30/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBaseViewController.h"
#import "DCShopModel.h"
#import "LMHAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMHpayViewController : LMHBaseViewController

@property(nonatomic,strong) NSMutableArray <DCShopModel*> *buyList ;

@property(nonatomic,strong)LMHAddressModel * addressModel;

@end

NS_ASSUME_NONNULL_END
