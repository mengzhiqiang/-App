//
//  LMHChangeUserNameVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/3.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHChangeUserNameVC.h"

@interface LMHChangeUserNameVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) UserInfo * info;

@end

@implementation LMHChangeUserNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"昵称";
    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:Main_Color];
    [self.customNavBar setOnClickRightButton:^{
        [self getMyAccount];
    }];
    
    _info = [CommonVariable getUserInfo];
}
-(void)getMyAccount{
    
    NSString * url = [API_HOST stringByAppendingString:client_userManager_eidtUser];
    
    if (_textField.text.length<1) {
        [MBProgressHUD showError:@"昵称不能为空"];return;
    }
    if (_textField.text.length>12) {
        [MBProgressHUD showError:@"昵称不能大于12位"];return;
    }
    
    NSDictionary*dic = @{@"userName":_textField.text};
    WS(weakself);
    [HttpEngine requestPostWithURL:url params:dic isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [MBProgressHUD showSuccess:@"修改成功！"];
        weakself.info.user_name = weakself.textField.text;
        [CommonVariable saveWithModle:  weakself.info];
        [self.navigationController popViewControllerAnimated:YES];
  
    } failure:^(NSError *error) {
        
        
    }];
    
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
