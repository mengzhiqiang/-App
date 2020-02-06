//
//  FRIgoodsTableViewCell.h
//  SocialApp
//
//  Created by zhiqiang meng on 31/12/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRIGoodModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FRIgoodsTableViewCell : UITableViewCell

@property(nonatomic, strong)FRIGoodModel  * model ;

@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;


@end

NS_ASSUME_NONNULL_END
