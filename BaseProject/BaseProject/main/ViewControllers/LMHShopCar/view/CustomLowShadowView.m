//
//  CustomLowShadowView.m
//  BaseProject
//
//  Created by zhiqiang meng on 30/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "CustomLowShadowView.h"

@implementation CustomLowShadowView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    
    _shadowView = [[CustomShadowView alloc]init];
    _shadowView.backgroundColor = White_Color;
    [self addSubview:_shadowView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor HexString:@"FF4444"];
    _titleLabel.font = PFR14Font;
    _titleLabel.text = @"¥ 1350.00";
    [self addSubview:_titleLabel];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.titleLabel.font = PFR14Font;
    [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(buyingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.backgroundColor = Main_Color;
    [self addSubview:_submitButton];
    [self layoutNewData];
    
    [_shadowView layoutIfNeeded];
}

-(void)layoutNewData{
   
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        [make.height.mas_equalTo(self)setOffset:49];

    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:15];
        make.centerY.mas_equalTo(self);
    }];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        [make.right.mas_equalTo(self)setOffset:-0];
        [make.left.mas_equalTo(self)setOffset:SCREEN_WIDTH-84];
        [make.bottom.mas_equalTo(self)setOffset:0];
    }];
    
}

-(void)buyingButtonClick{
    
    if (_buyingClickBlock) {
        _buyingClickBlock();
    }
}

@end
