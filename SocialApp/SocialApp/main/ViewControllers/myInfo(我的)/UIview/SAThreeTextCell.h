//
//  SAThreeTextCell.h
//  SallyDiMan
//
//  Created by wfg on 2019/10/10.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SAUserWalletModel.h"
//#import "SAUserPointsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SAThreeTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

//- (void)updateData:(SAWalletRecordModel *)model;
//- (void)updateData2:(SAPointsRecordModel *)model;

@end

NS_ASSUME_NONNULL_END
