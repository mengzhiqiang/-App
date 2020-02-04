//
//  LMHBindInviteCodeVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/7.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBindInviteCodeVC.h"

@interface LMHBindInviteCodeVC ()
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end

@implementation LMHBindInviteCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"邀请码";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)bindAction:(UIButton *)sender {
    [self bandCode];
}

////隐藏键盘
- (void)hideKeyBoard
{
    [_codeTF resignFirstResponder];
    
}
- (void)bandCode {
    
    /* 隐藏输入框 */
    [self hideKeyBoard];
    
    if( _codeTF.text.length == 0 ) {
        [MBProgressHUD  showError:@"请输入邀请码！"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"code"]    = _code;
    param[@"phone"]  = _phone;
    param[@"registerCode"] = _codeTF.text;
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_register];
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
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
            
    }];
    
    
}

@end
