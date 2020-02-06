//
//  LoginVC.m
//  BikeUser
//
//  Created by 高伟鹏 on 2019/8/23.
//  Copyright © 2019 gwp. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "ForgetVC.h"
#import "SOCAccountTools.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH -43*2,50);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:190/255.0 blue:231/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:0/255.0 green:162/255.0 blue:231/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    
    [self.loginButton.layer addSublayer:gl];
//    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    WS(weakself);
    [self.customNavBar wr_setRightButtonWithTitle:@"注册" titleColor:Main_title_Color];
    [self.customNavBar setOnClickRightButton:^{
        RegisterVC *VC = [[RegisterVC alloc]init];
          [weakself.navigationController pushViewController:VC animated:YES];
    }];
    
//    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"guanbijiantou"]];
    self.customNavBar.backgroundColor = [UIColor clearColor];
    [self.customNavBar setBarBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor whiteColor];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
     //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
     tapGestureRecognizer.cancelsTouchesInView = NO;
     //将触摸事件添加到当前view
     [self.view addGestureRecognizer:tapGestureRecognizer];
#ifdef DEBUG
    self.phoneTF.text = @"13660418257";
    self.passwordTF.text = @"123456";
#endif
}

////隐藏键盘
- (void)hideKeyBoard
{
    [_phoneTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    
}
#pragma mark - 忘记密码
- (IBAction)ForgetAction:(id)sender {
    ForgetVC *VC = [[ForgetVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}


//设置导航条透明
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
#pragma mark - 注册
-(void)registerAction{
    RegisterVC *VC = [[RegisterVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)loginAction:(id)sender {
    
    
     /* 隐藏输入框 */
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
 
    WS(weakself);
    
    [[SOCAccountTools shareSOCAccountTool] SocLoginWithUsername:weakself.phoneTF.text password:weakself.passwordTF.text completion:^(NSString * _Nonnull result) {
             [MBProgressHUD showSuccess:@"登陆成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    
     [MBProgressHUD showActivityIndicator];
     NSString *path = [API_HOST stringByAppendingString:account_login];
     [HttpEngine requestPostWithURL:path params:param isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
         [MBProgressHUD hideActivityIndicator];
         NSDictionary*diction = [responseObject objectForKey:@"data"];

         [CommonVariable saveUserInfoDataWithResponseObject:diction];
         
         [[SOCAccountTools shareSOCAccountTool] SocLoginWithUsername:weakself.phoneTF.text password:weakself.passwordTF.text completion:^(NSString * _Nonnull result) {
                           
                    if ([result isEqualToString:@"success"]) {
                               [MBProgressHUD showSuccess:@"登陆成功！"];
                               [self.navigationController popViewControllerAnimated:YES];
                    }
             }];
         
             /*
             if ([diction[@"status"] integerValue]== 0) {
                  BIKBeStroeViewController * bikAppleVC =[BIKBeStroeViewController new];
                 [self.navigationController pushViewController:bikAppleVC animated:YES];
                             return ;
             } else if ([diction[@"status"] integerValue]==-1){
                 [AFAlertViewHelper  alertViewWithTitle:@"" message:@"门店审核未通过，请重新提交申请" delegate:self cancelTitle:@"确认" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
                        BIKBeStroeViewController * bikAppleVC =[BIKBeStroeViewController new];
                     bikAppleVC.statue = 1; 
                        [self.navigationController pushViewController:bikAppleVC animated:YES];
                             }];
             
                 return;
             }else if ([diction[@"status"] integerValue]==1){
                 [AFAlertViewHelper  alertViewWithTitle:@"" message:@"门店申请审核中" delegate:self cancelTitle:@"确认" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
                     
                 }];
                 return;
             }
              */
         
         [self.navigationController popViewControllerAnimated:YES];
     } failure:^(NSError *error) {
         
         [MBProgressHUD hideActivityIndicator];
         NSDictionary *userInfo = error.userInfo;
         [MBProgressHUD showError:userInfo[@"message"]];

         
     }];
    
    
//       BIKBeStroeViewController *VC = [[BIKBeStroeViewController alloc]init];
//       [self.navigationController pushViewController:VC animated:YES];
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
