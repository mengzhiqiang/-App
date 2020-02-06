//
//  FRIstoreCommentsTableViewCell.m
//  SocialApp
//
//  Created by zhiqiang meng on 2/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "FRIstoreCommentsTableViewCell.h"

@implementation FRIstoreCommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubview:self.starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(LEEStarRating*)starView{
    if (!_starView) {
        CGFloat width = 90;
        _starView = [[LEEStarRating alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-width-40, 23.5, width, 20) Count:5];
        _starView.type = RatingTypeUnlimited;
        _starView.checkedImage = [UIImage imageNamed:@"icon_star"];
        _starView.uncheckedImage = [UIImage imageNamed:@"icon_star_gray"];
        _starView.currentScore = 4;

    }
    return _starView;
}

-(void)setModel:(FRIScoreModel *)model{
    
    [_userImageView setImageWithURL:[NSURL URLWithString:URL(model.userImg)] placeholderImage:[UIImage imageNamed:@""]];
    _userNameLabel.text    = model.userNickname;
    _starView.currentScore = model.userEvaluate.intValue;
    _scoreLabel.text       = [NSString stringWithFormat:@"%.1f",model.userEvaluate.floatValue];
    _timeLabel.text        = model.evaluateTime;
}

@end
