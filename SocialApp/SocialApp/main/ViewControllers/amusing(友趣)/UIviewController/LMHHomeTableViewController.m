//
//  LMHHomeTableViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 21/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHHomeTableViewController.h"

#import "MainCollectionCell.h"
#import "DCSlideshowHeadView.h"
#import "FRIMessageView.h"
#import "FRICardEnterViewController.h"
#import "FRIstoreInfoViewController.h"
#import "FRImerchantModel.h"
#import <MAMapKit/MAMapKit.h>

@interface LMHHomeTableViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong , nonatomic)NSMutableArray *merchantArray;

@property (strong , nonatomic)FRIMessageView *messageView;

//@property (strong , nonatomic)NSMutableArray<LMHhomeGoodModel*> *GoodsArray;
//@property (strong , nonatomic)NSArray <LMHHomeModel*>*bannerArray;

@property (assign , nonatomic)NSInteger  page; //当前页数
@property (assign , nonatomic)NSInteger  Goodspage; //当前页数


@end

@implementation LMHHomeTableViewController

-(FRIMessageView*)messageView{

    if (!_messageView) {
        _messageView = [[FRIMessageView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH*9/16+10, SCREEN_WIDTH, 100)];
    }
    return _messageView ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.hidden = YES;
    [self.view addSubview:self.collectionView ];
    _page = 1 ;
    
    WS(weakself);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 1;
        [self  loadNewData];

        [weakself.collectionView.mj_footer resetNoMoreData];
        [weakself.collectionView.mj_header endRefreshing];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        [self  loadNewData];
    }];
}

-(void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    [self  loadNewData];
}


-(NSMutableArray*)merchantArray{
    if (!_merchantArray) {
        _merchantArray = [NSMutableArray arrayWithCapacity:200];
    }
    return _merchantArray;
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top-iphoneXTab-50);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
//        [_collectionView registerClass:[LMHGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"LMHGoodsCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MainCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"MainCollectionCell"];
//        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LMHGoodsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"LMHGoodsCollectionViewCell"];
//        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LMHhomeGoodsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"LMHhomeGoodsCollectionViewCell"];

 
        [_collectionView registerClass:[DCSlideshowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DCSlideshowHeadViewID"];

        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor = Main_BG_Color;
    }
    return _collectionView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return (_merchantArray.count?_merchantArray.count:10);

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;

    MainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCollectionCell" forIndexPath:indexPath];
        gridcell = cell;
        gridcell.backgroundColor = [UIColor whiteColor];
    
    if (_merchantArray.count>indexPath.row) {
          FRImerchantModel*model = _merchantArray[indexPath.row];
        
           [cell.iconImage setImageWithURL:[NSURL URLWithString: URL(model.merchantImg)] placeholderImage:nil];
           cell.titleLabel.text = model.merchantName;
           cell.subTitleLabel.text = model.shopIntroduce;
           cell.starView.currentScore = [model.collect floatValue];
           cell.scoreLabel.text = model.collect;
           cell.distanceLabel.text = [self distance:model];
    }
  
    return gridcell;
}

-(NSString*)distance:(FRImerchantModel*)model{
    //1.将两个经纬度点转成投影点
      MAMapPoint point1 = MAMapPointForCoordinate(self.locition);
      MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(model.latitude ,model. longitude ));
      //2.计算距离
      CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    
    if (distance<500) {
        return  [NSString stringWithFormat:@"%.fm",distance];
    }
    return  [NSString stringWithFormat:@"%.2fkm",(float)distance/1000];
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
                    
//                    if (self.bannerArray.count>index) {
//                        LMHHomeModel*model = self.bannerArray[index];
//                        [self pushNextWithModel:model];
//                    }
                };
                
                [headerView addSubview:self.messageView];
                reusableview = headerView;
            }
        }
        }
    
    return reusableview;
}

-(NSArray*)addBanner{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:20];

    return @[DefluatPic];
    return array;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(SCREEN_WIDTH, 140);

    return CGSizeZero;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 0) {
        if ([[self addBanner] count]) {
            layoutAttributes.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*9/16+80);
        }
    }
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*9/16+110); //图片滚动的宽高
    }
    return CGSizeZero;
}


////代理方法, 控制每个段的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//#pragma mark - foot宽高
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//
//    return CGSizeZero;
//}

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
    
   
    if (indexPath.row==3) {
         [AFAlertViewHelper alertViewWithTitle:@"提示" message:@"请先实名认证" delegate:self cancelTitle:@"取消" otherTitle:@"去认证" clickBlock:^(NSInteger buttonIndex) {
               
               if (buttonIndex==1) {
               [self.navigationController pushViewController:[FRICardEnterViewController new] animated:YES];

               }
               
           }];
        return ;
    }
    
    FRImerchantModel*model = _merchantArray[indexPath.row];

    FRIstoreInfoViewController * storeVC= [FRIstoreInfoViewController new];
    storeVC.storeID = model.merchantId;
    [self.navigationController pushViewController:storeVC animated:YES];
    
}

-(void)loadNewData{
    NSString * api = [API_HOST stringByAppendingString:youFun_merchant];
    NSDictionary*diciton = @{@"city":(_cityName?_cityName:@"") , @"limit":@"20",@"page":@(_page)};
    WS(weakself);
    [HttpEngine requestGetWithURL:api params:diciton isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [weakself.collectionView.mj_footer endRefreshing];
        [weakself.collectionView.mj_header endRefreshing];

        NSArray * array = responseObject[@"data"];
        if (weakself.page==1) {
            weakself.merchantArray = [FRImerchantModel mj_objectArrayWithKeyValuesArray:array];
        }else{
            [weakself.merchantArray addObjectsFromArray:[FRImerchantModel mj_objectArrayWithKeyValuesArray:array]];
        }
        if (array.count<20) {
            [weakself.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakself.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [weakself.collectionView.mj_footer endRefreshing];
        [weakself.collectionView.mj_header endRefreshing];
        
    }];
}

@end
