//
//  BENRegisterViewController.h
//  FindWorker
//
//  Created by zhiqiang meng on 4/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BENRegisterViewController : LMHBaseViewController

@property (nonatomic, assign) NSInteger registerType; // 0 注册，1 微信绑定手机号
@property (nonatomic, copy) NSDictionary *wxObject;
@end

NS_ASSUME_NONNULL_END
