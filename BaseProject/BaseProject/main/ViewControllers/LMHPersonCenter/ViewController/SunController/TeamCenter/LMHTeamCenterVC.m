//
//  LMHTeamCenterVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHTeamCenterVC.h"
#import "FWRPickerView.h"
#import "LMHTeamMemberDetailVC.h"
#import "LMHInviteFriendVC.h"
#import "LMHTeamModel.h"
#import "WKBaseWebViewController.h"
#import "LMHSearchTableViewCell.h"
@interface LMHTeamCenterVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) FWRPickerView *pickerView;

@property (strong, nonatomic) NSDictionary * dateDic;
@property (strong, nonatomic) NSString * dateString;
@property (strong, nonatomic) UIButton * dateButton;

@property (strong, nonatomic) NSArray <LMHTeamModel*> * lever1_array;
@property (strong, nonatomic) NSArray <LMHTeamModel*> * lever2_array;

@end

@implementation LMHTeamCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"团队中心";
    self.customNavBar.titleLabelColor = [UIColor colorWithWhite:0 alpha:0];
    [self.customNavBar wr_setRightButtonWithTitle:@"规则" titleColor:[UIColor whiteColor]];
    self.customNavBar.barBackgroundColor = [UIColor clearColor];
    self.customNavBar.backgroundColor = [UIColor clearColor];

    WS(weakself);
    self.customNavBar.onClickRightButton = ^{
        [weakself getHelpCenter];
    };
    
    CGFloat ratio = 467.0/375;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*ratio)];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grzx_tdzx_yqhy"]];
    iv.frame = CGRectMake(0, 0, view.width, view.height);
    [view addSubview:iv];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 387*SCREEN_WIDTH/375, SCREEN_WIDTH, 50*SCREEN_WIDTH/375);
    [view addSubview:btn];
    [btn addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
    self.tv.tableHeaderView = view;
//    self.tv.tableFooterView = [UIView new];
    self.tv.rowHeight = 75;
    
    self.tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    }];
    
    [self.tv.mj_footer  endRefreshingWithNoMoreData];
    [self getRegisterCodes];
}

- (FWRPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[FWRPickerView alloc] init];
        [_pickerView setupPickerStyle:pickerDataTypeAccount];
        [self.view addSubview:self.pickerView];

    }
    return _pickerView;
}

- (void)invite:(UIButton *)sender {
    LMHInviteFriendVC *vc = [[LMHInviteFriendVC alloc] initWithNibName:@"LMHInviteFriendVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)datePick:(UIButton *)sender {
    WS(weakself);
    self.pickerView.backPickerInfo = ^(NSDictionary * _Nonnull diction) {
        weakself.dateDic = diction ;
        weakself.dateString = [NSString stringWithFormat:@"%@/%@ ", diction[@"0"], diction[@"1"]];
        [sender setTitle:weakself.dateString forState:UIControlStateNormal];

        [self getRegisterCodes];
    };
    [self.pickerView showPickerView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 88 : 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSInteger  count=0  ;     CGFloat  sum =0.0 ;

    if (section==0) {
        for (LMHTeamModel* model in _lever1_array) {
            sum = model.businessBalance.floatValue + sum;
            count++;
        };
    }else{
        for (LMHTeamModel* model in _lever2_array) {
            sum = model.businessBalance.floatValue +sum;
            count++;
        };
    }
    
    UIView *view = [UIView new];
    UILabel *leftLbl = [UILabel new];
    leftLbl.text = [NSString stringWithFormat:@"我的%@团员(%lu)",(section==0?@"直属":@"间接"),count];
    if (section == 1) {
        leftLbl.text = [NSString stringWithFormat:@"我的%@团员",@"间接"];
    }
    leftLbl.font = [UIFont systemFontOfSize:15];
    leftLbl.textColor = Main_title_Color;
    [view addSubview:leftLbl];
    [leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.centerY.equalTo(view);
    }];
    
    UILabel *rightLbl = [UILabel new];
    rightLbl.text = [NSString stringWithFormat:@"¥ %.2f",sum];
    rightLbl.font = [UIFont systemFontOfSize:15];
    rightLbl.textColor = Main_title_Color;
    [view addSubview:rightLbl];
    [rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.centerY.equalTo(view);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = Main_BG_Color;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(0);
        make.height.offset(0.5);
    }];
    if (section == 0) {
        UIView *topView = [UIView new];
        _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateButton setTitle:(_dateString?_dateString:@"本月") forState:UIControlStateNormal];
        [_dateButton setTitleColor:Main_title_Color forState:UIControlStateNormal];
        _dateButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [topView addSubview:_dateButton];
        [_dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(25);
            make.centerY.equalTo(topView);
        }];
        [_dateButton addTarget:self action:@selector(datePick:) forControlEvents:UIControlEventTouchUpInside];
        {
            UILabel *rightLbl = [UILabel new];
            rightLbl.text = @"销售额";
            rightLbl.font = [UIFont systemFontOfSize:15];
            rightLbl.textColor = Main_title_Color;
            [topView addSubview:rightLbl];
            [rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-16);
                make.centerY.equalTo(topView);
            }];
        }
        {
            UIView *line = [UIView new];
            line.backgroundColor = Main_BG_Color;
            [topView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.right.offset(-15);
                make.bottom.offset(0);
                make.height.offset(0.5);
            }];
        }
        UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [minusBtn setImage:[UIImage imageNamed:@"grzx_tdzx_left"] forState:UIControlStateNormal];
        [topView addSubview:minusBtn];
        [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(topView);
        }];
        minusBtn.tag = 10;
        [minusBtn addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventTouchUpInside];

        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"grzx_tdzx_right"] forState:UIControlStateNormal];
        [topView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_dateButton.mas_right).offset(5);
            make.centerY.equalTo(topView);
        }];
        addBtn.tag = 11;
        [addBtn addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *conView = [UIView new];
        [conView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(conView);
            make.height.offset(44);
        }];
        [conView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(conView);
            make.height.offset(44);
            make.top.equalTo(topView.mas_bottom);
        }];
        return conView;
    } else {
        return view;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section==0 ?_lever1_array.count:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"LMHSearchTableViewCell";
    LMHSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMHSearchTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LMHTeamModel * model ;
    if (indexPath.section==0) {
        model =  _lever1_array[indexPath.row];
    }else{
        model =  _lever2_array[indexPath.row];
    }
    [cell.brandImageView setImageWithURL:[model.portrait changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
    [cell.brandImageView draCirlywithColor:nil andRadius:5.0f];
    cell.brandTitleLabel.text = (model.userName?model.userName:[ model.phone changePhone]);
    cell.brandTimeLabel.text = [NSString stringWithFormat:@"¥ %.2f",[model.businessBalance floatValue]];
    
    cell.brandTitleLabel.centerY = cell.centerY ;
    cell.brandTimeLabel.centerY = cell.centerY ;
    cell.brandTimeLabel.right = SCREEN_WIDTH-16;
    cell.brandTimeLabel.width = 150 ;
    cell.brandTimeLabel.textAlignment = NSTextAlignmentRight;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LMHTeamModel * model ;
    if (indexPath.section==0) {
        model =  _lever1_array[indexPath.row];
    }else{
        model =  _lever2_array[indexPath.row];
    }
    LMHTeamMemberDetailVC *vc = [[LMHTeamMemberDetailVC alloc] initWithNibName:@"LMHTeamMemberDetailVC" bundle:[NSBundle mainBundle]];
    vc.usrid = model.userId;
    vc.useName =  (model.userName?model.userName:[ model.phone changePhone]);;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = (scrollView.contentOffset.y+20) / 100;
    alpha = alpha > 1 ? 1 : alpha;
    self.customNavBar.barBackgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    self.customNavBar.titleLabelColor = [UIColor colorWithWhite:0 alpha:alpha];
    [self.customNavBar wr_setRightButtonWithTitle:@"规则" titleColor:[UIColor colorWithRed:1 green:1-(1-0x7D/255.0)*alpha blue:1-(1-0x1A/255.0)*alpha alpha:1]];

//    CGFloat ratio = 467.0/375;
//    CGFloat sectionHeaderHeight = SCREEN_WIDTH*ratio+88;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
    
}
-(void)dateChange:(UIButton*)sender{
    
    NSInteger   year = [self.dateDic[@"0"] integerValue];
    NSInteger   month = [self.dateDic[@"1"] integerValue];
    
    if (year==0) {
        year = 2019;
    }
    if (month==0) {
        month = 10;
    }
    
    if (sender.tag==10) {
        month--;
    }else{
        month++;
    }
    if (month<1) {
        year = year-1;
        month = 12;
    }
    if (month>12) {
        year = year+1;
        month = 1;
    }
    
    self.dateDic = @{@"0":[NSString stringWithFormat:@"%ld",(long)year] , @"1":[NSString stringWithFormat:@"%ld",(long)month] } ;
    self.dateString = [NSString stringWithFormat:@"%@/%@ ", _dateDic[@"0"], _dateDic[@"1"]];
    [sender setTitle:self.dateString forState:UIControlStateNormal];
    [self getRegisterCodes];

}

-(void)getRegisterCodes{
    
    NSString * url = [API_HOST stringByAppendingString:client_order_getTeamCenter];
    if (_dateDic==nil) {
        _dateDic = [NSDate dataCurrent];
    }
    NSInteger year = [_dateDic[@"0"]  integerValue];
    NSInteger month = [_dateDic[@"1"]  integerValue];
    NSInteger monthEnd = month+1;
    NSInteger yearEnd = year;

    if (monthEnd==13) {
        monthEnd = 1;
        year = year+1;
    }
    
    NSString * start = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
    NSString * end = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)yearEnd,(long)monthEnd];
    NSDictionary *dic = @{@"startTime":start ,@"endTime":end};
    WS(weakself);
    [HttpEngine requestPostWithURL:url params:dic isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        NSArray * array  = [[responseObject objectForKey:@"data"] objectForKey:@"Level1"];
        NSArray * array2  = [[responseObject objectForKey:@"data"] objectForKey:@"Level2"];

//        if ([array count]<1) {
//            return ;
//        }
        weakself.lever1_array = [LMHTeamModel mj_objectArrayWithKeyValuesArray:array];
        weakself.lever2_array = [LMHTeamModel mj_objectArrayWithKeyValuesArray:array2];
        [weakself.tv reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)getHelpCenter{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_Iamage_HOST stringByAppendingString:client_clause_getClause];
    NSDictionary*dict = @{@"clauseType":@(4)};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:dict isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [MBProgressHUD hideActivityIndicator];
        NSArray * array = [responseObject objectForKey:@"data"] ;
        if (array.count ) {
            WKBaseWebViewController *vc = [[WKBaseWebViewController alloc] init];
            vc.headTitle = @"邀请规则";
            vc.webStr = [[array objectAtIndex:0]objectForKey:@"content"];
            [weakself.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}
@end
