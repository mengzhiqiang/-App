//
//  FRIstoreInfoTableViewCell.h
//  SocialApp
//
//  Created by zhiqiang meng on 2/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEEStarRating.h"
#import "FRImerchantModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRIstoreInfoTableViewCell : UITableViewCell
@property (strong, nonatomic) LEEStarRating *starView;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImagView;
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *stroeStatueButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;

@property (weak, nonatomic) IBOutlet UILabel *storeContentLabel;

@property (weak, nonatomic) IBOutlet UIView *addrssView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic)  FRImerchantModel *model;

@property (nonatomic , copy)void  (^backlocation)(void);

@end

NS_ASSUME_NONNULL_END
