//
//  FRIActiveTableViewCell.h
//  SocialApp
//
//  Created by zhiqiang meng on 14/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRIActiveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FRIActiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *lowView;
@property (weak, nonatomic) IBOutlet UIButton *pinglunButton;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (strong, nonatomic)  UICollectionView *imagScrollView;

@property (strong, nonatomic)  FRIActiveModel *model;

@end

NS_ASSUME_NONNULL_END
