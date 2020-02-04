//
//  LMHAfterSaleDetailVC.h
//  BaseProject
//
//  Created by wfg on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBaseViewController.h"
#import "LMHOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AfterSaleState) {
    AfterSaleStateDoing,
    AfterSaleStateSuccess,
};
@interface LMHAfterSaleDetailVC : LMHBaseViewController
@property (nonatomic, assign) AfterSaleState state;

//@property(nonatomic , strong)LMHOrderListModel * model ;
@property(nonatomic , strong)NSString * orderID ;

@end

NS_ASSUME_NONNULL_END
