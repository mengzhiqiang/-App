//
//  LMHBandTableViewCell.m
//  BaseProject
//
//  Created by zhiqiang meng on 22/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBandTableViewCell.h"
#import "LMHBandGoodModel.h"

@interface LMHBandTableViewCell()

@property (strong, nonatomic)  NSTimer *countDownTimer;
@property (assign, nonatomic)  NSInteger secondsCountDown;

@end ;

@implementation LMHBandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(88);
        make.right.offset(-15);
    }];
    
    [_BGView draCirlywithColor:nil andRadius:8.0f];
    [_serverButton draCirlywithColor:nil andRadius:_serverButton.height/2];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadUIWithData:(LMHBandModel*)model{
  
    if (model) {
        _contentLabel.text= model.brandDetails;
        _titleNameLabel.text = model.brandName;
        [_headerImageView setImageWithURL:[model.brandLogo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        _countLabel.text = [NSString stringWithFormat:@"共%@件商品",model.goodsCount];
        //    _countLabel.text = [NSString stringWithFormat:@"距离活动结束"];
        [self nowDateDifferWithDate:model.endTime];
       
    }else{
        _timeLabel.hidden = YES;

    }
    
//    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.brandDetails]];
//    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, 16)];
//    [newPrice addAttribute:NSForegroundColorAttributeName value:Main_Color range:NSMakeRange(0, 16)];
//    _contentLabel.attributedText = newPrice ;
}

- (IBAction)clickServer:(UIButton *)sender {
    
    NSLog(@"====点电话") ;
    [self callWithPhone];
}
#pragma mark  打电话
-(void)callWithPhone{
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4008882435"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:nil completionHandler:nil];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)addTime {
    
    //     _secondsCountDown = 172800;//倒计时秒数
    if (!_countDownTimer) {
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
    }
    //设置倒计时显示的时间
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",_secondsCountDown/3600];//时
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",_secondsCountDown%60];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@ 时 %@ 分 %@ 秒",str_hour,str_minute,str_second];
    NSLog(@"time:%@",format_time);
    NSString  *string=[NSString stringWithFormat:@"距离活动结束 %@",format_time];
    _timeLabel.attributedText = [NSDate BgColor:string andTitle:str_hour];
    
}

-(void) countDownAction{
    //倒计时-1
    _secondsCountDown--;
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",_secondsCountDown/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",_secondsCountDown%60];
    NSString *format_time = [NSString stringWithFormat:@"%@ 时 %@ 分 %@ 秒",str_hour,str_minute,str_second];
    //修改倒计时标签现实内容
    NSString  *string=[NSString stringWithFormat:@"距离活动结束 %@",format_time];
    _timeLabel.attributedText = [NSDate BgColor:string andTitle:str_hour];
    
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_secondsCountDown==0){
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
}

-(void)nowDateDifferWithDate:(NSString* )dateString  {
    if (dateString) {
        //日期格式设置,可以根据想要的数据进行修改 添加小时和分甚至秒
        long  data = [[NSDate timeStrToTimestamp:dateString] longLongValue];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:data];
        NSTimeInterval late=[confromTimesp timeIntervalSince1970]*1;
        NSTimeInterval now=[[NSDate date] timeIntervalSince1970]*1;
        NSLog(@"nowDateDifferWithDate = %f=====当前时间==%f====差==%f分钟",late,now,(now-late)/60);
        
        _secondsCountDown = late - now ;
        
        if (_secondsCountDown>1) {
            [self addTime];
        }

    }else{
        _timeLabel.hidden = YES;
    }
    
    
}


@end
