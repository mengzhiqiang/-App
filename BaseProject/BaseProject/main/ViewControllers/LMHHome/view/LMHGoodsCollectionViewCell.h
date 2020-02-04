//
//  LMHGoodsCollectionViewCell.h
//  BaseProject
//
//  Created by zhiqiang meng on 21/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomShadowView.h"
#import "LMHBandGoodModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMHGoodsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet CustomShadowView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *brandGoodOne;
@property (weak, nonatomic) IBOutlet UIImageView *brandGoodTwo;
@property (weak, nonatomic) IBOutlet UIImageView *brandGoodThree;
@property (weak, nonatomic) IBOutlet UILabel *freePostLabel;


@property (strong, nonatomic)  NSTimer *countDownTimer;
@property (assign, nonatomic)  NSInteger secondsCountDown;


@property (weak, nonatomic) IBOutlet UILabel *fistStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeStockLabel;

-(void)loadUI:(LMHBandGoodModel*)model;
@end

NS_ASSUME_NONNULL_END
