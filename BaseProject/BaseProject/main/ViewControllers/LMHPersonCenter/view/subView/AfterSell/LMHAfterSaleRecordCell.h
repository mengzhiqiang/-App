//
//  LMHAfterSaleRecordCell.h
//  BaseProject
//
//  Created by wfg on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface LMHAfterSaleRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *contentIV;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *subContentLbl;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UIButton *afterButton;

@property (copy, nonatomic) void (^backQuestAfter)();

@end

NS_ASSUME_NONNULL_END
