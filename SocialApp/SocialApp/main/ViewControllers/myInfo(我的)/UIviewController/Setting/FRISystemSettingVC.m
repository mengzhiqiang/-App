//
//  FRISystemSettingVC.m
//  SocialApp
//
//  Created by wfg on 2019/12/31.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRISystemSettingVC.h"
#import "UIAlertController+Simple.h"
#import "FRILoginPasswordVC.h"
#import "BENLoginViewController.h"

@interface FRISystemSettingVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITableView *tv;
@end

@implementation FRISystemSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"系统设置";
    self.data = @[
        @[@"允许查看朋友圈范围",],
        @[@"登录密码设置", @"修改绑定手机", @"支付密码"],
        @[@"意见反馈", @"关于我们", @"清除缓存"]
    ];
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tv.backgroundColor = Main_BG_Color;
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    tv.separatorColor = [UIColor colorWithHexValue:0xF5F5F5];
    [self.view addSubview:tv];
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.mas_topLayoutGuide).offset(44);
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:btn];
    btn.frame = CGRectMake(0, 10, SCREEN_WIDTH, 49);
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexValue:0xFF4444] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(loginOutAction:) forControlEvents:UIControlEventTouchUpInside];
    tv.tableFooterView = view;
    self.tv = tv;
}


- (void)loginOutAction:(UIButton *)sender {
    
    
    [CommonVariable removeUserInfoData];
    //退出环信
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        
    }];
    
    UIViewController * viewC = self.navigationController.viewControllers.firstObject;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [viewC.navigationController pushViewController:[BENLoginViewController new] animated:YES];
}


#pragma TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.data[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = Main_title_Color;
    }
    cell.textLabel.text = self.data[indexPath.section][indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController showSheetTitles:@[@"最近一个月", @"最近半年", @"全部"] backIndex:^(UIAlertAction * _Nonnull UIAlertAction, NSInteger index) {
                
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[FRILoginPasswordVC viewControllerWithXib] animated:YES];
        }
    }

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
