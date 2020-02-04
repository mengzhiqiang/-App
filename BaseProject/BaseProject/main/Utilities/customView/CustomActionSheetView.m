//
//  CustomActionSheetView.m
//  ZCBus
//
//  Created by zhiqiang meng on 5/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "CustomActionSheetView.h"

@implementation CustomActionSheetView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addshareView];
    }
    return self;
}

-(void)addshareView
{
    UIView * backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backGroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-202-iphoneXTab, SCREEN_WIDTH-30, 130)];
    view.backgroundColor = White_Color;
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 13, view.width-100, 18)];
    titleLabel.text = @"分享到";
    titleLabel.textColor = Sub_title_Color;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:titleLabel];
    
    NSArray * titils = @[@"微信好友",@"QQ",@"微博",@"朋友圈"];
    NSArray * Images = @[@"fx_icon_wx",@"fx_icon_qq",@"fx_icon_wb",@"pengyouquan"];
    
    CGFloat wigth = 55;
//    CGFloat left = (view.width-55*4-33*3)/2;
    CGFloat left = (view.width-55)/2;

    for (int i=0; i<1; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(left+88*i, 42, wigth, wigth);
        [btn setImage:[UIImage imageNamed:Images[i]] forState:UIControlStateNormal];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(left+88*i, btn.bottom+5, wigth, 20)];
        label.text = titils[i];
        label.textColor = Sub_title_Color;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    
    [view draCirlywithColor:nil andRadius:12.0f];
    [backGroundView addSubview:view];
    
    UIButton *channleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    channleButton.frame = CGRectMake(15, SCREEN_HEIGHT-wigth-8-iphoneXTab, SCREEN_WIDTH-30, wigth);
    [channleButton setTitle:@"取消" forState:UIControlStateNormal];
    [channleButton  setTitleColor:Sub_title_Color forState:UIControlStateNormal];
    channleButton.backgroundColor = White_Color;
    channleButton.tag = 100;
    [channleButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [backGroundView addSubview:channleButton];
    [channleButton draCirlywithColor:nil andRadius:12.0f];
    
    [self  addSubview:backGroundView];
}

-(void)clickButton:(UIButton*)sender{
    
    if (_backClick) {
        _backClick(sender.tag);
    }
    
}

@end
