//
//  FRIPersonInfoTableViewCell.h
//  SocialApp
//
//  Created by zhiqiang meng on 15/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FRIPersonInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *useImageView;
@property (weak, nonatomic) IBOutlet UILabel *useNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *useIDLabel;
@property (weak, nonatomic) IBOutlet UIButton *userAddressButton;
@property (weak, nonatomic) IBOutlet UIView *lowView;
@property (weak, nonatomic) IBOutlet UILabel *certificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;

@end

NS_ASSUME_NONNULL_END
