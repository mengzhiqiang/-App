//
//  LMHBandTableViewCell.h
//  BaseProject
//
//  Created by zhiqiang meng on 22/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHBandModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMHBandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *serverButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

-(void)loadUIWithData:(LMHBandModel*)model;
@end

NS_ASSUME_NONNULL_END
