//
//  LMHAfterSaleRecordTV.m
//  BaseProject
//
//  Created by wfg on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAfterSaleRecordTV.h"
#import "LMHAfterSaleRecordCell.h"
#import "MJRefresh.h"
#import "LMHAfterSaleApplyVC.h"
#import "LMHAfterSaleDetailVC.h"
#import "UIViewController+Extension.h"
@interface LMHAfterSaleRecordTV ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) LMHEmptyNoticeView *noticeView;


@end
@implementation LMHAfterSaleRecordTV

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 221;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerNib:[UINib nibWithNibName:@"LMHAfterSaleRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LMHAfterSaleRecordCell"];
        WS(weakself);
        _page = 1;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakself.mj_footer resetNoMoreData];
//            self.noticeView.hidden = NO;
            weakself.page = 1;
            [weakself loadNewData];
            [weakself.mj_footer resetNoMoreData];

        }];
        
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakself.page ++;
            [weakself loadNewData];
//            [weakself.mj_footer endRefreshingWithNoMoreData];
//            self.noticeView.hidden = YES;
        }];
    }
    return self;
}
-(void) loadNewData{
    if (_relaodDataWithIndex) {
        _relaodDataWithIndex(_page);
    }
}
- (LMHEmptyNoticeView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[LMHEmptyNoticeView alloc] init];
        [self addSubview:_noticeView];
        [_noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _noticeView;
}

-(void)setOrderArray:(NSMutableArray<LMHOrderListModel *> *)orderArray{
    _orderArray = orderArray;
    [self reloadData];
}
-(void)setIsRequest:(BOOL)IsRequest{
    _IsRequest = IsRequest;
    [self reloadData];
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_orderArray.count<1 ) {
        self.noticeView.hidden = NO;
    }else{
        self.noticeView.hidden = YES;
    }
    return _orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMHAfterSaleRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMHAfterSaleRecordCell"];
    if (_orderArray.count>indexPath.row) {
        LMHOrderListModel * model = _orderArray[indexPath.row];
        cell.titleLbl.text = model.brand.brandName;
        [cell.titleIV setImageWithURL:[model.brand.brandLogo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        [cell.contentIV setImageWithURL:[(model.brand.goodLogo?model.brand.goodLogo:model.brand.url) changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        cell.contentLbl.text = model.brand.goodName;
        
        cell.subContentLbl.text = [NSString stringWithFormat:@"%@ x %@",model.brand.specificationName , model.brand.num];
        cell.subContentLbl.hidden = YES ;
        if (model.schedule) {
            NSArray *array = @[@"处理中",@"同意",@"不同意",@"退货中",@"退款中",@"已完成"];
            cell.stateLbl.text = array[model.schedule.integerValue-1];
            cell.afterButton.hidden = YES;

        }else{
            cell.stateLbl.text =  @"";
            cell.afterButton.hidden = NO;
        }
        cell.backQuestAfter = ^{
            LMHAfterSaleApplyVC *vc = [[LMHAfterSaleApplyVC alloc] initWithNibName:@"LMHAfterSaleApplyVC" bundle:[NSBundle mainBundle]];
            vc.model = model ;
            [[UIViewController getCurrentController].navigationController pushViewController:vc animated:YES];
            
        };
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (_IsRequest) {
        if (_orderArray.count>indexPath.row) {
            LMHOrderListModel * model = _orderArray[indexPath.row];
            LMHAfterSaleDetailVC *vc = [[LMHAfterSaleDetailVC alloc] initWithNibName:@"LMHAfterSaleDetailVC" bundle:[NSBundle mainBundle]];
            vc.state =  AfterSaleStateSuccess;
            vc.orderID = model.orderId;
            [[UIViewController getCurrentController].navigationController pushViewController:vc animated:YES];
        }
       
    }else{
        if (_orderArray.count>indexPath.row) {
            LMHOrderListModel * model = _orderArray[indexPath.row];
            LMHAfterSaleApplyVC *vc = [[LMHAfterSaleApplyVC alloc] initWithNibName:@"LMHAfterSaleApplyVC" bundle:[NSBundle mainBundle]];
            vc.model = model ;
            [[UIViewController getCurrentController].navigationController pushViewController:vc animated:YES];
        }

    }
    
}

@end

@implementation LMHEmptyNoticeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"grzx_icon_sh_zwsqjl"];
        [self addSubview:iv];
        [iv setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.top.centerY.equalTo(self).offset(-100);
            make.left.right.greaterThanOrEqualTo(self).offset(0).priorityMedium();
        }];
        
        UILabel *lbl = [UILabel new];
        lbl.text = @"暂无申请记录";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor = Sub_title_Color;
        [self addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iv.mas_bottom).offset(12);
            make.bottom.centerX.equalTo(self);
            make.left.right.greaterThanOrEqualTo(self).offset(0).priorityMedium();
        }];
    }
    return self;
}

@end
