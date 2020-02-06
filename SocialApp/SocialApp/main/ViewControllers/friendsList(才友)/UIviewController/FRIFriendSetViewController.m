//
//  FRIFriendSetViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 15/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIFriendSetViewController.h"
#import "LLRightCell.h"
#import "ZCBFeedBackViewController.h"
#import "LMHChangeUserNameVC.h"

static NSString *const LLRightCellid = @"LLRightCell";

@interface FRIFriendSetViewController ()<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;/** <#class#> **/


@end

@implementation FRIFriendSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.customNavBar setTitle:@"更多"];
    [self.view addSubview:self.tableView];
}
#pragma mark  懒加载
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = Main_BG_Color;
        [ _tableView  registerClass:[LLRightCell class] forCellReuseIdentifier:LLRightCellid];
    }
    return _tableView;
}
static NSString *const LLChargeDetailsCellID = @"LLChargeDetailsCell";
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 || section ==2 ) {
        return  1 ;
    } else  if (section ==1 && _isFirend) {
        return  2;
    }else  if (section ==3 && _isFirend) {
        return  1 ;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==3) {
        return 20 ;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view =[[UIView alloc]init];
    view.backgroundColor = Main_BG_Color;
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLRightCell *cell = [tableView dequeueReusableCellWithIdentifier:LLRightCellid];
    
    cell.textview.hidden = YES;
    cell.showimage.hidden = YES;
    cell.rightlable.hidden = YES;

    if (indexPath.section==0) {
        cell.titlelable.text = @"设置备注名";
        cell.rightlable.text = @"昵称";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
     else if (indexPath.section==1) {
        cell.titlelable.text = @[@"设置置顶",@"不让他看朋友圈"][indexPath.row];
         UISwitch *onSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 5, 40, 30)];
         onSwitch.on = NO;
         onSwitch.tag = indexPath.row+10;
         [onSwitch addTarget:self action:@selector(changeOnOff:) forControlEvents:UIControlEventValueChanged];
         onSwitch.onTintColor = Main_Color;
         onSwitch.tintColor = [UIColor grayColor];

         if (indexPath.row==1) {
            onSwitch.on = YES;
         }
         [cell addSubview:onSwitch];
         
    } else if (indexPath.section==2) {
        cell.titlelable.text = @"投诉";
        cell.titlelable.textColor = Main_Color;

    }else if (indexPath.section==3) {
        cell.titlelable.text = @"删除好友";
        cell.titlelable.textColor = [UIColor redColor];
        cell.titlelable.textAlignment = NSTextAlignmentCenter;
        [cell.titlelable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(15));
            make.left.equalTo(@(SCREEN_WIDTH/2-50));
            make.width.equalTo(@(100));
        }];
    }
    
    return cell;
}

-(void)changeOnOff:(UISwitch*)onSwitch{
    
    if (onSwitch.tag==10) {
        
    }else{
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        NSLog(@"改备注");
        LMHChangeUserNameVC * lmhVC = [[LMHChangeUserNameVC alloc] init];
        [self.navigationController pushViewController:lmhVC animated:YES];
    }else  if (indexPath.section==2) {
        NSLog(@"投诉");
        ZCBFeedBackViewController * feedBack = [[ZCBFeedBackViewController alloc]init];
        [self.navigationController pushViewController:feedBack animated:YES];
    }else  if (indexPath.section==3) {
        NSLog(@"删好友");
    }
}

@end
