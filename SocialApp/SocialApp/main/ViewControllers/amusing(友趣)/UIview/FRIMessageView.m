//
//  FRIMessageView.m
//  SocialApp
//
//  Created by zhiqiang meng on 20/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIMessageView.h"

@interface FRIMessageView()

@property(nonatomic , strong) UIView * bgView;

@property(nonatomic , strong) UIImageView * iconView;
@property(nonatomic , strong) UILabel * titleLabel;
@property(nonatomic , strong) UIButton * moreButton;

@property(nonatomic , strong) UIImageView * shopTitleImageView;
@property(nonatomic , strong) UIButton * shopMapButton;

@end

@implementation FRIMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    
    [self addSubview:self.bgView];
    [_bgView addSubview:self.iconView];
    [_bgView addSubview:self.titleLabel];
    [_bgView addSubview:self.moreButton];
    
    [_bgView draCirlywithColor:nil andRadius:5.0f];
    
    [self addSubview:self.shopTitleImageView];
    [self addSubview:self.shopMapButton];

}

-(UIView*)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor HexString:@"F5F6FA"];
        _bgView.frame  = CGRectMake(15, 5, SCREEN_WIDTH-30, 35);
    }
    return _bgView;
}
-(UIImageView*)iconView{
    if (!_iconView) {
           _iconView = [[UIImageView alloc]init];
           _iconView.image = [UIImage imageNamed:@"icon_gonggao"];
           _iconView.frame  = CGRectMake(10, 10, 15, 15);
       }
       return _iconView;
}
-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame  = CGRectMake(60, 5, SCREEN_WIDTH-60-70, 25);
        _titleLabel.textColor = [UIColor HexString:@"252B46"];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"平台公告可在后台编辑新增...";
    }
    return _titleLabel;
}

-(UIButton*)moreButton{
    
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(self.bgView.width-70, 0, 60, 35);
        [_moreButton addTarget:self action:@selector(pushMoreMessage) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setTitle:@"更多 >" forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _moreButton;
}

-(UIButton*)shopMapButton{
    
    if (!_shopMapButton) {
        _shopMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shopMapButton.frame = CGRectMake(self.width-50, _bgView.bottom+30, 40, 35);
        [_shopMapButton addTarget:self action:@selector(pushMoreMessage) forControlEvents:UIControlEventTouchUpInside];
        [_shopMapButton setImage:[UIImage imageNamed:@"btn_map"] forState:UIControlStateNormal];
    }
    return _shopMapButton;
}
-(UIImageView*)shopTitleImageView{
    if (!_shopTitleImageView) {
           _shopTitleImageView = [[UIImageView alloc]init];
           _shopTitleImageView.image = [UIImage imageNamed:@""];
//           _shopTitleImageView.backgroundColor = Main_Color;
           _shopTitleImageView.frame  = CGRectMake(20, _bgView.bottom+30, 70, 35);
        
        UILabel*titleL = [[UILabel alloc]init];
        titleL.frame  = CGRectMake(0, 5, 200, 25);
        titleL.textColor = [UIColor HexString:@"252B46"];
        titleL.font = [UIFont boldSystemFontOfSize:20];
        titleL.text = @"商家列表";
        [_shopTitleImageView addSubview:titleL];
       }    
       return _shopTitleImageView;
}

-(void)pushMoreMessage{
    
}
@end
