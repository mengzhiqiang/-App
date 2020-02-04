//
//  LMHSearchTableViewCell.h
//  BaseProject
//
//  Created by zhiqiang meng on 21/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandTimeLabel;

@end

NS_ASSUME_NONNULL_END
