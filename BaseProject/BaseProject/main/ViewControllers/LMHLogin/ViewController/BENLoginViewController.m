//
//  BENLoginViewController.m
//  FindWorker
//
//  Created by zhiqiang meng on 4/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "BENLoginViewController.h"
//#import "BENRegisterViewController.h"
#import "WechatAuthSDK.h"

#import "TimeOfcCodeButton.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "BenBandPhoneViewController.h"
#import "LMHBindInviteCodeVC.h"
#import "WKBaseWebViewController.h"
#import "WKwebViewController.h"
@interface BENLoginViewController ()<PassCodeOfiPoneDelegate,UITextFieldDelegate,WechatAuthAPIDelegate,WXApiManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet TimeOfcCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *longinBtn;
@property (weak, nonatomic) IBOutlet UIView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (assign, nonatomic)  int  loginStyle;
@property (weak, nonatomic) IBOutlet UIButton *pswdLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIView *lowwxinView;

@end

@implementation BENLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [_codeBtn LoadCountLable];
    [_codeBtn addTarget:self action:@selector(loadNewCodeWithIphone) forControlEvents:UIControlEventTouchUpInside];
    [_longinBtn draCirlywithColor:nil andRadius:10.0f];
    if (iPhone5 || isPAD_or_IPONE4) {
        self.headImageView.top = -50;
        self.headImage.hidden = YES;
    }
    
    [_headImage draCirlywithColor:nil andRadius:_headImage.height/2];

    _phoneTextField.delegate = self;
    _codeTextField.delegate = self;
    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [WXApiManager sharedManager].delegate = self;
    
    if ([WXApi isWXAppInstalled]) {
        _lowwxinView.hidden = NO;
    }else{
        _lowwxinView.hidden = YES;

    }
    
}
-(void)loadNewCodeWithIphone{
    
    [self hideKeyBoard];
    _codeBtn.codeStyle=[NSString stringWithFormat:@"2"];
    [_codeBtn loadNewCodeWithIphone:_phoneTextField.text];
    
}
////隐藏键盘
- (void)hideKeyBoard
{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    
}

- (void) textFieldDidChange:(UITextField *) TextField{
    
    if (_phoneTextField.text.length == 11 ) {
        _codeBtn.count_label.textColor = Main_Color;
    }else{
        _codeBtn.count_label.textColor = [UIColor HexString:@"999999"];
    }
    
    _longinBtn.enabled = YES;
    _codeBtn.enabled = YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideKeyBoard];
    return YES;
}
//
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _phoneTextField) {
        if (_phoneTextField.text.length>=11 && string.length>0) {
            return NO;
        }
    }
    return YES;
    
}

#pragma mark - 登录请求
- (IBAction)login:(id)sender {
    
    /* 隐藏输入框 */
    [self hideKeyBoard];

    if( _phoneTextField.text.length == 0 ) {
        [MBProgressHUD  showError:@"请输入手机号！"];
        return;
    }
    else if ( _phoneTextField.text.length != 11) {
        [MBProgressHUD  showError:@"手机号输入格式不正确!"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = _phoneTextField.text;
    
    if (_loginStyle==1) {
        if ([_codeTextField.text length]==0) {
            [MBProgressHUD  showError:@"请输入密码！"];
            return;
        }
        if ([_codeTextField.text length]>32 || [_codeTextField.text length]<6) {
            [MBProgressHUD  showError:@"请设置6-32位密码！"];
            return;
        }
        NSRange range=[_codeTextField.text rangeOfString:@" "];
        if(range.location!=NSNotFound){
            [MBProgressHUD  showError:@"用户密码不能有空格！"];
            return;
        }
        
        param[@"password"] = _codeTextField.text;
    }else{
        if ([_codeTextField.text length]==0) {
            [MBProgressHUD  showError:@"请输入验证码！"];
            return;
        }
        NSRange range=[_codeTextField.text rangeOfString:@" "];
        if(range.location!=NSNotFound){
            [MBProgressHUD  showError:@"验证码不能有空格！"];
            return;
        }
        param[@"code"] = _codeTextField.text;

    }

    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:account_login];
    [HttpEngine requestPostWithURL:path params:param isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        [CommonVariable saveUserInfoDataWithResponseObject:[responseObject objectForKey:@"data"]];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
   
        if ([userInfo[@"code"] integerValue] == 417) {
            LMHBindInviteCodeVC * Bindvc = [[LMHBindInviteCodeVC alloc] initWithNibName:@"LMHBindInviteCodeVC" bundle:[NSBundle mainBundle]] ;
            Bindvc.phone = _phoneTextField.text ;
            Bindvc.code = _codeTextField.text ;
            [self.navigationController pushViewController:Bindvc animated:YES];
        }else{
            NSLog(@"==JSONDic=userInfo==%@",userInfo);
            [MBProgressHUD showError:userInfo[@"msg"]];
        }
        
        
    }];
    
}

- (IBAction)lowBten:(UIButton *)sender {
    
    if (sender.tag==10) {
    }else if (sender.tag==11){
        //协议
    }else if (sender.tag==12){
        [self sendAuthRequest];
    }
}

-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"lmhWinxinLogin";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}
//登录结果
- (void)managerDidRecvAuthResponse:(NSDictionary *)response {
    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    NSString *strMsg = [NSString stringWithFormat:@"code:%@", response];
    NSLog(@"==strTitle=%@===%@",strTitle , strMsg) ;
    
    [self getloginWX:response];
}

-(void)getloginWX:(NSDictionary*)response{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_weChatLogin];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"openId"] = response[@"unionid"];
    param[@"portrait"] = response[@"headimgurl"];
    param[@"user_name"] = response[@"nickname"];

    
    [HttpEngine requestPostWithURL:path params:param isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        NSDictionary * diction = [responseObject objectForKey:@"data"] ;
        NSLog(@"==微信登录=userInfo==%@",diction);

        if (diction[@"token"]) {
            [CommonVariable saveUserInfoDataWithResponseObject:[responseObject objectForKey:@"data"]];
            [self.navigationController popToRootViewControllerAnimated:YES];

        }else {
            BenBandPhoneViewController * bandVC = [[BenBandPhoneViewController alloc]init];
            bandVC.response = response;
            [self.navigationController pushViewController:bandVC animated:YES];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
    }];
}

#pragma mark 更换 密码或验证码 选择按钮
- (IBAction)changeLonginStyle:(UIButton *)sender {
    
    _codeTextField.text = nil ;
    if (sender.tag==10) {
        [_pswdLoginButton setTitleColor:[UIColor HexString:@"DB2A21"] forState:UIControlStateNormal];
        [_codeLoginButton setTitleColor:[UIColor HexString:@"333333"] forState:UIControlStateNormal];
        _loginStyle = 0;
        _codeTextField.placeholder = @"请输入验证码";
        _codeBtn.hidden = NO;
        _codeTextField.secureTextEntry = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.lineLabel.centerX = self.pswdLoginButton.centerX;
        }];
        
    }else{
        [_pswdLoginButton setTitleColor:[UIColor HexString:@"333333"] forState:UIControlStateNormal];
        [_codeLoginButton setTitleColor:[UIColor HexString:@"DB2A21"] forState:UIControlStateNormal];
        _loginStyle = 1;
        _codeTextField.placeholder = @"请输入密码";
        _codeBtn.hidden = YES;
        _codeTextField.secureTextEntry = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.lineLabel.centerX = self.codeLoginButton.centerX;
        }];
    }
    
}
- (IBAction)severButton:(UIButton *)sender {
    
    [self getGoodsDetail];
   
}
-(void)getGoodsDetail{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_Iamage_HOST stringByAppendingString:client_clause_getClause];
    NSDictionary*dict = @{@"clauseType":@(3)};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:dict isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [MBProgressHUD hideActivityIndicator];
        NSArray * array = [responseObject objectForKey:@"data"] ;
        if (array.count ) {
            WKBaseWebViewController *vc = [[WKBaseWebViewController alloc] init];
            vc.headTitle = @"用户协议";
            vc.webStr = [[array objectAtIndex:0]objectForKey:@"content"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}
@end
