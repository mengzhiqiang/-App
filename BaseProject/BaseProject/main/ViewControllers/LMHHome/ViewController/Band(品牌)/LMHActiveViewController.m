//
//  LMHActiveViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 8/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHActiveViewController.h"
#import "LMHActiveTableViewCell.h"
#import "LMHBandGoodsTableViewCell.h"
#import "LMHBandGoodModel.h"
#import "LMHBandModel.h"
#import "LMHGoodDetailModel.h"
#import "LMHCellSizeTools.h"
#import "LMHGoodsDetailVC.h"

@interface LMHActiveViewController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic, strong) UITableView * rootTableView ;

@property(nonatomic, assign) NSInteger  page ;

@property(nonatomic, copy) NSMutableArray *  bandArray ;
@property(nonatomic, strong) LMHBandModel *  bandModel ;

@end

@implementation LMHActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.customNavBar.title = @"活动详情";
    [self.view addSubview:self.rootTableView];
    [self getActiveDetail];
    
    WS(weakself);
    self.rootTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 1;
        [weakself getActiveDetail];
        [weakself.rootTableView.mj_footer resetNoMoreData];

    }];
    
    [self.rootTableView.mj_footer endRefreshingWithNoMoreData];
//    self.rootTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        weakself.page++;
//        [weakself getActiveDetail];
//    }];
}

-(UITableView*)rootTableView{
    
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top) style:UITableViewStyleGrouped];
        _rootTableView.delegate=self;
        _rootTableView.dataSource=self;
        _rootTableView.separatorStyle=UITableViewCellAccessoryNone;
        _rootTableView.backgroundColor = [UIColor HexString:@"f5f5f5"];
        _rootTableView.sectionFooterHeight = 0.1;
        _rootTableView.sectionHeaderHeight = 0.1;
        
    }
    return _rootTableView;
}
-(NSMutableArray * )bandArray{
    if (!_bandArray) {
        _bandArray = [NSMutableArray arrayWithCapacity:200];
    }
    return  _bandArray ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }
    return 10.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }
    return  _bandArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return [LMHCellSizeTools cellHight:(_bandModel.desc?_bandModel.desc:@"详情")]+(9.0/16.0)*SCREEN_WIDTH+15;
    }
    LMHGoodDetailModel * model = _bandArray[indexPath.row];
    CGFloat height = [LMHCellSizeTools cellHeightOfModel:model]+5;
    return 211+height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"LMHActiveTableViewCell";
        LMHActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LMHActiveTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell loadUIWithData:_bandModel];
        return cell ;
    }else{
        static NSString *CellIdentifier = @"LMHBandGoodsTableViewCell";
        LMHBandGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LMHBandGoodsTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        LMHGoodDetailModel * model = _bandArray[indexPath.row];
        cell.goodModel = model;
        [cell.headerImageView setImageWithURL:[model.brandLogo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        cell.titleNameLabel.text = model.brand_name ;
        cell.bandModel = _bandModel;
        return cell ;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section!=0) {
          LMHGoodDetailModel * model = _bandArray[indexPath.row];
          LMHGoodsDetailVC * detailVC = [[LMHGoodsDetailVC alloc]init];
          detailVC.goodID = model.goodsId;
          [self.navigationController pushViewController:detailVC animated:YES];
      }
}

-(void)getActiveDetail{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_bands_getActivityDetails];
    NSDictionary* diction ;
    if ([CommonVariable  getUserInfo]) {
        diction = @{@"activityId":_activeID };
    }else{
        return ;
    }
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        [self.rootTableView.mj_header endRefreshing];
        [self.rootTableView.mj_footer endRefreshing];

        if (weakself.page==1) {
            if ([responseObject objectForKey:@"data"] ) {
                weakself.bandModel = [LMHBandModel mj_objectWithKeyValues: [responseObject objectForKey:@"data"]] ;
            }
        }
        [self addNewData:[[responseObject objectForKey:@"data"] objectForKey:@"goodsList"]];
        
        
    } failure:^(NSError *error) {
        [self.rootTableView.mj_header endRefreshing];
        [self.rootTableView.mj_footer endRefreshing];

        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        if ([userInfo[@"code"] integerValue] == 400) {
                 [AFAlertViewHelper alertViewWithTitle:@"" message:@"该活动暂未开始，敬请期待！" delegate:self cancelTitle:@"确定" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
                     [self.navigationController popViewControllerAnimated:YES];
                 } ];
        }else{
                 [MBProgressHUD showError:userInfo[@"msg"]];
        }
    }];
    
}

-(void)addNewData:(NSArray*)array{
    
    if (array.count<10) {
        [self.rootTableView.mj_footer noticeNoMoreData];
    }
    if (_page==1) {
        if (_bandArray.count>0) {
            [_bandArray removeAllObjects];
        }
        _bandArray = [LMHGoodDetailModel mj_objectArrayWithKeyValuesArray:array];
    }else{
        [_bandArray addObjectsFromArray:[LMHGoodDetailModel mj_objectArrayWithKeyValuesArray:array]];
    }
    [_rootTableView reloadData];
}

@end
