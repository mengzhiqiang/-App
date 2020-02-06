//
//  FRIstoreCommentsTableViewCell.h
//  SocialApp
//
//  Created by zhiqiang meng on 2/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEEStarRating.h"
#import "FRIScoreModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FRIstoreCommentsTableViewCell : UITableViewCell

@property (strong, nonatomic) LEEStarRating *starView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property(nonatomic, strong) FRIScoreModel * model ;

@end

NS_ASSUME_NONNULL_END
