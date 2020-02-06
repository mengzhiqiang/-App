//
//  ForgetVC.m
//  BikeUser
//
//  Created by 高伟鹏 on 2019/8/25.
//  Copyright © 2019 gwp. All rights reserved.
//

#import "ForgetVC.h"
#import "TimeOfcCodeButton.h"

@interface ForgetVC ()
@property (weak, nonatomic) IBOutlet UIButton *referButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet TimeOfcCodeButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF2;

@end

@implementation ForgetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.isAlter) {
        self.title = @"修改密码";
        self.forgetButton.hidden = NO;

    }else{
        self.title = @"忘记密码";

    }
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH - 43*2 ,50);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:190/255.0 blue:231/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:0/255.0 green:162/255.0 blue:231/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    
    [self.referButton.layer addSublayer:gl];
    
    [_codeButton LoadCountLable];
      [_codeButton addTarget:self action:@selector(loadNewCodeWithIphone) forControlEvents:UIControlEventTouchUpInside];
      
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

////隐藏键盘
- (void)hideKeyBoard
{
    [_phoneTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    [_codeTF resignFirstResponder];
    [_passwordTF2 resignFirstResponder];

}

-(void)loadNewCodeWithIphone{
    
    [self hideKeyBoard];
    _codeButton.codeStyle=[NSString stringWithFormat:@"2"];
    [_codeButton loadNewCodeWithIphone:_phoneTF.text];
}
- (IBAction)changePassword:(UIButton *)sender {
    
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

    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:account_login];
    [HttpEngine requestPostWithURL:path params:param isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        [CommonVariable saveUserInfoDataWithResponseObject:[responseObject objectForKey:@"data"]];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        [MBProgressHUD showError:userInfo[@"message"]];

        
    }];
}

- (IBAction)forgetButtonAction:(id)sender {
    ForgetVC *VC = [[ForgetVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
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
