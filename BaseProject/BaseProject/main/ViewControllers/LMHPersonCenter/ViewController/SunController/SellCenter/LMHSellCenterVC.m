//
//  LMHSellCenterVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHSellCenterVC.h"
#import "FWRPickerView.h"
#import "MJRefresh.h"
#import "LMHSellCenterCell.h"
#import "LMHsellCenterModel.h"

@interface LMHSellCenterVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) FWRPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UILabel *totalCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLbl;

@property (strong, nonatomic) NSDictionary * dateDic;

@property (strong, nonatomic) NSArray <LMHsellCenterModel *>* array;

@end

@implementation LMHSellCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"业绩中心";
    WS(weakself);
    self.tv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself.tv.mj_footer resetNoMoreData];
    }];
    
    self.tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself.tv.mj_footer endRefreshingWithNoMoreData];
    }];
    [self.tv registerNib:[UINib nibWithNibName:@"LMHSellCenterCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

    [self getPerformance];
}

- (FWRPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[FWRPickerView alloc] init];
        [_pickerView setupPickerStyle:pickerDataTypeAccount];
        [self.view addSubview:self.pickerView];
        WS(weakself);
        _pickerView.backPickerInfo = ^(NSDictionary * _Nonnull diction) {
            [weakself.dateBtn setTitle:[NSString stringWithFormat:@"%@-%@ ▾", diction[@"0"], diction[@"1"]] forState:UIControlStateNormal];
            weakself.dateDic = diction;
            [weakself getPerformance];
//            weakself.dateBtn.titleLabel.text = [NSString stringWithFormat:@"%@-%@", diction[@"0"], diction[@"1"]];
        };
    }
    return _pickerView;
}

- (IBAction)dateSelectAction:(UIButton *)sender {
    [self.pickerView showPickerView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return   self.array.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMHSellCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.dateLbl.text = @"日期";
        cell.countLbl.text = @"订单数";
        cell.amountLbl.text = @"销售额";
        cell.countLbl.textColor = Main_title_Color;
        cell.amountLbl.textColor = Main_title_Color;
    } else {
        LMHsellCenterModel * model =  _array[indexPath.row-1];
        cell.dateLbl.text = model.finalTime;
        cell.countLbl.text = model.orderNum;
        cell.amountLbl.text = [NSString stringWithFormat:@"¥ %.2f",model.price.floatValue];
        cell.countLbl.textColor = Main_Color;
        cell.amountLbl.textColor = Main_Color;
    }
    return cell;
}

-(void)getPerformance{
    
    NSString * url = [API_HOST stringByAppendingString:client_order_getPerformance];
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
    
   UserInfo * info = [CommonVariable getUserInfo] ;
    NSString * start = [NSString stringWithFormat:@"%ld-%02ld-01",(long)year,(long)month];
    NSString * end = [NSString stringWithFormat:@"%ld-%02ld-01",(long)yearEnd,(long)monthEnd];
    NSDictionary *dic = @{@"monthStart":start ,@"monthEnd":end , @"userId":info.userId};
    WS(weakself);
    [HttpEngine requestGetWithURL:url params:dic isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
//        if ([[responseObject objectForKey:@"data"]count]<1) {
//            return ;
//        }
        weakself.array = [LMHsellCenterModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
        [weakself.tv reloadData];
        [self loadNewData];
    } failure:^(NSError *error) {
        
        
    }];
}

-(void)loadNewData
{
    float sum = 0;
    for (LMHsellCenterModel *model in _array) {
        sum = sum+ model.price.floatValue;
    }
    LMHsellCenterModel* modle = self.array.firstObject;
    self.totalCountLbl.text = [NSString stringWithFormat:@"%ld单",(long)modle.orderNumCount.integerValue];
   self.totalAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f",sum];

}

@end
