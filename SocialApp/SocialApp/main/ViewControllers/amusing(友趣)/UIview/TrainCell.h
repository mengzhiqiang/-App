//
//  TrainCell.h
//  BikeUser
//
//  Created by 高伟鹏 on 2019/8/28.
//  Copyright © 2019 gwp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRIActiveListModel.h"
NS_ASSUME_NONNULL_BEGIN
//@class BikeStoreModel;
//@class BikeCollectModel;
@interface TrainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel; // 门店名字
@property (weak, nonatomic) IBOutlet UIImageView *addressIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel; // 地址
@property (weak, nonatomic) IBOutlet UILabel *collectLabel; // 关注人数
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 距离
@property (weak, nonatomic) IBOutlet UILabel *activeStyleLabel;

@property (strong, nonatomic)  FRIActiveListModel *model;

//@property (nonatomic, strong) BikeStoreModel *model;
//@property (nonatomic, strong) BikeCollectModel *collectModel;
@end

NS_ASSUME_NONNULL_END
