//
//  LMHLiveTVCollectionView.m
//  BaseProject
//
//  Created by libj on 2019/9/23.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHLiveTVCollectionView.h"
#import "LMHVideoPlayVC.h"
#import "LMHVideoListCell.h"
#import "LMHVideoModel.h"
#import "LMHLiveTVCell1.h"
#import "JHCollectionViewFlowLayout.h"
@interface LMHLiveTVCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,JHCollectionViewDelegateFlowLayout>

@property(nonatomic ,assign) NSInteger  page;

@property(nonatomic ,strong) NSArray *dataSource;

@end

@implementation LMHLiveTVCollectionView

-(instancetype)init{
    JHCollectionViewFlowLayout *layout = [[JHCollectionViewFlowLayout alloc]init];
    CGFloat kSpace = 16;
    layout.minimumLineSpacing = kSpace;
    layout.minimumInteritemSpacing = 0;

//    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
    return [self initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"LMHVideoListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[LMHLiveTVCell1 class] forCellWithReuseIdentifier:NSStringFromClass([LMHLiveTVCell1 class])];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"offlineID"];
    
    _page =1 ;
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.dataSource[0] removeAllObjects];
        [self.dataSource[1] removeAllObjects];
        [self getShortVideoList];
        [self.collectionView.mj_footer resetNoMoreData];

    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
//        [self getShortVideoList];
        [self getWonderList];
    }];
    [self  getShortVideoList];

}

-(void)setWordKey:(NSString *)wordKey{
    _wordKey = wordKey;
    _page = 1 ;
    [self getShortVideoList];
}

-(void)getShortVideoList{
    
    NSString *path = [API_LogisticsInfo_HOST stringByAppendingString:app_Broadcast_list];
    NSDictionary* diction ;
    
    if (_wordKey) {
        diction = @{@"pageNo":@(_page),@"pageSize":@"100",@"keyWord":_wordKey};
    }else{
        diction = @{@"pageNo":@(_page),@"pageSize":@"100"};
    }
    
    [HttpEngine requestPostWithURL:path params:diction isToken:nil errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        NSArray <LMHVideoModel*>* arrayM = [LMHVideoModel mj_objectArrayWithKeyValuesArray: responseObject[@"data"]];
        
        if (arrayM.count<100) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        if ([self.dataSource[0] count]) {
            [self.dataSource[0] removeAllObjects];
        }
        [self.dataSource[0] addObjectsFromArray:arrayM];
         [self getWonderList];
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
}


- (void) getWonderList {
    NSString *path = [API_LogisticsInfo_HOST stringByAppendingString:app_Broadcast_WonderList];
    NSDictionary* diction ;
    
    if (_wordKey) {
        diction = @{@"pageNo":@(_page),@"pageSize":@"10",@"keyWord":_wordKey};
    }else{
        diction = @{@"pageNo":@(_page),@"pageSize":@"10"};
    }
    
    [HttpEngine requestPostWithURL:path params:diction isToken:nil errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        NSArray <LMHVideoModel*>* arrayM = [LMHVideoModel mj_objectArrayWithKeyValuesArray: responseObject[@"data"]];
        
        if (arrayM.count<10) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        if (_page==1) {
            if ([self.dataSource[1] count]) {
                [self.dataSource[1] removeAllObjects];
            }
            [self.dataSource[1] addObjectsFromArray:arrayM];
        }else{
            [self.dataSource[1] addObjectsFromArray:arrayM];
        }

        [self.collectionView reloadData];

        
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if ([self.dataSource[1] count]<1) {
        return 1;
    }
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  [self.dataSource[section] count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH-30, 285);
    }
    CGFloat kSpace = 15;

    CGFloat width = (SCREEN_WIDTH-kSpace*3)/2.0;
    return CGSizeMake(width, 252-168+width-32);
    
}

//header的size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, section == 0 ? CGFLOAT_MIN : 44);
}

#pragma mark -- 返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"offlineID" forIndexPath:indexPath];
        header.backgroundColor = [UIColor whiteColor];
        reusableView = header;
        [header removeAllSubviews];
        if (indexPath.section == 1) {
            UIImageView *icon = [UIImageView new];
            icon.image = [UIImage imageNamed:@"fx_icon_jcyg"];
            [header addSubview:icon];
            
            UILabel *desLabel = [UILabel new];
            desLabel.text = @"精彩预告";
            desLabel.font = [UIFont systemFontOfSize:16];
            desLabel.textColor = Main_title_Color;
            [header addSubview:desLabel];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.centerY.equalTo(header);
            }];
            
            [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(icon.mas_right).offset(6);
                make.centerY.equalTo(header);
            }];
        }
    }
    //如果是头视图
    return reusableView;
}

#pragma mark - JHCollectionViewDelegateFlowLayout
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    return [@[
              [UIColor HexString:@"#f5f5f5"],
              [UIColor whiteColor]
              ] objectAtIndex:section];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(15, 15,15, 15);
    }else {
        return UIEdgeInsetsMake(0, 15,15, 15);
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LMHLiveTVCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LMHLiveTVCell1 class]) forIndexPath:indexPath];
    if ([self.dataSource[indexPath.section] count]) {
        cell.model = self.dataSource[indexPath.section][indexPath.item];
    }

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==1) {
        [MBProgressHUD showError:@"尚未开播！"];
        return;
    }
    
    LMHVideoModel * model = self.dataSource[indexPath.section][indexPath.item];
    LMHVideoPlayVC * playVC = [LMHVideoPlayVC new];
    playVC.videoID = model.identifier;
    playVC.videoType = 1;
    [[UIViewController getCurrentController].navigationController pushViewController:playVC animated:YES];
    
}


- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[
                   @[].mutableCopy,
                   @[].mutableCopy,
                   ];
    }
    return _dataSource;
}

@end
