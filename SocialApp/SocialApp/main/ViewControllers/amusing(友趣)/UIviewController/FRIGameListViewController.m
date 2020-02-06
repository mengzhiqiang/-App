//
//  FRIGameListViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 20/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIGameListViewController.h"

#import "FRIstoreInfoViewController.h"
#import "LrdOutputView.h"
#import "TwoOutputView.h"
#import "ThreeOutputView.h"
#import "FRIgoodsTableViewCell.h"
#import "MatchHead.h"
#import "TrainCell.h"
#import "FRIActiveListModel.h"
#import "FRIActiveDetailViewController.h"

@interface FRIGameListViewController ()
<LrdOutputViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
MatchSectionHeaderViewDelegate,
TwoOutputViewDelegate,
ThreeOutputViewDelegate>

@property(nonatomic, strong)LrdOutputView * outputView ;
@property(nonatomic, strong)TwoOutputView * twoOutputView ;
@property(nonatomic, strong)ThreeOutputView * threeputView ;

@property (nonatomic, assign) NSInteger aomunt;
@property (assign , nonatomic)NSInteger  page; //当前页数

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) MatchSectionHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray * activeArray;


@property (nonatomic,strong) NSString *requireSex;       // 性别 1:同性，2:不限
@property (nonatomic,strong) NSString *requireMarriage;  //婚恋状况 0:不限，1:单身，2:非单身
@property (nonatomic,strong) NSString *requireEducation; //学历要求 0:不限，1:大学专科以下，2:大学专科，3:大学本科，4:研究生硕士，5:研究生博士
@property (nonatomic,strong) NSString *requireAge;       // 年龄层次
@property (nonatomic,strong) NSString *activitySponsor;       // 组团类型 1:用户 2:商家
@property (nonatomic,strong) NSString *activityType;       // 活动类型



@end

@implementation FRIGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _requireSex = @"0";
    _requireMarriage = @"0";
    _requireEducation = @"0";
    _requireAge = @"0";
    _activityType = @"0";
    _activitySponsor = @"0";
    
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self.tableView.mj_header  beginRefreshing];
}
- (void) setupSubviews {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    
    WS(weakself);
       self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           weakself.page = 1;
           [self  loadNewData];

           [weakself.tableView.mj_footer resetNoMoreData];
           [weakself.tableView.mj_header endRefreshing];
       }];
       
       self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
           weakself.page++;
           [self  loadNewData];
       }];
    
}

- (void) setupSubviewsLayout {
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.equalTo(@44);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
//        make.left.right.offset(0);
//        make.bottom.offset(-k_Height_TabBar);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark 头部筛选

- (void)recommendSelect {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSArray *title = @[@"活动类型",@"参与类型",@"组团类型"];
    for (int i = 0; i <3; i++) {
        LrdCellModel  *model = [[LrdCellModel alloc]init];
        model.isSelect = !i;
        model.title = title[i];
        [arr addObject:model];
        
    }
    self.outputView = [[LrdOutputView alloc] initWithDataArray:arr origin:CGPointMake(0,44+DCTopNavH) width:SCREEN_WIDTH  height:44 direction:kLrdOutputViewDirectionLeft];
    self.outputView.selectIndex = self.aomunt;
    self.outputView.tableViewHeight = 88;
    self.outputView.delegate = self;
    WS(weakself);
    self.outputView.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        weakself.outputView = nil;
    };
    self.outputView.tableViewHeight = 220;
    [self.outputView pop];
}
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath {

//    if (indexPath.row == 0) {
//        self.aomunt = 1;
//    }else if (indexPath.row == 1) {
//        self.aomunt = 0;
//    }
    self.aomunt = indexPath.row;


}

#pragma mark 参与筛选
- (void) twoSelect{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *titles = [NSMutableArray array];
    [titles addObject:@"不限"];
    [titles addObject:@"男"];
    [titles addObject:@"女"];
    [titles addObject:@"其他"];

    for (int i = 0; i <titles.count; i++) {
        TwoLrdCellModel  *model = [[TwoLrdCellModel alloc]init];
        model.isSelect = YES;
        model.title = titles[i];
        [arr addObject:model];
    }
    
    self.twoOutputView = [[TwoOutputView alloc] initWithDataArray:arr origin:CGPointMake(0, 44+DCTopNavH) width:SCREEN_WIDTH height:44 direction:kLrdOutputViewDirectionLeft];
    self.twoOutputView.tableViewHeight = 88;
    self.twoOutputView.delegate = self;
    WS(weakself);
    self.twoOutputView.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        weakself.twoOutputView = nil;
    };
    [self.twoOutputView pop];
    
}

#pragma mark - cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TrainCell";
    TrainCell   *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TrainCell" owner:self options:nil] objectAtIndex:0];

    }
    if (self.activeArray.count>indexPath.row) {
        cell.model = self.activeArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor HexString:@"F4F6F9"];

    return cell;
}

#pragma mark - cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    [self.navigationController pushViewController:[FRIstoreInfoViewController new] animated:YES];
    FRIActiveDetailViewController * vc = [FRIActiveDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.activeArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark 选择筛选
- (void)selectTypeWithIndex:(NSInteger)index {
    
    if (index == 0) {
        [self twoSelect];
    }else if(index == 1) {
        [self recommendSelect];
    }else {
        [self recommendSelect];
    }
}

#pragma mark 懒加载
- (MatchSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MatchSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"TrainCell" bundle:nil] forCellReuseIdentifier:@"TrainCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"FRIgoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FRIgoodsTableViewCell"];
        _tableView.backgroundColor = [UIColor HexString:@"F4F6F9"];
    }
    return _tableView;
}

-(void)loadNewData{
    
    
    NSString * api = [API_HOST stringByAppendingString:youFun_SQActivity];
    NSDictionary*diciton = @{@"requireSex":_requireSex ,
                             @"requireMarriage":_requireMarriage,
                             @"requireEducation":_requireEducation,
                             @"requireAge":_requireAge,
                             @"activityType":_activityType,
                             @"activitySponsor":_activitySponsor,
                             @"city":(_cityName?_cityName:@"广州市"),
                             @"limit":@(20),
                             @"page":@(_page)};
    WS(weakself);
    [HttpEngine requestGetWithURL:api params:diciton isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.tableView.mj_header endRefreshing];

        NSArray * array = responseObject[@"data"];
        if (weakself.page==1) {
            weakself.activeArray = [FRIActiveListModel mj_objectArrayWithKeyValuesArray:array];
        }else{
            [weakself.activeArray addObjectsFromArray:[FRIActiveListModel mj_objectArrayWithKeyValuesArray:array]];
        }
        if (array.count<20) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakself.tableView reloadData];
        
    } failure:^(NSError *error) {
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.tableView.mj_header endRefreshing];
        
    }];
}

@end
