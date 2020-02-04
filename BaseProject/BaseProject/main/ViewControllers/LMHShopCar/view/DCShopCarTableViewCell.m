//
//  DCShopCarTableViewCell.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 29/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCShopCarTableViewCell.h"

@implementation DCShopCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editCount:(UIButton *)sender {
    
    if (_backSelect) {
        _backSelect(nil);
    }
    /*
    int shopCount = [_shopCar.num intValue];
    if (sender.tag==10) {
        
        if (shopCount>1) {
            shopCount--;
        }else{
            shopCount=1;
        }
    }else{
        
        if (shopCount<[_shopCar.stock intValue]) {
            shopCount ++;
        }else{
            shopCount = [_shopCar.stock intValue];
        }
        
    }
    if ( [_shopCar.stock intValue]==0) {
        shopCount = 1 ;
    }
    
    _countTF.text = [NSString stringWithFormat:@"%d",shopCount];
    _shopCar.num = _countTF.text;
    if (_backShopCount) {
        _backShopCount(_shopCar);
    }
     */
    
}
- (IBAction)selcetRow:(UIButton *)sender {
    
    _shopCar.isSelect = !_shopCar.isSelect ;
    if (_backSelect) {
        _backSelect(_shopCar);
    }
}

-(void)setShopCar:(DCShopCarModel *)shopCar{
    _shopCar = shopCar;
    
    _goodsTitleLabel.text = shopCar.goodsName ;
    _goodsdetailLabel.text = [NSString stringWithFormat:@"%@ x%@",shopCar.goodsSpecifications,shopCar.num];
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",shopCar.price.floatValue];
    _countTF.text = shopCar.num;
    
    [_shopImageView setImageWithURL:[shopCar.goodsUrl changeURL] placeholderImage:[UIImage imageNamed:DefluatPic] ];
    
    if (_shopCar.isSelect) {
        [_selectButton setImage:[UIImage imageNamed:@"gwc_icon_xjdz_swmrdz1"] forState:UIControlStateNormal];
    }else{
        [_selectButton setImage:[UIImage imageNamed:@"gwc_icon_xjdz_swmrdz"] forState:UIControlStateNormal];
    }
}

@end
