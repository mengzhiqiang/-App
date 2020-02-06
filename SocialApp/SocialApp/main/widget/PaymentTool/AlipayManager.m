//
//  AlipayManager.m
//  FindWorker
//
//  Created by zhiqiang meng on 26/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "AlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>   ///支付宝


@implementation AlipayManager


+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AlipayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AlipayManager alloc] init];
    });
    return instance;
}
/**
 发起订单支付请求
 */
-(void)getPayInfomationWithOrder:(NSString*)order sum:(NSString*)NUM{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *path = [API_HOST stringByAppendingString:@"alipay"];
    NSMutableDictionary *diction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:order,@"orderId" ,nil];
    if (NUM) {
        [diction setValue:NUM forKey:@"orderNumber"];
    }
    
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        NSString *JSONDic = [(NSString *)responseObject objectForKey:@"result"] ;
        NSLog(@"=支付====%@",responseObject );
        [self  payOfAliPayReqdata:[responseObject objectForKey:@"data"]];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *Dic_data = error.userInfo;
        [MBProgressHUD showError: [Dic_data objectForKey:@"msg"]];

        if ([Dic_data[@"code"] integerValue]==1) {
            [[UIViewController getCurrentController].navigationController popViewControllerAnimated:YES];
        }
        
    }];
}
#pragma mark  支付宝
-(void)payOfAliPayReqdata:(NSString *)Dic_data{
    
    NSString *appScheme = @"LMHalipay";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentResult:) name:@"alipayResult" object:nil];
    [[AlipaySDK defaultService] payOrder:Dic_data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"支付宝支付回调====reslut = %@",resultDic[@"memo"]);
        if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000) {
            [MBProgressHUD showSuccess:@"支付成功"];
            _backResult(@"success");

        }
        else {
            [MBProgressHUD showError: @"支付失败"];
            _backResult(@"fail");

        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];

    }];
}

-(void)paymentResult:(NSNotification *)usefication
{
    NSDictionary *dic=(NSDictionary*)usefication.object;
    NSString *res=[dic objectForKey:@"resultStatus"];
    NSLog(@"resultStatus==dic===%@",dic);
    if (dic)
    {
        if ([res intValue] == 9000)
        {
            _backResult(@"success");
            [MBProgressHUD showSuccess:@"支付成功！"];
        }
        else
        {
            //交易失败
            [MBProgressHUD showError:@"支付失败！"];
            _backResult(@"fail");
        }
    }
    else
    {
        //失败
        [MBProgressHUD showError:@"支付失败！"];
        _backResult(@"fail");
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)requestAliPayWithOrder:(NSString*)order sum:(NSString*)sum backResult:(BackBlockResult)backResult{

    _backResult = backResult ;
    [self getPayInfomationWithOrder:order sum:sum];
    
    //    [self payOfWXPayReqdata:nil];
}

-(void)requestAliPayWithOrder:(NSString*)order number:(NSString*)number backResult:(BackBlockResult)backResult{

    _backResult = backResult ;
    [self getPayInfomationWithOrder:order sum:number];
    
    //    [self payOfWXPayReqdata:nil];
}


@end
