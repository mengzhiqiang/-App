//
//  DCEmptyCartView.m
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCEmptyCartView.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCEmptyCartView ()

/* imageView */
@property (strong , nonatomic)UIImageView *emptyImageView;
/* 标语 */
@property (strong , nonatomic)UILabel *sloganLabel;
/* 广告 */
@property (strong , nonatomic)UILabel *adLabel;
/* 架构模拟购物车按钮 */
@property (strong , nonatomic)UIButton *buyingButton;

@end

@implementation DCEmptyCartView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _emptyImageView = [[UIImageView alloc] init];
    _emptyImageView.image = [UIImage imageNamed:@"gwc_icon_kong"];
    [self addSubview:_emptyImageView];
    
    _sloganLabel = [[UILabel alloc] init];
    _sloganLabel.textColor = Sub_title_Color;
    _sloganLabel.text = @"购物车空空如也~";
    _sloganLabel.font = PFR19Font;
    _sloganLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_sloganLabel];
    
    _adLabel = [[UILabel alloc] init];
    _adLabel.textColor = [UIColor orangeColor];
    _adLabel.font = PFR14Font;
    _adLabel.text = @"";
    _adLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_adLabel];
    
    _buyingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyingButton.titleLabel.font = PFR19Font;
    [_buyingButton setTitle:@"去选购商品" forState:UIControlStateNormal];
    [_buyingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buyingButton.userInteractionEnabled = NO;
    _buyingButton.backgroundColor = Main_Color;
    [_buyingButton draCirlywithColor:nil andRadius:5.0f];
    [_buyingButton addTarget:self action:@selector(buyingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _buyingButton.userInteractionEnabled = YES;
    [self addSubview:_buyingButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self)setOffset:100];
        if (iPhone5) {
            make.size.mas_equalTo(CGSizeMake(95, 95));
        }else{
            make.size.mas_equalTo(CGSizeMake(95, 95));
        }
    }];
    
    [_sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(_emptyImageView.mas_bottom)setOffset:10*4];
    }];
    [_adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(_sloganLabel.mas_bottom)setOffset:10];
    }];
    
    [_buyingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(_adLabel.mas_bottom)setOffset:10 * 2];
        make.size.mas_equalTo(CGSizeMake(134, 35));
    }];
}

#pragma mark - Setter Getter Methods



#pragma mark - 点击事件
- (void)buyingButtonClick
{
    !_buyingClickBlock ? : _buyingClickBlock();
}

@end
