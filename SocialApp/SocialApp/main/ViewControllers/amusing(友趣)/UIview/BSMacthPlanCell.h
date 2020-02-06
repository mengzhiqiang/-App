//
//  BSMacthPlanCell.h
//  BikeStore
//
//  Created by libj on 2019/11/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BSMacthPlanCell;
@protocol BSMacthPlanCellDelegate <NSObject>

- (void)BSMacthPlanCell:(BSMacthPlanCell *)cell textString:(NSString *)textString;

@end

typedef NS_ENUM(NSInteger,TextFieldType) {
    textFieldType_default = 0, // 正常输入
    textFieldType_select = 1, // 不可输入
    textFieldType_select_icon = 2, // 不可输入，有icon
};
@interface BSMacthPlanCell : UITableViewCell
@property (nonatomic, assign) TextFieldType textFieldType;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *textStr;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, weak) id<BSMacthPlanCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
