//
//  LrdOutPutViewCell.m
//  ZJDL
//
//  Created by lonkyle on 17/1/7.
//  Copyright © 2017年 lonkyle. All rights reserved.
//

#import "LrdOutPutViewCell.h"

@implementation LrdOutPutViewCell
-(void)setLrdCellModel:(LrdCellModel *)LrdCellModel
{
    _LrdCellModel  =LrdCellModel;
    if (LrdCellModel.isSelect == YES) {
        self.pictureImageView.hidden = NO;
        self.contentLabel.textColor = rgba(0, 162, 231, 1);
    }
    else{
        self.pictureImageView.hidden = YES;
        self.contentLabel.textColor = rgba(51, 51, 51, 1);

    }
    self.contentLabel.text = LrdCellModel.title;
}

- (void)setTwoModel:(TwoLrdCellModel *)twoModel {
    _twoModel =twoModel;
    if (twoModel.isSelect == YES) {
        self.contentLabel.textColor = HKColor(@"#00A2E7");
        self.pictureImageView.image = UIImageName(@"btn_choose");
    }else{
        self.contentLabel.textColor = HKColor(@"#333333");
        self.pictureImageView.image = UIImageName(@"btn_round_default");
    }

    self.contentLabel.text = twoModel.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
