//
//  PLQRCodeViewController.h
//  PieLifeApp
//
//  Created by libj on 2019/7/31.
//  Copyright © 2019 Libj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHBaseViewController.h"
#import "SWQRCode.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^getValeBLock)(NSString *value);

@interface PLQRCodeViewController : LMHBaseViewController
@property (nonatomic, strong) SWQRCodeConfig *codeConfig;

@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *gameActiveID;

/** value **/
@property (nonatomic,copy)getValeBLock  block;
@end

NS_ASSUME_NONNULL_END
