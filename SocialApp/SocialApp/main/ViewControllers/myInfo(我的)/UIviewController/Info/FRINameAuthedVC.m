//
//  FRINameAuthedVC.m
//  SocialApp
//
//  Created by wfg on 2020/1/2.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "FRINameAuthedVC.h"

@interface FRINameAuthedVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) NSArray *leftData;
@property (nonatomic, strong) NSArray *rightData;
@end

@implementation FRINameAuthedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"实名认证";
    self.leftData =
        @[@"实名认证", @"姓名", @"身份证"];
    self.rightData = @[@"", @"", @""];
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tv.backgroundColor = Main_BG_Color;
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    tv.separatorColor = [UIColor colorWithHexValue:0xF5F5F5];
    [self.view addSubview:tv];
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.mas_topLayoutGuide).offset(54);
    }];
}
#pragma TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = Main_title_Color;
    }
    cell.textLabel.text = self.leftData[indexPath.row];
    cell.detailTextLabel.text = self.rightData[indexPath.row];
    if (indexPath.row == 0) {
//        cell.detailTextLabel.textColor =
    } else {
//        cell.detailTextLabel.textColor =
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.navigationController pushViewController:[FRILoginPasswordVC viewControllerWithXib] animated:YES];
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
