//
//  DCStateItemCell.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/13.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCStateItemCell.h"
#import "DCStateItem.h"

@interface DCStateItemCell()

@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateBgImageView;

@end

@implementation DCStateItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [_orderCount draCirlywithColor:nil andRadius:_orderCount.height/2];
}

#pragma mark - 赋值
- (void)setStateItem:(DCStateItem *)stateItem
{
    _stateItem = stateItem;
    self.stateBgImageView.backgroundColor = [UIColor whiteColor];

    if (stateItem.showImage) {
        [self.stateButton setImage:[UIImage imageNamed:stateItem.imageContent] forState:0];
    }else{
        self.stateButton.left = 0;
        self.stateButton.width = self.width;
        [self.stateButton setTitle:stateItem.imageContent forState:0];
        self.stateLabel.top = 45 ;
    }
    
    self.stateLabel.text = stateItem.stateTitle;
    if (stateItem.orderCount>0) {
        _orderCount.hidden = NO;
    }else{
        _orderCount.hidden = YES;
    }
}

@end