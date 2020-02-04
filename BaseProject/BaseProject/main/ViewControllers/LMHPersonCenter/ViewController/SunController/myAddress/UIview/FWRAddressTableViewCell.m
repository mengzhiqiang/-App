//
//  FWRAddressTableViewCell.m
//  FindWorker
//
//  Created by zhiqiang meng on 18/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FWRAddressTableViewCell.h"

@implementation FWRAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_defaultLabel draCirlywithColor:Main_Color andRadius:1.0f];
    _repaceLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:125/255.0 blue:26/255.0 alpha:0.5];;
    [_repaceLabel draCirlywithColor:nil andRadius:_repaceLabel.height/2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editAddress:(UIButton *)sender {
    
    if (_backEditAddress) {
        _backEditAddress();
    }
}

-(void)setAddressModel:(LMHAddressModel *)addressModel{
    _addressModel = addressModel;
    
    self.addrssNameLabel.text    = [NSString stringWithFormat:@"%@",_addressModel.name];
    self.phoneLabel.text         = [NSString stringWithFormat:@"%@",[_addressModel.phone changePhone]];
    self.addressDetailLabel.text = [NSString stringWithFormat:@"%@%@%@\n%@",_addressModel.provinceId,_addressModel.cityId,_addressModel.areaId,_addressModel.address];
    if (_addressModel.isDefault) {
        self.defaultLabel.hidden = NO;
    }else{
        self.defaultLabel.hidden = YES;
    }
    if (_addressModel.isTake) {
        self.repaceLabel.hidden = NO;
    }else{
        self.repaceLabel.hidden = YES;
    }
    
}

@end
