//
//  SAThreeTextCell.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/10.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "SAThreeTextCell.h"

@implementation SAThreeTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)updateData:(SAWalletRecordModel *)model {
//    self.titleLbl.text = model.desc;
//    self.rightLbl.text = model.price;
//    self.dateLbl.text = model.add_time.length > 10 ? [model.add_time substringToIndex:10] : model.add_time;
//}
//
//- (void)updateData2:(SAPointsRecordModel *)model {
//    self.titleLbl.text = model.desc;
//    self.rightLbl.text = [NSString stringWithFormat:@"%@%@", model.type, model.point];
//    self.dateLbl.text = model.add_time.length > 10 ? [model.add_time substringToIndex:10] : model.add_time;
//}
@end
