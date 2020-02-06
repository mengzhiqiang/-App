//
//  FRILoginPasswordVC.m
//  SocialApp
//
//  Created by wfg on 2019/12/31.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRILoginPasswordVC.h"

@interface FRILoginPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *originTF;
@property (weak, nonatomic) IBOutlet UITextField *resetTF1;
@property (weak, nonatomic) IBOutlet UITextField *resetTF2;

@end

@implementation FRILoginPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"修改登录密码";
}

- (IBAction)confirmAction:(UIButton *)sender {
    if (!self.originTF.text.length) {
        [MBProgressHUD showError:self.originTF.placeholder];
        return;
    }
    if (!self.resetTF1.text.length) {
        [MBProgressHUD showError:self.resetTF1.placeholder];
        return;
    }
    if (![self.resetTF2.text isEqualToString:self.resetTF1.text]) {
        [MBProgressHUD showError:@"新密码两次输入不一致"];
        return;
    }

}

- (IBAction)forgetAction:(UIButton *)sender {
    
}
@end
