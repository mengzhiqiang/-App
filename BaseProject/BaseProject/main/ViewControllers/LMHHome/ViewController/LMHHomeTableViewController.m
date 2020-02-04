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
@interface LMHHomeTableViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@end

@implementation LMHHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.hidden = YES;
    [self.view addSubview:self.collectionView ];
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_top);
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
    
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    if (section==0) {
        return 3;
    }else  if (section==1) {
        return 4;
    } else  if (section==2) {
        return 5;
    }
    return 5;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section <=2) {//10
        LMHImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMHImageCollectionViewCell" forIndexPath:indexPath];
        gridcell = cell;
        gridcell.backgroundColor = [self randomColor];
    }
    else if (indexPath.section >2) {//
        LMHGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMHGoodsCollectionViewCell" forIndexPath:indexPath];
        [cell.BGView draCirlywithColor:nil andRadius:8.0f];
        gridcell = cell;
        gridcell.backgroundColor = Main_BG_Color;
        [cell loadUI];
    }

    return gridcell;
}
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
            DCSlideshowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DCSlideshowHeadViewID" forIndexPath:indexPath];
            headerView.imageGroupArray = @[@"4rwr",@"4rwr"];   ///banner 轮播图
            headerView.backIndex = ^(NSInteger index) {

            };
            reusableview = headerView;
        }
    }
    return reusableview;
}

//这里我为了直观的看出每组的CGSize设置用if 后续我会用简洁的三元表示
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        return CGSizeMake(SCREEN_WIDTH/3, 130);
    }
    else if (indexPath.section==1) {
        return CGSizeMake((SCREEN_WIDTH-1)/4, 80);
    }
    else if (indexPath.section==2) {
        return CGSizeMake(SCREEN_WIDTH/5, 50);
    }
    
    return CGSizeMake(SCREEN_WIDTH, 110+100*RATIO_IPHONE6);


    return CGSizeZero;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 0) {

        layoutAttributes.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 0.38);

    }
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {

        return CGSizeMake(SCREEN_WIDTH, 200); //图片滚动的宽高
    }

    return CGSizeZero;
}

////代理方法, 控制每个段的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section==1) {
        return UIEdgeInsetsMake(0, 0, 0, 1);

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
    return  0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section >= 1) ? 4 : 0;
}

@end
