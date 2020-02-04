//
//  LMHVideoCollectionView.m
//  BaseProject
//
//  Created by wfg on 2019/9/7.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHVideoCollectionView.h"
#import "LMHVideoPlayVC.h"
#import "LMHVideoListCell.h"
#import "LMHVideoModel.h"

@interface LMHVideoCollectionView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property(nonatomic ,assign) NSInteger  page;

@property(nonatomic ,strong) NSMutableArray <LMHVideoModel*>* array;


@end
@implementation LMHVideoCollectionView

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGFloat kSpace = 16;
    layout.minimumLineSpacing = kSpace;
    layout.minimumInteritemSpacing = kSpace;
    CGFloat width = (SCREEN_WIDTH-kSpace*3)/2;
    layout.itemSize = CGSizeMake(width, 252-168+width-32);
    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);

    self = [self initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        [self registerNib:[UINib nibWithNibName:@"LMHVideoListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    }
    _page =1 ;
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getShortVideoList];
        [self.mj_footer resetNoMoreData];

    }];
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self getShortVideoList];
    }];
    
    _array = [NSMutableArray arrayWithCapacity:200];
    [self  getShortVideoList];
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LMHVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LMHVideoModel * model = self.array[indexPath.row];
    [cell.videoImagView setImageWithURL:[model.cover changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
    cell.videoNamelabel.text = model.videoName;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LMHVideoModel * model = self.array[indexPath.row];
    LMHVideoPlayVC * playVC = [LMHVideoPlayVC new];
    playVC.videoID = model.identifier;
    [[UIViewController getCurrentController].navigationController pushViewController:playVC animated:YES];
    
}

-(void)setWordKey:(NSString *)wordKey{
    _wordKey = wordKey;
    _page = 1 ;
    [self getShortVideoList];
}

-(void)getShortVideoList{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_LogisticsInfo_HOST stringByAppendingString:app_ShortVideo_List];
    NSDictionary* diction ;
 
    if (_wordKey) {
        diction = @{@"pageNo":@(_page),@"pageSize":@"10",@"keyWord":_wordKey};
    }else{
        diction = @{@"pageNo":@(_page),@"pageSize":@"10"};
    }
    
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:nil errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        
        NSArray <LMHVideoModel*>* arrayM = [LMHVideoModel mj_objectArrayWithKeyValuesArray: responseObject[@"data"]];
        
        if (arrayM.count<10) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }
        if (weakself.page==1) {
            self.array = [NSMutableArray arrayWithArray:arrayM];
        }else{
            [self.array addObjectsFromArray:arrayM];
        }
        [self reloadData];
        
    } failure:^(NSError *error) {
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}

@end
