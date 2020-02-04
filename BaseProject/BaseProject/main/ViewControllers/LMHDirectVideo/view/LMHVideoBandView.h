//
//  LMHVideoBandView.h
//  BaseProject
//
//  Created by zhiqiang meng on 26/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMHVideoBandView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bandImageView;
@property (weak, nonatomic) IBOutlet UILabel *bandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoIDlabel;
@property (weak, nonatomic) IBOutlet UIView *goodView;
@property (weak, nonatomic) IBOutlet UIImageView *goodImagView;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (copy, nonatomic) void (^backIndex)(NSInteger index);
@property (strong, nonatomic) LMHVideoModel  *model;

@end

NS_ASSUME_NONNULL_END
