//
//  LMHAccountDetailVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAccountDetailVC.h"
#import "UIAlertController+Simple.h"
#import "FWRPickerView.h"
#import "LMHAccountDetailCell.h"
#import "MJRefresh.h"
#import "LMHRunningWaterModel.h"
@interface LMHAccountDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) FWRPickerView *pickerView;
@property (strong, nonatomic) NSDictionary * dateDic;

@property (strong, nonatomic) NSMutableArray <LMHRunningWaterModel *> * array;

@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger type;

@end

@implementation LMHAccountDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"余额明细";
    [self.customNavBar wr_setRightButtonWithTitle:@"筛选" titleColor:Main_Color];
    _page = 1;
    _type = 0;
    WS(weakself);
    self.customNavBar.onClickRightButton = ^{
        UIAlertController *sheet = [UIAlertController showSheetTitles:@[@"所有类型", @"一级团队奖金",@"二级团队奖金",@"购买商品",@"销售返利"] titleColor:Main_Color cancelColor:Sub_title_Color backIndex:^(UIAlertAction * _Nonnull UIAlertAction, NSInteger index) {
          
            switch (index) {
                case 0:
                    weakself.type = index ;
                    break;
                case 1:
                    weakself.type = 5 ;
                    break;
                case 2:
                    weakself.type = 6 ;
                    break;
                case 3:
                    weakself.type = 7 ;
                    break;
                case 4:
                    weakself.type = 4 ;
                    break;
                default:
                    break;
            }
            weakself.page = 1;
            [weakself getTouchBalance];

        }];
        [weakself presentViewController:sheet animated:YES completion:nil];
    };
    self.tv.tableFooterView = [UIView new];
    self.tv.rowHeight = 60;
    [self.tv registerNib:[UINib nibWithNibName:@"LMHAccountDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    self.tv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getTouchBalance];
        [weakself.tv.mj_footer resetNoMoreData];
    }];
    
    self.tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self getTouchBalance];
    }];
    
    [self getTouchBalance];

}

- (FWRPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[FWRPickerView alloc] init];
        [_pickerView setupPickerStyle:pickerDataTypeAccount];
        [self.view addSubview:self.pickerView];
        WS(weakself);
        _pickerView.backPickerInfo = ^(NSDictionary * _Nonnull diction) {
//            [weakself.dateBtn setTitle:[NSString stringWithFormat:@"%@-%@", diction[@"0"], diction[@"1"]] forState:UIControlStateNormal];
            weakself.dateDic = diction;
            weakself.dateBtn.titleLabel.text = [NSString stringWithFormat:@"%@-%@ ▾", diction[@"0"], diction[@"1"]];
            weakself.page = 1;
            [weakself getTouchBalance];
        };
    }
    return _pickerView;
}

- (IBAction)dateSelectAction:(UIButton *)sender {
    [self.pickerView showPickerView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMHAccountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (_array.count > indexPath.row) {
        LMHRunningWaterModel * model = _array[indexPath.row];
        cell.titleLbl.text = [self stringStyle:model.type];
        cell.subtitleLbl.text = [self stringContentModel:model];
        cell.amountLbl.text =[NSString stringWithFormat:@"%@%.2f", [self stringPriceStyle:model.type], model.payPrice.floatValue];
        cell.dateLbl.text = [model.creatTime substringWithRange:NSMakeRange(5, 11)];
        
        
    }
    return cell;
}

-(NSString*)stringPriceStyle:(NSString*)type{
    
    if (type.intValue ==1 || type.intValue ==7) {
        return @"-" ;
    }
    return @"+" ;
}
-(NSString*)stringContentModel:(LMHRunningWaterModel*)model{
    
    switch (model.type.integerValue) {
        case 1:case 2:case 3:case 7:
            {
                return [NSString stringWithFormat:@"订单号：%@",model.outTradeNo];
            }
            break;
        case 4:case 5:case 6:
        {
            return @"销售返利";
        }
            break;
        default:
            break;
    }
    
    return @"";
}


-(NSString*)stringStyle:(NSString*)type
{
    switch (type.intValue) {
        case 1:
            return @"购买商品";
            break;
        case 2:
            return @"取消订单";
            break;
        case 3:
            return @"退货退款";
            break;
        case 4:
            return @"营销返利";
            break;
        case 5:
            return @"团队直接奖金";
            break;
        case 6:
            return @"团队间接奖金";
            break;
        case 7:
            return @"购买商品（余额支付）";  ///余额支付
            break;
            
        default:
            break;
    }
    return @"商品支付";
}

-(void)getTouchBalance{
    
    NSString * url = [API_HOST stringByAppendingString:client_order_getTouchBalance];
    
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
    NSMutableDictionary  *diction = [NSMutableDictionary dictionaryWithCapacity:20];
    [diction setObject:end forKey:@"endTime"];
    [diction setObject:start forKey:@"startTime"];
    [diction setObject:@(50) forKey:@"limit"];
    [diction setObject:@(_page) forKey:@"page"];
    [diction setObject:@(_type) forKey:@"type"];

    WS(weakself);
    [HttpEngine requestPostWithURL:url params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [self.tv.mj_header endRefreshing];
        [self.tv.mj_footer endRefreshing];

        if ([[responseObject objectForKey:@"data"] count]<10) {
            [self.tv.mj_footer endRefreshingWithNoMoreData];
        }
        if (weakself.page==1) {
            weakself.array = [NSMutableArray arrayWithCapacity:200];
            weakself.array = [LMHRunningWaterModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
        }else{
            [weakself.array addObjectsFromArray:[LMHRunningWaterModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]]];
        }
        
        [weakself.tv reloadData];
    } failure:^(NSError *error) {
        [self.tv.mj_header endRefreshing];
        [self.tv.mj_footer endRefreshing];
        
    }];
    
}
@end
