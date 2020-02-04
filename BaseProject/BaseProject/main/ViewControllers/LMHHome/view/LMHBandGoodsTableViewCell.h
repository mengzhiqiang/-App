//
//  LMHBandGoodsTableViewCell.h
//  BaseProject
//
//  Created by zhiqiang meng on 23/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomShadowView.h"
#import "LMHGoodDetailModel.h"
#import "LMHBandModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMHBandGoodsTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet CustomShadowView *shadowView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UIView *lowView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *BGView;

@property (weak, nonatomic) IBOutlet UITextField *goodCountTextField;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *freeCostButton;

@property (strong, nonatomic) LMHGoodDetailModel *goodModel;

@property(nonatomic, strong) LMHBandModel *  bandModel ;

@end

NS_ASSUME_NONNULL_END
