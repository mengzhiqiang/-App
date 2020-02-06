//
//  RegisterVC.m
//  BikeUser
//
//  Created by 高伟鹏 on 2019/8/23.
//  Copyright © 2019 gwp. All rights reserved.
//

#import "RegisterVC.h"
#import "TimeOfcCodeButton.h"

#import "WKBaseWebViewController.h"

#import "SOCAccountTools.h"
@interface RegisterVC ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF2;
@property (weak, nonatomic) IBOutlet TimeOfcCodeButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (assign, nonatomic)  BOOL isReadServer;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH -43*2,50);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:190/255.0 blue:231/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:0/255.0 green:162/255.0 blue:231/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [self.registerButton.layer addSublayer:gl];
    
    [_codeButton LoadCountLable];
    [_codeButton addTarget:self action:@selector(loadNewCodeWithIphone) forControlEvents:UIControlEventTouchUpInside];
    
    self.customNavBar.backgroundColor = [UIColor clearColor];
      [self.customNavBar setBarBackgroundColor:[UIColor clearColor]];
      self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
           //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
           tapGestureRecognizer.cancelsTouchesInView = NO;
           //将触摸事件添加到当前view
           [self.view addGestureRecognizer:tapGestureRecognizer];
       
}

-(void)loadNewCodeWithIphone{
    
    [self hideKeyBoard];
    _codeButton.codeStyle=[NSString stringWithFormat:@"1"];
    [_codeButton loadNewCodeWithIphone:_phoneTF.text];
}

////隐藏键盘
- (void)hideKeyBoard
{
    [_phoneTF resignFirstResponder];
    [_codeTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    [_passwordTF2 resignFirstResponder];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (IBAction)registerAgreemntAction:(id)sender {
    [self getGoodsDetail];
//    RegisterAgreemtnVC *VC = [[ RegisterAgreemtnVC alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)clickButton:(UIButton *)sender {
    if (sender.tag==10) {
        _isReadServer = !_isReadServer;
        if (_isReadServer) {
                    [sender setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateNormal];
        }else{
            [sender setImage:[UIImage imageNamed:@"xz"] forState:UIControlStateNormal];

        }
    }else{
        if (!_isReadServer) {
            [MBProgressHUD showError:@"未选择用户协议"];
        }
        
          [self hideKeyBoard];

            if( _phoneTF.text.length == 0 ) {
                [MBProgressHUD  showError:@"请输入手机号！"];
                return;
            }
            else if ( _phoneTF.text.length != 11) {
                [MBProgressHUD  showError:@"手机号输入格式不正确!"];
                return;
            }
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"phone"] = _phoneTF.text;
            
                if ([_passwordTF.text length]==0) {
                    [MBProgressHUD  showError:@"请输入密码！"];
                    return;
                }
                if ([_passwordTF.text length]>32 || [_passwordTF.text length]<6) {
                    [MBProgressHUD  showError:@"请设置6-32位密码！"];
                    return;
                }
                NSRange range=[_passwordTF.text rangeOfString:@" "];
                if(range.location!=NSNotFound){
                    [MBProgressHUD  showError:@"用户密码不能有空格！"];
                    return;
                }
                
                param[@"password"] = _passwordTF.text;
                param[@"confirm_password"] = _passwordTF.text;
                param[@"code"] = _codeTF.text;

        WS(weakself);
            [MBProgressHUD showActivityIndicator];
            NSString *path = [API_HOST stringByAppendingString:client_register];
            [HttpEngine requestPostWithURL:path params:param isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
                [MBProgressHUD hideActivityIndicator];
                [CommonVariable saveUserInfoDataWithResponseObject:[responseObject objectForKey:@"data"]];

                [[SOCAccountTools shareSOCAccountTool] SocRegisterWithUsername:weakself.phoneTF.text password:weakself.passwordTF.text completion:^(NSString * _Nonnull result) {
                    
                    if ([result isEqualToString:@"success"]) {
                        [MBProgressHUD showSuccess:@"注册成功,开始登陆！"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD hideActivityIndicator];
                NSDictionary *userInfo = error.userInfo;
                [MBProgressHUD showError:userInfo[@"message"]];

                
            }];
        
    }
}



-(void)getGoodsDetail{

    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_clause_getClause];
    NSDictionary*dict = @{@"type":@(0)};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:dict isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary * d = [responseObject objectForKey:@"data"] ;
        if (d.allKeys.count ) {
            WKBaseWebViewController *vc = [[WKBaseWebViewController alloc] init];
            vc.headTitle = @"注册协议";
            vc.webStr = [d objectForKey:@"content"];
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
