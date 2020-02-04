//
//  BenBandPhoneViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 27/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "BenBandPhoneViewController.h"
#import "TimeOfcCodeButton.h"
#import "LMHBindInviteCodeVC.h"
@interface BenBandPhoneViewController ()<PassCodeOfiPoneDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet TimeOfcCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *longinBtn;
@end

@implementation BenBandPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_codeBtn LoadCountLable];
    [_longinBtn draCirlywithColor:nil andRadius:10.0f];

    self.view.backgroundColor = White_Color;
    _phoneTextField.delegate = self;
    _codeTextField.delegate = self;
    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeBtn addTarget:self action:@selector(loadNewCodeWithIphone) forControlEvents:UIControlEventTouchUpInside];

    self.customNavBar.title = @"绑定手机号码";
}
- (void) textFieldDidChange:(UITextField *) TextField{
    
    if (_phoneTextField.text.length == 11 ) {
        _codeBtn.count_label.textColor = Main_Color;
    }else{
        _codeBtn.count_label.textColor = [UIColor HexString:@"999999"];
    }
    
    if (_phoneTextField.text.length == 11 && _codeTextField.text.length == 6 ) {
        _longinBtn.enabled = YES;
    }else{
        _longinBtn.enabled = NO;
        
    }
    _codeBtn.enabled = YES;

    
}
- (void)loadNewCodeWithIphone {
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
- (IBAction)bandWchat:(UIButton *)sender {
    
    
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
    
    if (_response) {
        param[@"openId"]    = _response[@"unionid"];
        param[@"portrait"]  = _response[@"headimgurl"];
        param[@"user_name"] = _response[@"nickname"];
    }
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_weChatLoginBand];
    [HttpEngine requestPostWithURL:path params:param isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        NSLog(@"===%@",responseObject);
        [MBProgressHUD hideActivityIndicator];
        
        if ([responseObject objectForKey:@"data"]) {
            [CommonVariable saveUserInfoDataWithResponseObject:[responseObject objectForKey:@"data"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        [MBProgressHUD showError:responseObject[@"msg"]];

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

@end
