//
//  LMHGoodsCollectionViewCell.m
//  BaseProject
//
//  Created by zhiqiang meng on 21/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHGoodsCollectionViewCell.h"

@implementation LMHGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_shadowView layoutIfNeeded];
    [_BGView draCirlywithColor:nil andRadius:8.0f];
    
   
}

-(void)loadUI:(LMHBandGoodModel*)model{
    CGFloat  with =  95*RATIO_IPHONE6 ;
    CGFloat  Hight =  95*RATIO_IPHONE6 ;
    _brandGoodOne.frame = CGRectMake(15 , 64, with, Hight);
    _brandGoodTwo.frame = CGRectMake(15*2+with , 64, with, Hight);
    _brandGoodThree.frame = CGRectMake(15*3+with*2 , 64, with, Hight);
    
    _freePostLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:119/255.0 blue:0/255.0 alpha:0.6];
    [_freePostLabel draCirlywithColor:nil andRadius:_freePostLabel.height/2];
    [_brandImageView draCirlywithColor:nil andRadius:_brandImageView.height/2];

    if (with>=95) {
        _brandNameLabel.font = [UIFont systemFontOfSize:15];
        _brandTimeLabel.font = [UIFont systemFontOfSize:12];

    }
    if (model) {
        [_brandImageView setImageWithURL:[NSURL URLWithString:URL(model.brandLogo)] placeholderImage:[UIImage imageNamed:@"defaulPicture"]];
        _brandNameLabel.text = model.brandName;
        
        if (model.goods.count==1) {
            _brandGoodTwo.hidden = YES;
            _brandGoodThree.hidden = YES;
            _brandGoodOne.hidden = NO;
            NSDictionary * dic =model.goods.firstObject;
            NSString *imgUrl = [URL(dic[@"url"])  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            [_brandGoodOne setImageWithURL:[NSURL URLWithString:imgUrl]  placeholderImage:[UIImage imageNamed:@"defaulPicture"]];
            _fistStockLabel.text = [NSString stringWithFormat:@"库存:%@",dic[@"repertory"]];
        }else  if (model.goods.count==2) {
            _brandGoodTwo.hidden = NO;
            _brandGoodThree.hidden = YES;
            _brandGoodOne.hidden = NO;
            NSDictionary * dic1 =model.goods.firstObject;
            NSString *imgUrl = [URL(dic1[@"url"])  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            [_brandGoodOne setImageWithURL:[NSURL URLWithString:imgUrl]  placeholderImage:[UIImage imageNamed:@"defaulPicture"]];
            int count = [dic1[@"repertory"]intValue] ;
            _fistStockLabel.text = [NSString stringWithFormat:@"库存:%d",count>0?count:0];
            NSDictionary * dic2 =model.goods[1];
            NSString *imgUrl2 = [URL(dic2[@"url"])  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            [_brandGoodTwo setImageWithURL:[NSURL URLWithString:imgUrl2]  placeholderImage:[UIImage imageNamed:@"defaulPicture"]];
            _secondStockLabel.text = [NSString stringWithFormat:@"库存:%@",dic2[@"repertory"]];

        }else  if (model.goods.count>=3) {
            _brandGoodTwo.hidden = NO;
            _brandGoodThree.hidden = NO;
            _brandGoodOne.hidden = NO;
            NSDictionary * dic =model.goods.firstObject;
            _fistStockLabel.text = [NSString stringWithFormat:@"库存:%@",dic[@"repertory"]];
            NSString *imgUrl = [URL(dic[@"url"])  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_brandGoodOne setImageWithURL:[NSURL URLWithString:imgUrl]  placeholderImage:[UIImage imageNamed:@"defaulPicture"]];
            NSDictionary * dic1 =model.goods[1];
            _secondStockLabel.text = [NSString stringWithFormat:@"库存:%@",dic1[@"repertory"]];
            NSString *imgUrl1 = [URL(dic1[@"url"])  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            [_brandGoodTwo setImageWithURL:[NSURL URLWithString:imgUrl1]  placeholderImage:[UIImage imageNamed:@"defaulPicture"]];
            NSDictionary * dic2 =model.goods[2];
            _threeStockLabel.text = [NSString stringWithFormat:@"库存:%@",dic2[@"repertory"]];
            NSString *imgUrl2 = [URL(dic2[@"url"])  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_brandGoodThree setImageWithURL:[NSURL URLWithString:imgUrl2]  placeholderImage:[UIImage imageNamed:@"defaulPicture"]];
        }
        
    }else{
        
        
    }
        
    _brandTimeLabel.attributedText = [NSString BgColorStringWithContent:@"距离结束 12:12:12" andTitle:@"12"];
    _fistStockLabel.left = 0;
    _fistStockLabel.bottom = _brandGoodOne.height-5;
    _fistStockLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:119/255.0  blue:0/255.0 alpha:0.6];
    [_brandGoodOne addSubview:_fistStockLabel];
    
    _secondStockLabel.left = 0;
    _secondStockLabel.bottom = _brandGoodTwo.height-5;
    _secondStockLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:119/255.0  blue:0/255.0 alpha:0.6];
    [_brandGoodTwo addSubview:_secondStockLabel];
    
    _threeStockLabel.left = 0;
    _threeStockLabel.bottom = _brandGoodThree.height-5;
    _threeStockLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:119/255.0  blue:0/255.0 alpha:0.6];
    [_brandGoodThree addSubview:_threeStockLabel];
    
    [self maskLayerWithView:_fistStockLabel];
    [self maskLayerWithView:_secondStockLabel];
    [self maskLayerWithView:_threeStockLabel];

    [self  nowDateDifferWithDate:model.endTime];
    
    _shadowView.height = Hight + 100;

}


-(void)maskLayerWithView:(UIView*)view{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    
     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
     maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;

}

- (void)addTime {
    
//     _secondsCountDown = 10;//倒计时秒数
    if (!_countDownTimer) {
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
    }
    //设置倒计时显示的时间
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",_secondsCountDown/3600];//时
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",_secondsCountDown%60];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    NSLog(@"time:%@",format_time);
    
//    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bigImageView.frame.size.width, bigImageView.frame.size.height)];
//    self.timeLabel.text = [NSString stringWithFormat:@"倒计时   %@",format_time];
//    self.timeLabel.textAlignment = NSTextAlignmentCenter;
//    self.timeLabel.font = FONT_19;
//    self.timeLabel.textColor = ［UIColor  redColor］;
//    [self.View addSubview:self.timeLabel];
}

-(void) countDownAction{
    //倒计时-1
    _secondsCountDown--;
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",_secondsCountDown/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",_secondsCountDown%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签现实内容
    NSString  *string=[NSString stringWithFormat:@"距离结束 %@",format_time];
    _brandTimeLabel.attributedText = [NSString BgColorStringWithContent:string andTitle:str_hour];

    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_secondsCountDown==0){
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
}

-(void)nowDateDifferWithDate:(NSString* )dateString  {
    //日期格式设置,可以根据想要的数据进行修改 添加小时和分甚至秒
    long  data = [[NSDate timeStrToTimestamp:dateString] longLongValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:data];
    NSLog(@"有效期到 =  %@==",confromTimesp);
    NSTimeInterval late=[confromTimesp timeIntervalSince1970]*1;
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970]*1;
    NSLog(@"有效期到 = %f=====当前时间==%f====差==%f分钟",late,now,(now-late)/60);

    _secondsCountDown = late - now ;

    if (_secondsCountDown>1) {
        [self addTime];
    }
}
@end
