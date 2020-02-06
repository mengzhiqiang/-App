//
//  SAWithdrawVC.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/11.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "SAWithdrawVC.h"
#import "SAWithdrawRequest.h"
#import "UIAlertController+Simple.h"
@interface SAWithdrawVC ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *channelBtns;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UITextField *receiptTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alipayMsgHeight;

@property (weak, nonatomic) IBOutlet UIButton *allMoneyBtn;

@property (nonatomic, strong) SAWithdrawRequest *req;
@end

@implementation SAWithdrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"提现";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.allMoneyBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"全部提现" attributes:@{NSUnderlineStyleAttributeName:@(1), NSForegroundColorAttributeName:Main_Color}] forState:UIControlStateNormal];
    self.req = [SAWithdrawRequest Request];
    self.req.type = @"3";
    if (self.pointsWithdraw) {
        self.req.PATH = @"api/user/pointWith";
    }
    MJWeakSelf
    self.req.successBlock = ^(NSDictionary *dic) {
        [MBProgressHUD hideActivityIndicator];
        [MBProgressHUD showError:dic[@"msg"]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithdrawSuccess object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
//    self.phoneTF.text = [Global sharedGlobal].curUser.tel;
    self.phoneTF.userInteractionEnabled = NO;
//    self.codeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (IBAction)channelAction:(UIButton *)sender {
    for (UIButton *btn in self.channelBtns) {
        btn.selected = NO;
    }
    sender.selected = YES;
    if (sender.tag == 0) {
            self.req.type = @"3";
        self.alipayMsgHeight.constant = 128;
    } else {
        self.alipayMsgHeight.constant = 0;
        self.req.type = @"2";
    }
    [self.view layoutIfNeeded];
}

- (IBAction)allMoneyAction:(UIButton *)sender {
    self.amountTF.text = self.totalAmount;
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
    BOOL wechat = [self.req.type isEqualToString:@"2"];
    if (!self.amountTF.text.length) {
        alert = [UIAlertController showWithMessage:@"请输入提现金额"];
    } else if (!self.phoneTF.text.length) {
        alert = [UIAlertController showWithMessage:self.phoneTF.placeholder];
    } else if (!self.codeTF.text.length) {
        alert = [UIAlertController showWithMessage:self.codeTF.placeholder];
    } else if (!self.pswTF.text.length) {
        alert = [UIAlertController showWithMessage:self.pswTF.placeholder];
    } else if (!wechat && !self.receiptTF.text.length) {
        alert = [UIAlertController showWithMessage:self.receiptTF.placeholder];
    } else if (!wechat && !self.nameTF.text.length) {
        alert = [UIAlertController showWithMessage:self.nameTF.placeholder];
    }
    if (alert) {
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [MBProgressHUD showActivityIndicator];
    self.req.price = self.amountTF.text;
    self.req.tel = self.phoneTF.text;
    self.req.code = self.codeTF.text;
    self.req.password = self.pswTF.text;
    if (wechat) {
        self.req.receipt = @"";
        self.req.name = @"";
    } else {
        self.req.receipt = self.receiptTF.text;
        self.req.name = self.nameTF.text;
    }
    self.req.requestNeedActive = YES;
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
