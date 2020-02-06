//
//  SAUserWalletVC.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/10.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "FRICurrencyVC.h"
#import "SAThreeTextCell.h"
#import "FRIRechargeCurrencyVC.h"
#import "SAWithdrawVC.h"
#import "SAUserWalletRequest.h"
#import "SAUserWalletModel.h"
//#import "LLBaseTableView.h"
#import "UIAlertController+Simple.h"
//#import "LLPersonalViewController.h"
//#import "LLPayPasswordViewController.h"
@interface FRICurrencyVC ()
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UITableView *rechargeTV;
@property (weak, nonatomic) IBOutlet UITableView *withdrawTV;
@property (nonatomic, strong) NSArray *tabBtnArr;
@property (nonatomic, strong) UIView *tabLineView;

@property (nonatomic, strong) SAUserWalletRequest *rechargeReq;
@property (nonatomic, strong) SAUserWalletRequest *withdrawReq;
@property (nonatomic, strong) SAUserWalletModel *rechargeModel;
@property (nonatomic, strong) SAUserWalletModel *withdrawModel;

@end

@implementation FRICurrencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.backgroundColor = [UIColor clearColor];
    self.customNavBar.barBackgroundColor = [UIColor clearColor];
    self.customNavBar.titleLabelColor = [UIColor whiteColor];
    self.customNavBar.title = @"";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back_white"]];
    
    [self.customNavBar wr_setRightButtonWithTitle:@"规则说明" titleColor:[UIColor whiteColor]];
    MJWeakSelf
    self.customNavBar.onClickRightButton = ^{

    };
    
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_top+200);
    gradientLayer.colors = @[(__bridge id)Main_Color.CGColor,(__bridge id)[UIColor colorWithHexValue:0x47B0D2].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    [self.topBgView.layer insertSublayer:gradientLayer atIndex:0];
    
    NSArray *titleArr = @[@"增加", @"消耗"];
    NSMutableArray *btnArr = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:Main_Color forState:UIControlStateSelected];
        [btn setTitleColor:Sub_title_Color forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        btn.tag = i;
        [self.tabView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
        }];
        [btnArr addObject:btn];
        [btn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    self.tabBtnArr = btnArr;
    [btnArr.firstObject setSelected:YES];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = Main_Color;
    lineView.layer.cornerRadius = 1.5;
    [self.tabView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.size.sizeOffset(CGSizeMake(20, 3));
        make.centerX.equalTo(self.tabBtnArr.firstObject);
    }];
    self.tabLineView = lineView;
    
    self.rechargeTV.rowHeight = 60;
    self.withdrawTV.rowHeight = 60;
    self.rechargeTV.tableFooterView = [UIView new];
    self.withdrawTV.tableFooterView = [UIView new];
    [self.rechargeTV registerNib:[UINib nibWithNibName:@"SAThreeTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [self.withdrawTV registerNib:[UINib nibWithNibName:@"SAThreeTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [self requestInit];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAsset) name:kNotificationRechargeSuccess object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAsset) name:kNotificationWithdrawSuccess object:nil];
}

- (void)requestInit {
    MJWeakSelf
    NSArray *reqArr = @[@"rechargeReq", @"withdrawReq"];
    NSArray *modelArr = @[@"rechargeModel", @"withdrawModel"];
    NSArray *tvArr = @[@"rechargeTV", @"withdrawTV"];
    
    for (int i = 0; i < reqArr.count; i++) {
        UITableView *tv = [self valueForKey:tvArr[i]];
        SAUserWalletRequest *req = [SAUserWalletRequest Request];
        req.type = @(i+1).stringValue;
        req.successBlock = ^(NSDictionary *dic) {
            [tv.mj_header endRefreshing];
            [tv.mj_footer endRefreshing];
            SAUserWalletModel *model = [SAUserWalletModel mj_objectWithKeyValues:dic[@"data"]];
            weakSelf.amountLbl.text = model.price;
//            if (model.page == 1 && model.list.count == 0){
//                [tv showEmptyViewWithType:1 imagename:MORENNODATA noticename:@"暂无数据"];
//            } else {
//                [tv removeEmptyView];
//            }
            if (model.page != 1) {
                SAUserWalletModel *walletModel = [weakSelf valueForKey:modelArr[i]];
                model.list = [walletModel.list arrayByAddingObjectsFromArray:model.list];
            }
            [weakSelf setValue:model forKey:modelArr[i]];
            if (model.page >= model.pagenum) {
                [tv.mj_footer endRefreshingWithNoMoreData];
            }
            [tv reloadData];
        };
        req.errorBlock = ^(NSString *errorMsg) {
            [tv.mj_header endRefreshing];
            [tv.mj_footer endRefreshing];
        };
        req.failureBlock = ^(NSError *error) {
            [tv.mj_header endRefreshing];
            [tv.mj_footer endRefreshing];
        };
        tv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            req.page = 1;
            req.requestNeedActive = YES;
            [tv.mj_footer resetNoMoreData];
        }];
        tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            SAUserWalletModel *walletModel = [weakSelf valueForKey:modelArr[i]];
            req.page = walletModel.page + 1;
            req.requestNeedActive = YES;
        }];
        
        [self setValue:req forKey:reqArr[i]];
    }
    [self updateAsset];
}

- (void)updateAsset {
    [self.rechargeTV.mj_header beginRefreshing];
}

#pragma mark Action
- (IBAction)rechargeAction:(UIButton *)sender {
    [self.navigationController pushViewController:[FRIRechargeCurrencyVC viewControllerWithXib] animated:YES];
}

- (IBAction)withdrawAction:(UIButton *)sender {
//    if (self.rechargeModel.price.integerValue <= 0){
//        [MBProgressHUD showError:@"余额不足"];
//        return;
//    }
//    if ([self skipCheck:SkipCheckUserWithdraw]) {
        SAWithdrawVC *vc = (SAWithdrawVC *)[SAWithdrawVC viewControllerWithXib];
        vc.totalAmount = self.rechargeModel.price;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (void)tabAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (UIButton *btn in self.tabBtnArr) {
        btn.selected = NO;
    }
    sender.selected = YES;
    switch (sender.tag) {
        case 1:
            if (!self.withdrawModel) {
                [self.withdrawTV.mj_header beginRefreshing];
            }
            break;
        default:
            break;
    }
    [self.sv setContentOffset:CGPointMake(SCREEN_WIDTH*sender.tag, 0) animated:YES];
    [self.tabLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.size.sizeOffset(CGSizeMake(20, 2));
        make.centerX.equalTo(sender);
    }];
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.tag == 0 ? self.rechargeModel.list.count : self.withdrawModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAThreeTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SAUserWalletModel *model = tableView.tag == 0 ? self.rechargeModel: self.withdrawModel;
//    [cell updateData:model.list[indexPath.row]];
    return cell;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
