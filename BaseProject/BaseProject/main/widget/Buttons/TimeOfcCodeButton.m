//
//  TimeOfcCodeButton.m
//  ALPHA
//
//  Created by mzq on 15/11/16.
//  Copyright © 2015年 ALPHA. All rights reserved.
//

#import "TimeOfcCodeButton.h"

@implementation TimeOfcCodeButton
{
    int   count_Code;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (!_count_label) {
        [self  LoadCountLable];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
    }
    return self;
}

-(void)LoadCountLable{

    if (!_count_label) {
    _count_label=[[UILabel  alloc]initWithFrame:self.bounds];
    }
    _codeStyle=@"1";
    _count_label.font=[UIFont systemFontOfSize:14];
    _count_label.textAlignment=NSTextAlignmentCenter;
    _count_label.textColor = [UIColor HexString:@"8c8b90"];
    _count_label.text=@"获取验证码";
    [self addSubview:_count_label];
    [self  draCirlywithColor:nil andRadius:4.0];
}
-(void)loadNewCodeWithIphone:(NSString*)ipone{
    self.ipone=ipone;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone_zh];
    if( self.ipone.length == 0 ){
        [MBProgressHUD  showError:@"请输入用户手机号码！"];
        return;
    }
    else if (self.ipone.length != 11) {
        [MBProgressHUD  showError:@"手机号格式不正确！"];
        return;
    }
    self.enabled=NO;
//    [MBProgressHUD showActivityIndicator];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableDictionary*dic_register=[[NSMutableDictionary alloc]initWithObjectsAndKeys:_ipone,@"phone", nil];
    [dic_register setObject:self.codeStyle forKey:@"type"];
    NSString *path = [API_HOST stringByAppendingString:account_code];

    [HttpEngine requestGetWithURL:path params:dic_register isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        NSLog(@"===%@",responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [MBProgressHUD  showError:@"验证码已发送，请注意查收"];
        count_Code=60;
        
        NSTimer* timer0 =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changecountOfCode:) userInfo:nil repeats:YES];
        [timer0 fire];
        self.enabled=NO;
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.enabled=YES;
        NSDictionary *Dic_data =error.userInfo;
        [MBProgressHUD  showError:[Dic_data objectForKey:@"msg"]];
    }];
    
    self.enabled=NO;
    
}

-(void)changecountOfCode:(NSTimer*)time{
    
    count_Code--;
    
    if (count_Code<0) {
        self.enabled=YES;
        [time invalidate];
        _count_label.text= [NSString stringWithFormat:@"获取验证码"];
        _count_label.textColor = Main_Color;
        return;
    }
    self.enabled=NO;
    _count_label.textColor = [UIColor HexString:@"8c8b90"];
    _count_label.text= [NSString stringWithFormat:@"%d秒后重发",count_Code];
}

@end
