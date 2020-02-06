//
//  LMHBaseViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 28/6/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBaseViewController.h"

@interface LMHBaseViewController ()

@end

@implementation LMHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor HexString:@"#F7F9FC"];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavBar];
}

- (void)setupNavBar {
    [self.view addSubview:self.customNavBar];
    // 设置自定义导航栏背景颜色
    self.customNavBar.barBackgroundColor = White_Color;
    [self.customNavBar wr_setBottomLineHidden:YES];
    // 设置自定义导航栏标题颜色
    self.customNavBar.titleLabelColor = Black_Color;
    self.customNavBar.titleLabelFont = [UIFont boldSystemFontOfSize:18];
    if (self.navigationController.childViewControllers.count != 1) {
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back_black"]];
    }
    self.customNavBar.backgroundColor = Main_Color;
    
}
- (WRCustomNavigationBar *)customNavBar {
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MBProgressHUD hideActivityIndicator];
    [self.navigationController setNavigationBarHidden:YES];
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
