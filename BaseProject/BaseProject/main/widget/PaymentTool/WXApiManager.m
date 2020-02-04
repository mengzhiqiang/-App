//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}
/**
 发起订单支付请求
 */
-(void)getPayInfomationWithOrder:(NSString*)order num:(NSString*)num{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSString *path = [API_HOST stringByAppendingString:wxpay_prepay];
    NSMutableDictionary *diction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:order,@"orderId" ,nil];
    if (num) {
        [diction setValue:num forKey:@"orderNumber"];
    }
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"=支付====%@",JSONDic );
         [self  payOfWXPayReqdata:JSONDic];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *Dic_data = error.userInfo;
        [MBProgressHUD showError: [Dic_data objectForKey:@"msg"]];
        if ([Dic_data[@"code"] integerValue]==1) {
            [[UIViewController getCurrentController].navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark  调起微信支付
-(void)payOfWXPayReqdata:(NSDictionary *)Dic_data{
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [NSString stringWithFormat:@"%@",[Dic_data objectForKey:@"partnerid"]];
    request.prepayId= [Dic_data objectForKey:@"prepayid"];
    request.package = [Dic_data objectForKey:@"package"];
    request.nonceStr= [Dic_data objectForKey:@"noncestr"];
    request.timeStamp= (UInt32)[[Dic_data objectForKey:@"timestamp"] intValue];
    request.sign= [Dic_data objectForKey:@"sign"];

    if ([WXApi sendReq:request]) {
        NSLog(@"支付中");
    }else{
        NSLog(@"支付调取失败");
    }
    
}
//#pragma mark - WXApiDelegate
//- (void)onResp:(BaseResp *)resp {
//    if([resp isKindOfClass:[PayResp class]]){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        switch (resp.errCode) {
//            case WXSuccess:
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                if (_backResult) {
//                    _backResult(@"success");
//                }
//                break;
//
//            default:
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                if (_backResult) {
//                    _backResult(@"fail");
//                }
//                break;
//        }
//
//    }else {
//    }
//}


-(void)requestPayWithOrder:(NSString*)order num:(NSString*)num backResult:(BackBlockResult)backResult{
    
    _backResult = backResult ;
    [self getPayInfomationWithOrder:order num:num];
    
//    [self payOfWXPayReqdata:nil];
}


#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            
            [self loginWeixin:authResp.code];
//            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    } else if ([resp isKindOfClass:[WXChooseCardResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvChooseCardResponse:)]) {
            WXChooseCardResp *chooseCardResp = (WXChooseCardResp *)resp;
            [_delegate managerDidRecvChooseCardResponse:chooseCardResp];
        }
    }else if ([resp isKindOfClass:[WXChooseInvoiceResp class]]){
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvChooseInvoiceResponse:)]) {
            WXChooseInvoiceResp *chooseInvoiceResp = (WXChooseInvoiceResp *)resp;
            [_delegate managerDidRecvChooseInvoiceResponse:chooseInvoiceResp];
        }
    }else if ([resp isKindOfClass:[WXSubscribeMsgResp class]]){
        if ([_delegate respondsToSelector:@selector(managerDidRecvSubscribeMsgResponse:)])
        {
            [_delegate managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *)resp];
        }
    }else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]){
        if ([_delegate respondsToSelector:@selector(managerDidRecvLaunchMiniProgram:)]) {
            [_delegate managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *)resp];
        }
    }else if([resp isKindOfClass:[WXInvoiceAuthInsertResp class]]){
        if ([_delegate respondsToSelector:@selector(managerDidRecvInvoiceAuthInsertResponse:)]) {
            [_delegate managerDidRecvInvoiceAuthInsertResponse:(WXInvoiceAuthInsertResp *) resp];
        }
    }else if([resp isKindOfClass:[WXNontaxPayResp class]]){
        if ([_delegate respondsToSelector:@selector(managerDidRecvNonTaxpayResponse:)]) {
            [_delegate managerDidRecvNonTaxpayResponse:(WXNontaxPayResp *)resp];
        }
    }else if ([resp isKindOfClass:[WXPayInsuranceResp class]]){
        if ([_delegate respondsToSelector:@selector(managerDidRecvPayInsuranceResponse:)]) {
            [_delegate managerDidRecvPayInsuranceResponse:(WXPayInsuranceResp *)resp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                if (_backResult) {
                    _backResult(@"success");
                }
                break;
                
            default:
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                if (_backResult) {
                    _backResult(@"fail");
                }
                break;
        }
        
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}


-(void)loginWeixin:(NSString*)stateCode{
    
    NSString *path =@"https://api.weixin.qq.com/sns/oauth2/access_token";
    NSMutableDictionary *diction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:WX_APPID,@"appid",WX_APPsecret,@"secret",stateCode,@"code",@"authorization_code",@"grant_type" ,nil];
    [HttpEngine requestGetWithURL:path params:diction isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     
        [self GetInfoOfloginWeixin:responseObject];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *Dic_data = error.userInfo;
        [MBProgressHUD showError: [Dic_data objectForKey:@"msg"]];
        
    }];
}

-(void)GetInfoOfloginWeixin:(NSDictionary*)pram{
    
    NSString *path =@"https://api.weixin.qq.com/sns/userinfo";
    NSMutableDictionary *diction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:pram[@"access_token"],@"access_token",pram[@"openid"],@"openid" ,nil];
    WS(weakself);
    [HttpEngine requestGetWithURL:path params:diction isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (weakself.delegate
            && [weakself.delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {

            [weakself.delegate managerDidRecvAuthResponse:responseObject];
        }
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *Dic_data = error.userInfo;
        [MBProgressHUD showError: [Dic_data objectForKey:@"msg"]];
        
    }];
}


@end
