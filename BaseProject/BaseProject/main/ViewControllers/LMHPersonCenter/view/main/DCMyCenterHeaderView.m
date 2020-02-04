

//
//  DCMyCenterHeaderView.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/12.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCMyCenterHeaderView.h"
#import "UserInfo.h"
#import "UIButton+AFNetworking.h"
@interface DCMyCenterHeaderView()


@end

@implementation DCMyCenterHeaderView

#pragma mark - initialize
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_shadowVipView layoutIfNeeded];
    [_shadowBGView draCirlywithColor:nil andRadius:8.0f];

    _vipButton.backgroundColor = [UIColor blackColor];
    _vipButton.hidden= NO;
    [_vipButton draCirlywithColor:nil andRadius:_vipButton.height/2];
}

#pragma mark - 头像点击
- (IBAction)headButtonClick {
    !_headClickBlock ? : _headClickBlock();
}

- (IBAction)tapVipView:(UITapGestureRecognizer *)sender {
    NSLog(@"==tapVipView==");
    !_seeVipClickBlock?:_seeVipClickBlock();
    
}

-(void)setnewData{
    
    UserInfo *info = [CommonVariable getUserInfo];
    if (info) {
        [_myIconButton setImageForState:UIControlStateNormal withURL:[info.user_logo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        _useNameLabel.text = info.user_name;
        _useNameLabel.width = [self sizeOfContent:_useNameLabel size:CGSizeMake(200, 20)].height;
        _vipView.left = _useNameLabel.right+8;
        [_myIconButton draCirlywithColor:nil andRadius:_myIconButton.height/2];
    }
    
}
- (IBAction)clickVipButton:(UIButton *)sender {
}


-(CGSize)sizeOfContent:(UILabel*)label size:(CGSize)size{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSRange allRange = [label.text rangeOfString:label.text];
    [attrStr addAttribute:NSFontAttributeName value:label.font range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];

    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:size options:options context:nil];
    
    return rect.size;
}

-(void)setModel:(LMHPersonCenterModel *)model{
    
    if (model) {
        
        [_myIconButton setBackgroundImageForState:UIControlStateNormal withURL:[model.portrait changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        _useNameLabel.text = (model.userName?model.userName:[[CommonVariable getUserInfo].phone changePhone]);
        _bonusLabel.text   = [NSString stringWithFormat:@"%.2f",model.rebateMoney.floatValue];
        _balanceLabel.text = [NSString stringWithFormat:@"%.2f",model.balance.floatValue];
    }
    if ( _useNameLabel.text.length<1) {
        _useNameLabel.text = @"用户1";
    }
    _useNameLabel.width = [self sizeOfContent:_useNameLabel size:CGSizeMake(200, 20)].width;
    _vipView.left       = _useNameLabel.right+8;
    [_myIconButton draCirlywithColor:nil andRadius:_myIconButton.height/2];
    [_vipButton setTitle:model.levelName forState:UIControlStateNormal];
    
    _vieSumLabel.text = [NSString stringWithFormat:@"在销售%@元升级%@",model.requiredMoney,model.uplevelName];
    _shadowVipView.hidden = YES;
}
@end
