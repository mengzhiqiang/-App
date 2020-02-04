//
//  LMHForwardingPriceView.h
//  BaseProject
//
//  Created by wfg on 2019/9/3.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHForwardingPriceView : UIView

@property(nonatomic ,copy)void (^backload)(NSString * price);

@property(nonatomic ,copy)void (^backchange)(void);

@end

NS_ASSUME_NONNULL_END
