//
//  CustomlowTableView.h
//  BaseProject
//
//  Created by zhiqiang meng on 30/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomlowTableView : UIView

@property(nonatomic, strong)NSDictionary * costDiction ;

@property(nonatomic, copy) void (^backPay)(NSString * string) ;

@end

NS_ASSUME_NONNULL_END
