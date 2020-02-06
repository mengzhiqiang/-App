//
//  BENRegisterViewController.m
//  FindWorker
//
//  Created by zhiqiang meng on 4/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "BENRegisterViewController.h"
#import "TimeOfcCodeButton.h"
#import "SOCAccountTools.h"
#import "BSGradientButton.h"
//#import "LLWebviewViewController.h"

@interface BENRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageview;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repetpwTextfield;
@property (weak, nonatomic) IBOutlet TimeOfcCodeButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet BSGradientButton *loginButton;

@end

@implementation BENRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_codeButton LoadCountLable];
    [_codeButton addTarget:self action:@selector(loadNewCodeWithIphone:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton draCirlywithColor:nil andRadius:_loginButton.height/2];
    _phoneTextField.delegate = self;
    _codeTextField.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
     //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
     tapGestureRecognizer.cancelsTouchesInView = NO;
     //将触摸事件添加到当前view
     [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor =[UIColor whiteColor];
}

-(void)loadNewCodeWithIphone:(UIButton*)sender{

    [self hideKeyBoard];
     _codeButton.codeStyle=[NSString stringWithFormat:@"0"];
    [_codeButton loadNewCodeWithIphone:_phoneTextField.text];
    
}

- (IBAction)pushXieyi:(id)sender {
//    LLWebviewViewController *vc = [[LLWebviewViewController alloc]init];
//    vc.type = @"2";
//    vc.titleStr = @"注册协议";
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)select:(UIButton *)sender {
    sender.selected = !sender.selected;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _phoneTextField) {
        if (_phoneTextField.text.length>=11 && string.length>0) {
            return NO;
        }
    }
    
    if (textField == _codeTextField) {
           if (_codeTextField.text.length>=6 && string.length>0) {
               return NO;
           }
       }
    return YES;
    
}
- (IBAction)forRegisterButton:(UIButton*)sender {
    
    NSPredicate *passpre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORKZ_ZH];
    
    if( _phoneTextField.text.length == 0 ){
        [MBProgressHUD  showError:@"请输入用户手机号码！"];        return;
    }else if( _phoneTextField.text.length != 11 ){
        [MBProgressHUD  showError:@"用户手机号码格式不对！"];        return;
    }else if (!self.selectButton.selected){
        [MBProgressHUD  showError:@"请阅读并接受使用条款！"];
        return;
    }
    
    NSRange range=[_passwordTextField.text rangeOfString:@" "];

    if(range.location!=NSNotFound){
        [MBProgressHUD  showError:@"密码不能有空格！"];        return;
    }else  if (![passpre evaluateWithObject:_passwordTextField.text]) {
        [MBProgressHUD  showError:@"密码必须由字母、数字或下划线组成！"];        return;
    }else if(!_repetpwTextfield.text.length){
        [MBProgressHUD  showError:@"请再次输入密码！"];        return;
    }else if (![_repetpwTextfield.text isEqualToString:_passwordTextField.text]) {
        [MBProgressHUD  showError:@"密码不一致，请重新输入！"];        return;
    }
    
    [MBProgressHUD hideActivityIndicator];


    [self userToRegisterWith:sender];
}

#pragma mark 普通用户注册
- (void)userToRegisterWith:(UIButton *)sender {
    NSMutableDictionary*dic_register=[[NSMutableDictionary alloc]initWithObjectsAndKeys:_phoneTextField.text,@"userPhone",_codeTextField.text,@"verificationCode",_passwordTextField.text,@"password",@"1",@"type", nil];
    
    [self hideKeyBoard];
    WS(weakself);
    NSString *path = [API_HOST stringByAppendingString:account_register];
    [HttpEngine requestPostWithURL:path params:dic_register isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        NSLog(@"====%@",responseObject);
        [CommonVariable saveUserInfoDataWithResponseObject:[responseObject objectForKey:@"result"]];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideActivityIndicator];
        sender.enabled=YES;
        NSDictionary *userInfo =error.userInfo;
        [MBProgressHUD showError:[userInfo objectForKey:@"message"]];
    }];
    
}

- (void)hideKeyBoard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

@end
