//
//  LMHVideoBandView.m
//  BaseProject
//
//  Created by zhiqiang meng on 26/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHVideoBandView.h"
#import "LMHActiveViewController.h"
#import "LMHBandDetailViewController.h"
#import "LMHGoodsDetailVC.h"
#import "WKwebViewController.h"

@implementation LMHVideoBandView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)pushBandView:(UITapGestureRecognizer *)sender {
    
    if (sender.view.tag==11) {
        LMHGoodsDetailVC *vc = [[LMHGoodsDetailVC alloc] initWithNibName:@"LMHGoodsDetailVC" bundle:[NSBundle mainBundle]];
        vc.goodID = _model.entranceContent;
        [[UIViewController getCurrentController].navigationController pushViewController:vc animated:YES];
        
    }else{
        LMHBandDetailViewController* bandDetailVC =[[LMHBandDetailViewController alloc]init];
        bandDetailVC.bandID =_model.brandId;
        bandDetailVC.scheduleId =_model.scheduleId;
        [[UIViewController getCurrentController].navigationController pushViewController:bandDetailVC animated:YES];
    }
        
}

-(void)setModel:(LMHVideoModel *)model{
    
    _model = model;
    [_bandImageView setImageWithURL:[model.logo  changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
    _bandNameLabel.text = model.brandName;
    _lookCountLabel.text = @" ";
    _lookCountLabel.hidden = YES;
    _videoIDlabel.text = [NSString stringWithFormat:@"直播间ID:%@",model.liveId];
    
    if (model.entranceType.intValue != 4) {
        _goodView.hidden = YES;
    }else{
        _goodImagView.userInteractionEnabled = YES;
        [_goodImagView setImageWithURL:[model.cover  changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        _goodPriceLabel.text = [NSString stringWithFormat:@"    ¥%@",model.goodsPrice];
        [_goodPriceLabel draCirlywithColor:nil andRadius:_goodPriceLabel.height/2];
        _goodPriceLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:119/255.0 blue:0/255.0 alpha:0.8];
        _goodImagView.alpha = 0.8;
    }
    
}

#pragma mark 跳转页面
-(void)pushNextWithModel:(LMHVideoModel*)model{
    
    switch ([model.entranceType intValue]) {
        case 1:
        {
            LMHBandDetailViewController* bandDetailVC =[[LMHBandDetailViewController alloc]init];
            bandDetailVC.bandID =model.entranceContent;
            [[UIViewController getCurrentController].navigationController pushViewController:bandDetailVC animated:YES];
        }
            break;
        case 2:
        {
            
            LMHActiveViewController* bandDetailVC =[[LMHActiveViewController alloc]init];
            bandDetailVC.activeID = model.entranceContent;
            [[UIViewController getCurrentController].navigationController pushViewController:bandDetailVC animated:YES];
        }
            break;
        case 3:
        {
            if (![model.entranceContent hasPrefix:@"http"]) {
                return;
            }
            WKwebViewController * webVC = [[WKwebViewController alloc]init];
            webVC.webUrl = model.entranceContent;
            webVC.title = @"活动网页";
            [[UIViewController getCurrentController].navigationController pushViewController:webVC animated:YES];
        }
            break;
            
        case 4:
        {
            
            LMHBandDetailViewController* bandDetailVC =[[LMHBandDetailViewController alloc]init];
            bandDetailVC.bandID =model.brandId;
            [[UIViewController getCurrentController].navigationController pushViewController:bandDetailVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
