//
//  BENLoginViewController.m
//  FindWorker
//
//  Created by zhiqiang meng on 4/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "BENLoginViewController.h"
#import "BENRegisterViewController.h"
#import "TimeOfcCodeButton.h"
#import "FWRForgetPasswordController.h"
#import "WXApiManager.h"
#import "AppDelegate.h"
#import "SOCAccountTools.h"
#import "BSGradientButton.h"
#import "FRICardEnterViewController.h"


@interface BENLoginViewController ()<PassCodeOfiPoneDelegate,WXApiDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet TimeOfcCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet BSGradientButton *longinBtn;
@property (weak, nonatomic) IBOutlet UIView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (assign, nonatomic)  int  loginStyle;
@property (weak, nonatomic) IBOutlet UIButton *pswdLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

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

    if (iPhone5 || isPAD_or_IPONE4) {
        self.headImageView.top = -50;
        self.headImage.hidden = YES;
    }
    
    [_longinBtn draCirlywithColor:nil andRadius:_longinBtn.height/2];
    _phoneTextField.delegate = self;
//    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}
-(void)loadNewCodeWithIphone{
    
    [self hideKeyBoard];
    _codeBtn.codeStyle=[NSString stringWithFormat:@"1"];
    [_codeBtn loadNewCodeWithIphone:_phoneTextField.text];
    
}
////隐藏键盘
- (void)hideKeyBoard
{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _phoneTextField) {
        if (_phoneTextField.text.length>=11 && string.length>0) {
            return NO;
        }
    }
    return YES;
    
}

- (IBAction)youkelogin:(id)sender {
    /* 隐藏输入框 */
    [self hideKeyBoard];

}
- (NSMutableDictionary *)addKeyNamedic:(NSMutableDictionary *)dic{

//    NSString  *timestamp = [NSString stringWithFormat:@"%lld",[self currentTimeStamp]];
//    NSString  *nonce = [NSString stringWithFormat:@"%d",[self getRandomNumber:100000 to:999999]];
//    NSString *base = [NSString base64EncodedString:[NSString stringWithFormat:@"%@%@%@",timestamp,nonce,      @"c29mdGx1cXVAbzJv"]];
//    NSString *sign = [NSString md5EncodedString: base];
//    [dic setObject:sign forKey:@"sign"];
//    [dic setObject:nonce forKey:@"nonce"];
//    [dic setObject:timestamp forKey:@"timestamp"];
//    [dic setObject: @"" forKey:@"token"];
//    [dic setObject:@"ios" forKey:@"devices"];
//        [dic setObject:@"15819106470" forKey:@"mobile"];
//    [dic setObject:@"a1234567" forKey:@"password"];

    
    return dic;
    
}
- (UInt64)currentTimeStamp {
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    return recordTime;
}
- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
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
    param[@"userPhone"] = _phoneTextField.text;
    
        if ([_codeTextField.text length]==0) {
            [MBProgressHUD  showError:@"请输入密码！"];
            return;
        }

    NSRange range=[_codeTextField.text rangeOfString:@" "];
    if(range.location!=NSNotFound){
            [MBProgressHUD  showError:@"用户密码不能有空格！"];
            return;
        }
        
        param[@"password"] = _codeTextField.text;
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:account_login];
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:param isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        NSMutableDictionary * diction = [NSMutableDictionary dictionaryWithDictionary: [responseObject objectForKey:@"data"]];
        [diction setObject:self.codeTextField.text forKey:@"userPassWord"];
        
        [CommonVariable saveUserInfoDataWithResponseObject:diction];
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [dele loginMainvc];
        [[SOCAccountTools shareSOCAccountTool] SocLoginWithUsername:diction[@"username"] password:self.codeTextField.text completion:^(NSString * _Nonnull result) {
//                  [MBProgressHUD showSuccess:@"登陆成功！"];
//                 [self.navigationController popViewControllerAnimated:YES];
            }];
        
        if (diction[@"userIdentity"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController  pushViewController:[FRICardEnterViewController new] animated:YES];
        }
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        
        [MBProgressHUD showError:userInfo[@"message"]];
    }];
    
}


- (IBAction)lowBten:(UIButton *)sender {
    
    if (sender.tag==10) {
        BENRegisterViewController * registerVC = [[BENRegisterViewController alloc]init];
        registerVC.customNavBar.title = @"注册";
        [self.navigationController pushViewController:registerVC animated:YES];
    }else if (sender.tag==11){ // 忘记密码
        FWRForgetPasswordController *vc = [FWRForgetPasswordController new];
        [self.navigationController pushViewController:vc animated:YES];
        
//        [self.navigationController  pushViewController:[FRICardEnterViewController new] animated:YES];

    }else if (sender.tag==12){

    }
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
        _codeTextField.secureTextEntry = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.lineLabel.centerX = self.pswdLoginButton.centerX;
        }];
        
    }else{
        [_pswdLoginButton setTitleColor:[UIColor HexString:@"333333"] forState:UIControlStateNormal];
        [_codeLoginButton setTitleColor:[UIColor HexString:@"DB2A21"] forState:UIControlStateNormal];
        _loginStyle = 1;
        _codeTextField.placeholder = @"请输入密码";
        _codeBtn.hidden = YES;
        _codeTextField.secureTextEntry = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.lineLabel.centerX = self.codeLoginButton.centerX;
        }];
    }
    
}

@end
