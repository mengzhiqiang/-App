//
//  BSAddChildHeaderView.h
//  BikeStore
//
//  Created by libj on 2019/11/6.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBHTextFiled.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSAddChildHeaderView : UIView
@property (nonatomic, copy) void(^sendBlock)(void);
@property (nonatomic, copy) void(^cancelBtnBlock)(void);
@property (nonatomic, copy) void(^TextFieldDidChangeBlock)(NSString *text);
@property (nonatomic, strong) YBHTextFiled *textField;

@property (nonatomic, copy) NSString *textStr;
@property (nonatomic, copy) NSString *placeholder;

@end

NS_ASSUME_NONNULL_END
