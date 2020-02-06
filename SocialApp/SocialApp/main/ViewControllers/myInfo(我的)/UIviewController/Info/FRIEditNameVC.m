//
//  FRIEditNameVC.m
//  SocialApp
//
//  Created by wfg on 2019/12/31.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIEditNameVC.h"
#import "FRIMineInfoEditRequest.h"
@interface FRIEditNameVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@end

@implementation FRIEditNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"昵称";
    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:Main_Color];
    MJWeakSelf
    self.customNavBar.onClickRightButton = ^{
        if (!weakSelf.nameTF.text.length) {
            [MBProgressHUD showError:weakSelf.nameTF.placeholder];
            return ;
        }
        FRIMineInfoEditRequest *req = [FRIMineInfoEditRequest Request];
        req.userNickname = weakSelf.nameTF.text;
        [MBProgressHUD showActivityIndicator];
        req.successBlock = ^(NSDictionary *dic) {
            [MBProgressHUD hideActivityIndicator];
            [MBProgressHUD showError:dic[@"message"]];
            weakSelf.model.userNickname = weakSelf.nameTF.text;
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateUserInfo object:nil];
        };
        req.requestNeedActive = YES;
    };
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
