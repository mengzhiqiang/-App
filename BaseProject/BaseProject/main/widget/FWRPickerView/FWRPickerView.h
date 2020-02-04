//
//  FWRPickerView.h
//  FindWorker
//
//  Created by zhiqiang meng on 11/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, pickerDataType) {
    pickerDataTypeTime = 1 << 1,
    pickerDataTypeDay = 1 << 2,
    //LMH余额明细筛选
    pickerDataTypeAccount = 1 << 3,
    //LMH团队中心起止时间
    pickerDataTypeTeam = 1 << 4,
};

@interface FWRPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic)  UIPickerView *pickerView;
@property (copy, nonatomic)  void (^backPickerInfo)(NSDictionary *diction);

-(void)setupPickerStyle:(pickerDataType)style;
- (void)showPickerView;
@end

NS_ASSUME_NONNULL_END
