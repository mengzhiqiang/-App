//
//  LMHHomeTableViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 21/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHHomeTableViewController.h"
#import "LMHImageCollectionViewCell.h"
#import "LMHGoodsCollectionViewCell.h"
#import "DCSlideshowHeadView.h"
#import "LMHBandDetailViewController.h"

#import "SAUICollectionViewFlowLayout.h"

#import "LMHHomeModel.h"
#import "WKwebViewController.h"
#import "LMHActiveViewController.h"
#import "LMHGoodsDetailVC.h"

@interface LMHHomeTableViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong , nonatomic)NSArray <LMHHomeModel*>*bannerArray;
@property (strong , nonatomic)NSMutableArray *commendArray;
@property (strong , nonatomic)NSMutableArray *customLayoutArray;
@property (assign , nonatomic)NSInteger  page; //当前页数

@end

@implementation LMHHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.hidden = YES;
    [self.view addSubview:self.collectionView ];
    _page = 1 ;
    
    WS(weakself);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 1;
        [weakself getClassifyDetailInfo];
        [weakself getMoreBrand];
        [weakself.collectionView.mj_footer resetNoMoreData];

    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        [weakself getMoreBrand];
    }];
 
}

-(void)setType:(NSString *)type
{
    _type = type ;
    [self  loadNewData];
}
-(void)loadNewData{
    
    [self  getClassifyDetailInfo];
    [self getMoreBrand];
}

-(NSMutableArray*)commendArray{
    if (!_commendArray) {
        _commendArray = [NSMutableArray arrayWithCapacity:200];
    }
    return _commendArray;
}
-(NSMutableArray*)customLayoutArray{
    if (!_customLayoutArray) {
        _customLayoutArray = [NSMutableArray arrayWithCapacity:50];
    }
    return _customLayoutArray;
}
-(NSArray*)headDiction{
    if (!_bannerArray) {
        _bannerArray = [NSArray array];
    }
    return _bannerArray;
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        SAUICollectionViewFlowLayout *layout = [SAUICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-109-50-iphoneXTab);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
//        [_collectionView registerClass:[LMHGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"LMHGoodsCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LMHImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"LMHImageCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LMHGoodsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"LMHGoodsCollectionViewCell"];

 
        [_collectionView registerClass:[DCSlideshowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DCSlideshowHeadViewID"];

        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor = Main_BG_Color;
    }
    return _collectionView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _customLayoutArray.count+1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    if (section<_customLayoutArray.count) {
//        return 3 ;
        return [_customLayoutArray[section] count];
    }
    return _commendArray.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section < _customLayoutArray.count) {//10
        LMHImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMHImageCollectionViewCell" forIndexPath:indexPath];
        gridcell = cell;
        gridcell.backgroundColor = [UIColor whiteColor];
        NSArray *array = _customLayoutArray[indexPath.section];
        LMHHomeModel*model = array[indexPath.row];
        NSString *string = URL(model.url);
        NSString *imgUrl = [string  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    }
    else if (indexPath.section == _customLayoutArray.count) {
        LMHGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMHGoodsCollectionViewCell" forIndexPath:indexPath];
        [cell.BGView draCirlywithColor:nil andRadius:8.0f];
        gridcell = cell;
        gridcell.backgroundColor = Main_BG_Color;
        if (indexPath.row<_commendArray.count) {
            LMHBandGoodModel * model = _commendArray[indexPath.row];
            [cell loadUI:model];
        }else{
            [cell loadUI:nil];
        }
    }

    return gridcell;
}

#pragma mark 随机颜色
- (UIColor*)randomColor {
    NSInteger aRedValue =arc4random() %255;
    NSInteger aGreenValue =arc4random() %255;
    NSInteger aBlueValue =arc4random() %255;
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            
            if ([[self addBanner]count]) {
                DCSlideshowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DCSlideshowHeadViewID" forIndexPath:indexPath];
                headerView.imageGroupArray = [self addBanner];   ///banner 轮播图
                headerView.backIndex = ^(NSInteger index) {
                    
                    if (self.bannerArray.count>index) {
                        LMHHomeModel*model = self.bannerArray[index];
                        [self pushNextWithModel:model];
                    }
                };
                reusableview = headerView;
            }
            
        }
    }
    return reusableview;
}

-(NSArray*)addBanner{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:20];
    for (LMHHomeModel*mode in _bannerArray) {
        
        NSString*hString = [URL(mode.url) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
           [array addObject: hString];
    }
//    return @[DefluatPic];
    return array;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section < _customLayoutArray.count) {
       LMHHomeModel*model =  [_customLayoutArray[indexPath.section] firstObject];
        CGFloat height  = [model.height floatValue];
        long count = [_customLayoutArray[indexPath.section] count];
        CGFloat  with =(SCREEN_WIDTH-1)/count ;
//
        if (IS_X_ && count==4) {
          with =(SCREEN_WIDTH)/count ;
        }
        if ((int)SCREEN_WIDTH%(count)==0) {
            with =(SCREEN_WIDTH)/count ;
        }
        NSLog(@"===%lf===%lf",with , height*SCREEN_WIDTH/100);
         return CGSizeMake(with, height*SCREEN_WIDTH/100);
    }
    return CGSizeMake(SCREEN_WIDTH, 100+95*RATIO_IPHONE6);


    return CGSizeZero;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 0) {
        if ([[self addBanner] count]) {
            layoutAttributes.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 0.38);
        }
    }
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if ([[self addBanner] count]) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*9/16); //图片滚动的宽高
        }
    }
    return CGSizeZero;
}

////代理方法, 控制每个段的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section < _customLayoutArray.count) {
    
        long count = [_customLayoutArray[section] count];
        
        if (IS_X_ &&count==4) {
                return  UIEdgeInsetsMake(0, 0, 0, 0);
        }else{
            if (count==4) {
                return  UIEdgeInsetsMake(0, 0, 0, 1);
            }
            return  UIEdgeInsetsMake(0, 0, 0, 0);
        }
      
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return  0.0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section >= 1) ? 4 : 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
  
    if (indexPath.section==_customLayoutArray.count) {
        LMHBandGoodModel * model ;
        if (indexPath.row<_commendArray.count) {
            model = _commendArray[indexPath.row];
        }else{
            [MBProgressHUD showError:@"无法查看品牌信息"];
            return;
        }
        
        LMHBandDetailViewController* bandDetailVC =[[LMHBandDetailViewController alloc]init];
        bandDetailVC.bandID =model.brandId;
        bandDetailVC.scheduleId =model.scheduleId;
        [self.navigationController pushViewController:bandDetailVC animated:YES];
       
    }else{
        NSArray  * array = _customLayoutArray[indexPath.section];
        LMHHomeModel*model = array[indexPath.row];
        [self pushNextWithModel:model];
    }
    
}
#pragma mark 跳转页面
-(void)pushNextWithModel:(LMHHomeModel*)model{
    
    switch ([model.linkType intValue]) {
        case 1:
        {
            LMHBandDetailViewController* bandDetailVC =[[LMHBandDetailViewController alloc]init];
            bandDetailVC.bandID =model.link;
            bandDetailVC.scheduleId =model.scheduleId;

            [self.navigationController pushViewController:bandDetailVC animated:YES];
        }
            break;
        case 2:
        {
         
            LMHActiveViewController* bandDetailVC =[[LMHActiveViewController alloc]init];
            bandDetailVC.activeID = model.link;
            [self.navigationController pushViewController:bandDetailVC animated:YES];
        }
            break;
        case 3:
        {
            if (![model.link hasPrefix:@"http"]) {
                return;
            }
            WKwebViewController * webVC = [[WKwebViewController alloc]init];
            webVC.webUrl = [NSString stringWithFormat:@"%@?useID=%@",model.link,[CommonVariable getUserInfo].userId];
            webVC.title = @"活动网页";
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
            
        case 4:
        {
           
//            [MBProgressHUD showError:@"跳转商品 敬请期待"];
            LMHGoodsDetailVC *vc = [[LMHGoodsDetailVC alloc] initWithNibName:@"LMHGoodsDetailVC" bundle:[NSBundle mainBundle]];
            vc.goodID = model.link;
            [[UIViewController getCurrentController].navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)getClassifyDetailInfo{
    
    NSString *path = [API_HOST stringByAppendingString:client_home_getHomeList];
    NSDictionary * diction;
    if (_type) {
     diction = @{@"classifyId":self.type};
    }else{
        return ;
    }
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [weakself.collectionView.mj_header endRefreshing];
        if ([[responseObject objectForKey:@"data"] objectForKey:@"banners"]) {
            weakself.bannerArray = [LMHHomeModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"banners"]];
            [weakself.collectionView reloadData];
        }
        if ([[responseObject objectForKey:@"data"] objectForKey:@"home"]) {
            [weakself loadNewDataWithHome:[[responseObject objectForKey:@"data"] objectForKey:@"home"]];
            [weakself.collectionView reloadData];
        }
        
      } failure:^(NSError *error) {
          [weakself.collectionView.mj_header endRefreshing];

        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
    }];
    
}
-(void)loadNewDataWithHome:(NSDictionary*)diction{
    
    if (self.customLayoutArray.count) {
        [self.customLayoutArray removeAllObjects];
    }
    
//    for (NSString*string in diction.allKeys) {
//        NSArray * array = diction[string];
//        if (array.count>0) {
//            NSArray * a = [LMHHomeModel mj_objectArrayWithKeyValuesArray:array];
//            [self.customLayoutArray addObject:a];
//        }
//    }
    
    NSMutableArray * array =[NSMutableArray arrayWithArray:diction.allKeys];
    
    for (int i = 0; i < array.count; i++) {
        for (int j = i+1; j < array.count; j++) {
            if ([array[i] intValue] > [array[j] intValue]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    for (int i=0; i<diction.allKeys.count; i++) {
        NSString* string1 = [array objectAtIndex:i];
        NSArray * array = diction[string1];

        if (array.count>0) {
            NSArray * a = [LMHHomeModel mj_objectArrayWithKeyValuesArray:array];
            [self.customLayoutArray addObject:a];
        }

    }
    
}

-(void)getMoreBrand{
    
    //    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_home_getMoreBrand];
    
    NSDictionary * diction;
    if (_type) {
        diction = @{@"classifyId":self.type , @"limit":@10,@"page":@(_page)};
    }else{
        return ;
    }
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [self.collectionView.mj_header  endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        if ([[responseObject objectForKey:@"data"] objectForKey:@"brands"]) {
            
            if ([[responseObject[@"data"] objectForKey:@"brands"] count]<10) {
                [weakself.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            if (_page>1) {
                [weakself.commendArray addObjectsFromArray:[LMHBandGoodModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"brands"]]];
            }else{
                weakself.commendArray = [LMHBandGoodModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"brands"]];
            }
            
            [weakself.collectionView reloadData];
        }
    
    } failure:^(NSError *error) {
        [self.collectionView.mj_header  endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);

    }];
    
}
/*
 (
 {
 addUserId = 1;
 brandDetails = 1551;
 brandId = "79de413a-743f-452b-8ec4-39ce768168ee";
 brandLogo = "/upload/pic/20190831/1567251668859dlzc_icon_wx.png";
 brandName = "\U5954\U9a70";
 createTime = "2019-08-31 19:41:12";
 endTime = "2019-09-07 19:49:24";
 goods =                 (
 {
 repertory = 45;
 url = "/upload/pic/20190831/1567251717455dlzc_icon_wx.png";
 }
 );
 goodsCount = 0;
 isDelete = 0;
 isRecommended = 1;
 isShelves = 1;
 order = 10;
 startTime = "2019-08-30 19:49:16";
 }
 */

@end
