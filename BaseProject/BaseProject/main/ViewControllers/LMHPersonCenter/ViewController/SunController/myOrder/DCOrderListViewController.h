//
//  DCOrderListViewController.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 30/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCOrderListViewController : LMHBaseViewController

@property(assign,nonatomic) int  selectIndex ;

-(void)GetAllOrder;
@end

NS_ASSUME_NONNULL_END