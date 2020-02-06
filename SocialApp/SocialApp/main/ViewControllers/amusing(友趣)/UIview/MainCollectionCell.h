//
//  MainCollectionCell.h
//  BikeUser
//
//  Created by libj on 2019/11/1.
//  Copyright © 2019 gwp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEEStarRating.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *applyBtn; //报名
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (strong, nonatomic) LEEStarRating *starView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;



@end

NS_ASSUME_NONNULL_END
