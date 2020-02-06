//
//  FRIActiveLIistViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 2/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "FRIActiveLIistViewController.h"
#import "FRIgoodsTableViewCell.h"
#import "FRIGoodModel.h"


@interface FRIActiveLIistViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (assign , nonatomic)NSInteger  page; //当前页数

@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic ,strong)NSMutableArray<FRIGoodModel*>* goodModelList;

@end

@implementation FRIActiveLIistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        [self setupSubviews];
    self.customNavBar.title = @"选择活动";
    [self loadGoodsData];
}
- (void) setupSubviews {

    [self.view addSubview:self.tableView];
        
        WS(weakself);
           self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//               weakself.page = 1;
//               [self  loadNewData];

               [weakself.tableView.mj_footer resetNoMoreData];
               [weakself.tableView.mj_header endRefreshing];
           }];
           
           self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//               weakself.page++;
//               [self  loadNewData];
           }];
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top);
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"FRIgoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FRIgoodsTableViewCell"];
        
        _tableView.backgroundColor = [UIColor HexString:@"ffffff"];
    }
    return _tableView;
}

#pragma mark - cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FRIgoodsTableViewCell";
    FRIgoodsTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FRIgoodsTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    if (_goodModelList.count>indexPath.row) {
        cell.model = _goodModelList[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FRIGoodModel * model = _goodModelList[indexPath.row];
    if (_backActiveModel) {
        _backActiveModel(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController pushViewController:[FRIstoreInfoViewController new] animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark 获取商品列表
-(void)loadGoodsData{
    NSString * api = [API_HOST stringByAppendingString:youFun_commodity];
    NSDictionary*diciton = @{@"merchantId": _storeID , @"page":@"1" ,@"limit":@"100"};
    WS(weakself);
    [HttpEngine requestGetWithURL:api params:diciton isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {

        NSArray * array = responseObject[@"data"] ;
        weakself.goodModelList = [FRIGoodModel mj_objectArrayWithKeyValuesArray:array];

        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
//        [weakself.collectionView.mj_footer endRefreshing];
//        [weakself.collectionView.mj_header endRefreshing];
        
    }];
}

@end
