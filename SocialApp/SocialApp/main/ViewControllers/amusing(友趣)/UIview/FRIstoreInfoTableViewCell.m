//
//  FRIstoreInfoTableViewCell.m
//  SocialApp
//
//  Created by zhiqiang meng on 2/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "FRIstoreInfoTableViewCell.h"

@implementation FRIstoreInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headView addSubview:self.starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(LEEStarRating*)starView{
    if (!_starView) {
        CGFloat width = 90;
        _starView = [[LEEStarRating alloc] initWithFrame:CGRectMake(165, 47, width, 44) Count:5];
        _starView.type = RatingTypeUnlimited;
        _starView.checkedImage = [UIImage imageNamed:@"icon_star"];
        _starView.uncheckedImage = [UIImage imageNamed:@"icon_star_gray"];
        _starView.currentScore = 4;
    }
    return _starView;
}

-(void)setModel:(FRImerchantModel *)model{
    _model = model;
    
    if (model) {
          [_headImagView setImageWithURL:[NSURL URLWithString:URL(model.merchantImg)] placeholderImage:[UIImage imageNamed:@""]];
          _headTitleLabel.text = model.merchantName;
          _starView.currentScore = [model.collect intValue];
          [_stroeStatueButton setTitle:(model.latitude?@"营业中":@"已停运") forState:UIControlStateNormal];
          _storeContentLabel.text = model.shopIntroduce;
          _scoreLabel.text = model.collect;
          
          _timeLabel.text = [NSString stringWithFormat:@"营业时间:%@",model.shopTime];
          _addressLabel.text = [NSString stringWithFormat:@"营业地址:%@",model.merchantAddress];
          _phoneLabel.text = [NSString stringWithFormat:@"营业时间:%@",model.shopPhone];
          
          _distanceLabel.text = [NSString distance:@{@"latitude":@(model.latitude),@"longitude":@(model.longitude)} point:@{@"latitude":@([TZLocationManager manager].locationManager.location.coordinate.latitude),@"longitude":@([TZLocationManager manager].locationManager.location.coordinate.longitude)}];
          
    }
  
}

- (IBAction)activeZan:(UIButton *)sender {
    
}

- (IBAction)tochAddressInfo:(UIButton *)sender {
    
    if (_backlocation) {
        _backlocation();
    }
}

@end
