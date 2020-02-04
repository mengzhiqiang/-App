//
//  LMHAfterSaleRecordCell.m
//  BaseProject
//
//  Created by wfg on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAfterSaleRecordCell.h"

@implementation LMHAfterSaleRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)afterClick:(UIButton *)sender {
    if (_backQuestAfter) {
        _backQuestAfter();
    }
}

@end
