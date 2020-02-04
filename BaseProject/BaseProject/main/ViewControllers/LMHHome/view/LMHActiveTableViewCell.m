//
//  LMHActiveTableViewCell.m
//  BaseProject
//
//  Created by zhiqiang meng on 8/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHActiveTableViewCell.h"
#import "LMHCellSizeTools.h"
@implementation LMHActiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadUIWithData:(LMHBandModel*)model{
    
    _ActiveNameLabel.text = model.desc;
    _ActiveNameLabel.height = [LMHCellSizeTools cellHight:model.desc];
    [_ActiveImageView setImageWithURL:[model.url changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
  
    _ActiveImageView.width = SCREEN_WIDTH;
    _ActiveImageView.height = SCREEN_WIDTH*9/16;
    _ActiveNameLabel.top = _ActiveImageView.bottom+10;
    
}
@end
