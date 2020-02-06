//
//  SARechargeVC.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/11.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "SARechargeVC.h"
#import "SARechargeRequest.h"
@interface SARechargeVC ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *channelBtns;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (nonatomic, strong) SARechargeRequest *req;
@end

@implementation SARechargeVC
//支付成功
//- (void)paySuccess {
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRechargeSuccess object:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"充值";
    self.req = [SARechargeRequest Request];
    self.req.pay_type = @"3";
    WS(weakself);
    self.req.successBlock = ^(NSDictionary *dic) {
        [MBProgressHUD hideActivityIndicator];
        if([weakself.req.pay_type isEqualToString:@"3"]){
            NSDictionary *data = dic[@"data"];
            [weakself alipay:data[@"info"]];
        }else{
            [weakself wechatPay:dic[@"data"]];
        }
    };
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeSuccess) name:kNotificationRechargeSuccess object:nil];
}

- (void)rechargeSuccess {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)channelAction:(UIButton *)sender {
    for (UIButton *btn in self.channelBtns) {
        btn.selected = NO;
    }
    sender.selected = YES;
    if(sender.tag == 0){
        self.req.pay_type = @"3";
    } else {
        self.req.pay_type = @"2";
    }
//    self.req.pay_type = @(sender.tag).stringValue;
}

- (IBAction)confirmAction:(UIButton *)sender {
    [MBProgressHUD showActivityIndicator];
    self.req.price = self.amountTF.text;
    self.req.requestNeedActive = YES;

}

//微信支付
-(void)wechatPay:(NSDictionary *)datas{
    UIAlertController *aletController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定使用微信支付？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *canceAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [aletController addAction:canceAlert];
    
    UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
//        if([ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession]){
//            PayReq *request = [[PayReq alloc] init];
//            /** 商家向财付通申请的商家id */
//            request.partnerId = [NSString stringWithFormat:@"%@",datas[@"partnerid"]];
//            /** 预支付订单 */
//            request.prepayId= [NSString stringWithFormat:@"%@",datas[@"prepayid"]];
//            /** 商家根据财付通文档填写的数据和签名 */
//            request.package = [NSString stringWithFormat:@"%@",datas[@"package"]];
//            /** 随机串，防重发 */
//            request.nonceStr=[NSString stringWithFormat:@"%@",datas[@"noncestr"]];
//            /** 时间戳，防重发 */
//            request.timeStamp = [datas[@"timestamp"] intValue];
//            /** 商家根据微信开放平台文档对数据做的签名 */
//            request.sign = [NSString stringWithFormat:@"%@",datas[@"sign"]];
//            [WXApi sendReq:request completion:^(BOOL success) {
//
//            }];
//
//        }else{
//            [MBProgressHUD showError:@"您未安装微信"];
//        }
    }];;
    [aletController addAction:okAlert];
    
    [self presentViewController:aletController animated:YES completion:nil];
    
}
-(void)alipay:(NSString *)paystr{
    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];
    if (![[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        
        UIAlertController *aletController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"点击去安装支付宝钱包!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *canceAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [aletController addAction:canceAlert];
        
        UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
            NSString * URLString = @"http://itunes.apple.com/cn/app/id333206289?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
        }];;
        [aletController addAction:okAlert];
        
        [self presentViewController:aletController animated:YES completion:nil];
        
        return;
    }
    
    UIAlertController *aletController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定使用支付宝支付？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *canceAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [aletController addAction:canceAlert];
    
    UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        NSString *appScheme = @"SallyDiMan";
        // NOTE: 调用支付结果开始支付
//        [[AlipaySDK defaultService] payOrder:paystr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
//            if(resultStatus == 4000){
//                [MBProgressHUD showError:@"支付失败"];
//                return;
//            }
//        }];
    }];;
    [aletController addAction:okAlert];
    
    [self presentViewController:aletController animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
