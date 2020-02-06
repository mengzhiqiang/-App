//
//  FRIActiveLIistViewController.h
//  SocialApp
//
//  Created by zhiqiang meng on 2/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "LMHBaseViewController.h"
#import "FRIGoodModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FRIActiveLIistViewController : LMHBaseViewController

@property(nonatomic, copy)  void (^backActiveModel)(FRIGoodModel* model);

@property (nonatomic, strong) NSString * storeID;

@end

NS_ASSUME_NONNULL_END
