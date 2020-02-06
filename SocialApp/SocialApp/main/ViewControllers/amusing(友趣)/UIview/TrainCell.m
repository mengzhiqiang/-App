//
//  TrainCell.m
//  BikeUser
//
//  Created by 高伟鹏 on 2019/8/28.
//  Copyright © 2019 gwp. All rights reserved.
//

#import "TrainCell.h"
//#import "BikeStoreModel.h"
//#import "BikeCollectModel.h"

@implementation TrainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_activeStyleLabel draCirlywithColor:nil andRadius:8.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FRIActiveListModel *)model {
    _model = model;
    self.storeNameLabel.text = model.activityName;
    [self.showImage sd_setImageWithUrlString:model.commodityImg placeholderImage:[UIImage imageNamed:@""]];
    self.addressLabel.text = model.merchantAddress;
 
    self.timeLabel.text = model.activityTime;
    self.collectLabel.text = (model.activityNum?model.activityNum:@"22");

    if (model.activitySponsor.intValue==2) {
        self.activeStyleLabel.text = @"商家";
    }else{
        self.activeStyleLabel.text = @"个人";
    }
    
}
//
//- (void)setCollectModel:(BikeCollectModel *)collectModel {
//    _collectModel = collectModel;
//    self.storeNameLabel.text = collectModel.store.name;
//    [self.showImage sd_setImageWithUrlString:collectModel.store.logo];
//    self.addressLabel.text = collectModel.store.address;
//    self.distance.text = FORMAT(@"%.0fkm",collectModel.destation);
//    if (collectModel.destation < 1) {
//        self.distance.text = @"小于1km";
//    }else {
//        self.distance.text = FORMAT(@"%.0fkm",collectModel.destation);
//    }
//    self.collectLabel.text = FORMAT(@"%zd人关注",collectModel.collect_count);
//}

@end
