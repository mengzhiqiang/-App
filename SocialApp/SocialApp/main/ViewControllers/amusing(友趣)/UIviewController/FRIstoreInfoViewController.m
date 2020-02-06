//
//  FRIstoreInfoViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 31/12/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIstoreInfoViewController.h"
#import "FRIStoreFeedViewController.h"
#import "FRIActiveDetailViewController.h"

#import "SDCycleScrollView.h"
#import "FRIgoodsTableViewCell.h"
#import "FRIstoreInfoTableViewCell.h"
#import "FRIstoreCommentsTableViewCell.h"
#import "HMSegmentedControl.h"
#import "TrainCell.h"

#import "FRImerchantModel.h"
#import "BSMapLocationVC.h"

#import "FRIGoodModel.h"
#import "FRIActiveListModel.h"
#import "FRIScoreModel.h"

@interface FRIstoreInfoViewController ()<
UITableViewDataSource,
UITableViewDelegate,
SDCycleScrollViewDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic ,strong)HMSegmentedControl  * segmentedControl;

@property(nonatomic ,assign)NSInteger  selcetIndex;

@property(nonatomic ,strong)FRImerchantModel   * model;
@property(nonatomic ,strong)NSMutableArray<FRIGoodModel*>* goodModelList;
@property(nonatomic ,strong)NSMutableArray<FRIActiveListModel*>* activeModelList;
@property(nonatomic ,strong)NSMutableArray<FRIScoreModel*>* ScoreModelList;

@end

@implementation FRIstoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"店铺详情";
    [self createTableView];
    
    WS(weakself);
    [self.customNavBar wr_setRightButtonWithTitle:@"反馈" titleColor:Main_title_Color];
    self.customNavBar.onClickRightButton = ^{
        FRIStoreFeedViewController * feedVC = [FRIStoreFeedViewController new];
        feedVC.storeID  = weakself.storeID;
        [weakself.navigationController pushViewController:feedVC animated:YES];
    };
    [self loadNewData];
    [self loadGoodsData];
    [self loadGoodsActivingData];
    [self loadEvaluateData ];
}

-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, SCREEN_WIDTH * 9/16-30) delegate:self placeholderImage:nil];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.autoScrollTimeInterval = 4.0;
        [_cycleScrollView draCirlywithColor:nil andRadius:8.0f];
    }
    return _cycleScrollView;
}
#pragma -mark - 创建表
-(void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT -SCREEN_top) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"FRIgoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FRIgoodsTableViewCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"FRIstoreInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"FRIstoreInfoTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"FRIstoreCommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FRIstoreCommentsTableViewCell"];
    
//    [_tableView registerClass:[TeacherCell class] forCellReuseIdentifier:@"twocell"];

    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = YES;
    [self.view addSubview:_tableView];
    
//    self.headerView = [[[NSBundle mainBundle]loadNibNamed:@"StoreMainHead" owner:self options:nil]lastObject];
//    self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 204);
//    _tableView.tableHeaderView = self.headerView;
    
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (section==0) {
        return 1;
    }
    if (section==1) {
        if (_selcetIndex==1) {
            return self.activeModelList.count;
        }
        return self.goodModelList.count;
    }
    return 3;
}

#pragma mark - cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
         static NSString *CellIdentifier = @"FRIstoreInfoTableViewCell";
           FRIstoreInfoTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
               if (cell == nil) {
                   cell = [[[NSBundle mainBundle] loadNibNamed:@"FRIstoreInfoTableViewCell" owner:self options:nil] objectAtIndex:0];
                   cell.selectionStyle = UITableViewCellSelectionStyleNone;
               }
        cell.model = self.model;
        cell.backlocation = ^
        {
            BSMapLocationVC *vc = [BSMapLocationVC new];
               vc.coordinate = CLLocationCoordinate2DMake(self.model.latitude, self.model.longitude);
               [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    if (indexPath.section==1) {
        if (_selcetIndex==0) {
            static NSString *CellIdentifier = @"FRIgoodsTableViewCellID";
            FRIgoodsTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"FRIgoodsTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            if (self.goodModelList.count>indexPath.row) {
                cell.model = self.goodModelList[indexPath.row];
            }
                return cell;
        }else{
            static NSString *CellIdentifier = @"TrainCell";
                     TrainCell   *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                         if (cell == nil) {
                             cell = [[[NSBundle mainBundle] loadNibNamed:@"TrainCell" owner:self options:nil] objectAtIndex:0];
                             cell.selectionStyle = UITableViewCellSelectionStyleNone;
                         }
            cell.backgroundColor = White_Color;
            cell.addressIconImageView.hidden = YES;
            if (self.activeModelList.count>indexPath.row) {
                cell.model = self.activeModelList[indexPath.row];
              
                cell.addressLabel.text = [NSString stringWithFormat:@"人均：¥%.2f",cell.model.activityAve.floatValue];
            }
            
            cell.addressLabel.textColor = [UIColor redColor];
            [cell.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.showImage.mas_right).offset(15);
                make.bottom.equalTo(cell.contentView).offset(-15);
            }];
//            make.bottom.equalTo(self.view.mas_bottom).offset(-keyBoardHeight);

            return cell;
        }
       }
    
    if (indexPath.section==2) {
              static NSString *CellIdentifier = @"FRIstoreCommentsTableViewCell";
                FRIstoreCommentsTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"FRIstoreCommentsTableViewCell" owner:self options:nil] objectAtIndex:0];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    }
        if (self.ScoreModelList.count>indexPath.row) {
                cell.model = self.ScoreModelList[indexPath.row];
            }
        return cell;
        
         }
   
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 260;
    }else if (indexPath.section==1){
        return 135;
    }
    return 64 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return SCREEN_WIDTH * 9/16;
    }
    else  if (section==2) {
           return 54;
    }
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    if (section==1) {
        return 40;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section==0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9/16)];
        [view addSubview:self.cycleScrollView];
        _cycleScrollView.imageURLStringsGroup= @[@"LaunchImage",@"LaunchImage"];
        return view;
    }else if (section==2){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
        view.backgroundColor = Main_BG_Color;

        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
        bgView.backgroundColor = White_Color;
        [view addSubview:bgView];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 120, 20)];
        label.text = @"用户评论";
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = Main_title_Color;
        [bgView addSubview:label];
        
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH-90, 7, 80, 30);
        [btn setTitle:@"查看更多 ＞" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor HexString:@"BABFCD"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(lookMore) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        return view;
    }else if (section==1){
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [view addSubview:self.segmentedControl];
        return view ;
    }
    
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section==1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
             btn.frame = CGRectMake(SCREEN_WIDTH-90, 7, 80, 30);
             [btn setTitle:@"查看全部商品 ∨" forState:UIControlStateNormal];
             btn.titleLabel.font = [UIFont systemFontOfSize:15];
             [btn setTitleColor:[UIColor HexString:@"BABFCD"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(lookMoreGoods:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        FRIActiveDetailViewController * vc = [FRIActiveDetailViewController new];

        if (_selcetIndex==1) {
            FRIActiveListModel * model = _activeModelList[indexPath.row];
            vc.activeID = model.activityId;
            vc.style = 1;

        }else{
          FRIGoodModel * model = _goodModelList[indexPath.row];
          vc.activeID = model.commodityId;        }
          [self.navigationController pushViewController:vc animated:YES];
    }
  
}
-(HMSegmentedControl*)segmentedControl{
    
    if (!_segmentedControl) {
           _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"商品", @"正在进行的活动"]];
           _segmentedControl.frame = CGRectMake(0, 5, SCREEN_WIDTH, 34);
           _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
           [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
           _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
           _segmentedControl.selectionIndicatorColor = Main_Color;
           _segmentedControl.selectionIndicatorHeight = 2.0;
           _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : Main_Color , NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
           _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:14]};
           _segmentedControl.backgroundColor = [UIColor clearColor];
    }
 
    return _segmentedControl;

}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    _selcetIndex = segmentedControl.selectedSegmentIndex;
    
    [_tableView reloadData];
}



-(void)lookMore{
    
}

-(void)lookMoreGoods:(UIButton*)sender{
    

}

#pragma mark 获取商家详情
-(void)loadNewData{
    NSString * api = [API_HOST stringByAppendingString:youFun_merchant];
    NSDictionary*diciton = @{@"merchantId": _storeID};
    WS(weakself);
    [HttpEngine requestGetWithURL:api params:diciton isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {

        NSArray * array = responseObject[@"data"] ;
        weakself.model = [FRImerchantModel mj_objectArrayWithKeyValuesArray:array].firstObject;
        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
//        [weakself.collectionView.mj_footer endRefreshing];
//        [weakself.collectionView.mj_header endRefreshing];
        
    }];
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

#pragma mark 正在进行的活动
-(void)loadGoodsActivingData{
    NSString * api = [API_HOST stringByAppendingString:youFun_activity];
    NSDictionary*diciton = @{@"merchantId": _storeID , @"page":@"1" ,@"limit":@"100"};
    
    WS(weakself);
    [HttpEngine requestGetWithURL:api params:diciton isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {

        NSArray * array = responseObject[@"data"] ;
        
        weakself.activeModelList = [FRIActiveListModel mj_objectArrayWithKeyValuesArray:array];

        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
//        [weakself.collectionView.mj_footer endRefreshing];
//        [weakself.collectionView.mj_header endRefreshing];
        
    }];
}

#pragma mark 评分
-(void)loadEvaluateData{
    NSString * api = [API_HOST stringByAppendingString:youFun_evaluate];
    NSDictionary*diciton = @{@"merchantId": _storeID , @"page":@"1" ,@"limit":@"100"};
    
    WS(weakself);
    [HttpEngine requestGetWithURL:api params:diciton isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {

        NSArray * array = responseObject[@"data"] ;
        weakself.ScoreModelList = [FRIScoreModel mj_objectArrayWithKeyValuesArray:array];

        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
//        [weakself.collectionView.mj_footer endRefreshing];
//        [weakself.collectionView.mj_header endRefreshing];
        
    }];
}

@end
