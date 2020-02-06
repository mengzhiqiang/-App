//
//  SARechargeVC.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/11.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "FRIRechargeCurrencyVC.h"
#import "SARechargeRequest.h"
#import "UIAlertController+Simple.h"

@interface FRIRechargeCurrencyVC ()
@property (weak, nonatomic) IBOutlet UILabel *restLbl;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (nonatomic, strong) SARechargeRequest *req;
@end

@implementation FRIRechargeCurrencyVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"钱包充值";
    self.req = [SARechargeRequest Request];
    self.req.pay_type = @"3";
    WS(weakself);
    self.req.successBlock = ^(NSDictionary *dic) {
        [MBProgressHUD hideActivityIndicator];
//        if([weakself.req.pay_type isEqualToString:@"3"]){
//            NSDictionary *data = dic[@"data"];
//            [weakself alipay:data[@"info"]];
//        }else{
//            [weakself wechatPay:dic[@"data"]];
//        }
    };
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeSuccess) name:kNotificationRechargeSuccess object:nil];

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"钱包充值(可用余额%@)", @"88888.00"]];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexValue:0xBABFCD]} range:NSMakeRange(4, attr.length-4)];
    self.restLbl.attributedText = attr;
    
    NSMutableAttributedString *attrBtn = [[NSMutableAttributedString alloc] initWithString:@"前往充值" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:Main_Color}];
    [self.rechargeBtn setAttributedTitle:attrBtn forState:UIControlStateNormal];
}

- (void)rechargeSuccess {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)channelAction:(UIButton *)sender {

    sender.selected = YES;
    if(sender.tag == 0){
        self.req.pay_type = @"3";
    } else {
        self.req.pay_type = @"2";
    }
//    self.req.pay_type = @(sender.tag).stringValue;
}

- (IBAction)codeAction:(UIButton *)sender {
    if(self.phoneTF.text.length !=11){
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
//    NSString *url = [API_HOST stringByAppendingString:L_indexsms];;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneTF.text forKey:@"tel"];
    [params setObject:@"3" forKey:@"type"];//1= 绑定手机；2=设置支付密码
//    [XJHttpTool post:url params:params isToken:YES success:^(id responseObj) {
//        NSDictionary *data = responseObj[@"data"];
//        [sender jk_startTime:60 waitTittle:@"s"];
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideActivityIndicator];
//        [MBProgressHUD hideHUD];
//    }];
}

- (IBAction)confirmAction:(UIButton *)sender {
    UIAlertController *alert;
    if (!self.amountTF.text.length) {
        alert = [UIAlertController showWithMessage:@"请输入提现金额"];
    } else if (!self.phoneTF.text.length) {
        alert = [UIAlertController showWithMessage:self.phoneTF.placeholder];
    } else if (!self.codeTF.text.length) {
        alert = [UIAlertController showWithMessage:self.codeTF.placeholder];
    } else if (!self.pswTF.text.length) {
        alert = [UIAlertController showWithMessage:self.pswTF.placeholder];
    }
    if (alert) {
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [MBProgressHUD showActivityIndicator];
    self.req.price = self.amountTF.text;
    self.req.requestNeedActive = YES;

}


@end
