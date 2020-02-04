//
//  LMHTeamMemberDetailVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHTeamMemberDetailVC.h"
#import "LMHTeamMemberDetailCell.h"
#import "FWRPickerView.h"
#import "MJRefresh.h"
#import "LMHTeamModel.h"
@interface LMHTeamMemberDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLbl;
@property (strong, nonatomic) NSDictionary * dateDic;

@property (strong, nonatomic) FWRPickerView *pickerView;

@property (strong, nonatomic) NSArray <LMHTeamModel*> * array;

@end

@implementation LMHTeamMemberDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = _useName;
//    [self.customNavBar wr_setRightButtonWithTitle:@"筛选" titleColor:Main_Color];

    self.tv.tableFooterView = [UIView new];
    self.tv.rowHeight = 44;
    [self.tv registerNib:[UINib nibWithNibName:@"LMHTeamMemberDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    WS(weakself);
    self.tv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself.tv.mj_footer resetNoMoreData];
    }];
    
    self.tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself.tv.mj_footer endRefreshingWithNoMoreData];
    }];
    
    [self getSingleTeamPerson];
}

- (FWRPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[FWRPickerView alloc] init];
        [_pickerView setupPickerStyle:pickerDataTypeAccount];
        [self.view addSubview:self.pickerView];
        WS(weakself);
        _pickerView.backPickerInfo = ^(NSDictionary * _Nonnull diction) {
            weakself.dateDic = diction;
            [weakself.dateBtn setTitle:[NSString stringWithFormat:@"%@/%@ ▾", diction[@"0"], diction[@"1"]] forState:UIControlStateNormal];
            [weakself getSingleTeamPerson];
        };
    }
    return _pickerView;
}

- (IBAction)dateSelectAction:(UIButton *)sender {
    [self.pickerView showPickerView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMHTeamMemberDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row==0) {
        cell.dateLbl.text = @"日期";
        cell.amountLbl.text = @"销售额";
    }else{
        LMHTeamModel * model = _array[indexPath.row-1];
        cell.dateLbl.text   = model.Day;
        cell.amountLbl.text =  [NSString stringWithFormat:@"¥ %.2f",model.totalPrice.floatValue] ;
    }
    
    return cell;
}

-(void)getSingleTeamPerson{
    
    NSString * url = [API_HOST stringByAppendingString:client_order_getTurnoverByUserId];
    
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
    
    NSString * start = [NSString stringWithFormat:@"%ld-%ld-01 00:00:00",(long)year,(long)month];
    NSString * end = [NSString stringWithFormat:@"%ld-%ld-01 00:00:00",(long)yearEnd,(long)monthEnd];

    NSDictionary *dic = @{@"startTime":start ,@"endTime":end , @"userId":_usrid};
    WS(weakself);
    [HttpEngine requestPostWithURL:url params:dic isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        NSArray * array  = [responseObject objectForKey:@"data"] ;
  
        weakself.array = [LMHTeamModel mj_objectArrayWithKeyValuesArray:array];
        [_tv reloadData];
        [self sumAllorder];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)sumAllorder
{
    float sum = 0;
    for (LMHTeamModel*model in _array) {
        sum = sum+ model.totalPrice.floatValue;
    }
    _totalAmountLbl.text =  [NSString stringWithFormat:@"¥ %.2f",sum] ;
}

@end
