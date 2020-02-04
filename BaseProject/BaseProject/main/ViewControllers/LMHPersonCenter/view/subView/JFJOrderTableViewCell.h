//
//  JFJOrderTableViewCell.h
//  jiefujia
//
//  Created by zhiqiang meng on 22/3/2019.
//  Copyright © 2019 TeeLab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFJOrderTableViewCell : UITableViewCell

//Cell 0
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oredreImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderSumLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (copy, nonatomic) void (^backSelect)(NSString * style);
@property (weak, nonatomic) IBOutlet UIView *sumCostLabel;
@property (weak, nonatomic) IBOutlet UIView *rootView;

//CELL 1
@property (weak, nonatomic) IBOutlet UIView *rootCellView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sleepCountLabel;

//CELL 2
@property (weak, nonatomic) IBOutlet UIView *threeBgView;
@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;
@property (weak, nonatomic) IBOutlet UILabel *threeTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *threeSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *threePriceLabel;


@end

NS_ASSUME_NONNULL_END
