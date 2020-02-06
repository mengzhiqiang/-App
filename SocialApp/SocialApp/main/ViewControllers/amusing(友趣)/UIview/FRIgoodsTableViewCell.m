//
//  FRIgoodsTableViewCell.m
//  SocialApp
//
//  Created by zhiqiang meng on 31/12/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIgoodsTableViewCell.h"

@implementation FRIgoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(FRIGoodModel *)model{
    
    [_goodImageView setImageWithURL:[NSURL URLWithString:URL(model.commodityImg)] placeholderImage:[UIImage imageNamed:@""]];
    _goodTitleLabel.text = model.commodityName;
    _goodCountLabel.text = [NSString stringWithFormat:@"人数上限:%@",model.maxNum];
    _goodTimeLabel.text = [NSString stringWithFormat:@"提前%d小时可退",model.advanceHour.intValue];
    _goodPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",model.commodityPrice.floatValue];;
    
}

@end
