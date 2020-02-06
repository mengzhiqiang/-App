//
//  MainCollectionCell.m
//  BikeUser
//
//  Created by libj on 2019/11/1.
//  Copyright © 2019 gwp. All rights reserved.
//

#import "MainCollectionCell.h"
@implementation MainCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@179);
    }];
    
    [self addSubview:self.starView];

}
-(LEEStarRating*)starView{
    if (!_starView) {
        CGFloat width = 90;
        _starView = [[LEEStarRating alloc] initWithFrame:CGRectMake(188, 105, width, 44) Count:5];
        _starView.type = RatingTypeUnlimited;
        _starView.checkedImage = [UIImage imageNamed:@"icon_star"];
        _starView.uncheckedImage = [UIImage imageNamed:@"icon_star_gray"];
        _starView.currentScore = 4;

    }
    return _starView;
}


@end
