//
//  LMHBandDetailViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 22/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBandDetailViewController.h"
#import "LMHBandTableViewCell.h"
#import "LMHBandGoodsTableViewCell.h"
#import "LMHBandGoodModel.h"
#import "LMHBandModel.h"
#import "LMHGoodDetailModel.h"
#import "LMHCellSizeTools.h"
#import "LMHGoodsDetailVC.h"

@interface LMHBandDetailViewController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic, strong) UITableView * rootTableView ;

@property(nonatomic, assign) NSInteger  page ;

@property(nonatomic, copy) NSMutableArray *  bandArray ;
@property(nonatomic, strong) LMHBandModel *  bandModel ;

@end

@implementation LMHBandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    self.customNavBar.title = @"品牌详情";
    [self.view addSubview:self.rootTableView];
    [self getBandDetail];
    
    WS(weakself);
    self.rootTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 1;
        [weakself getBandDetail];
        [weakself.rootTableView.mj_footer resetNoMoreData];

    }];
    
    self.rootTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        [weakself getBandDetail];
    }];
    
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
        return [self cellHight:(_bandModel.brandDetails?_bandModel.brandDetails:@"详情")]+121;
    }
    
    LMHGoodDetailModel * model = _bandArray[indexPath.row];
    NSString * string = [NSString stringWithFormat:@"%@ \n%@" ,model.goodsName ,model.goodsDesc];
    CGFloat contentH = [self  cellHight:string];
    NSString * specificationName = [model.specifications.firstObject objectForKey:@"specificationName"];
    long  guigeCount = (model.specifications.count%[self cellWith:specificationName]==0? model.specifications.count/[self cellWith:specificationName]:model.specifications.count/[self cellWith:specificationName]+1);
    CGFloat collectHeight = (model.goodsPicList.count>6?3:2)*100 + guigeCount*40+35+10;
    CGFloat height = [LMHCellSizeTools cellHeightOfModel:model]+10;

    return 211+height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"LMHBandTableViewCell";
        LMHBandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LMHBandTableViewCell" owner:self options:nil] objectAtIndex:0];
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
        [cell.headerImageView setImageWithURL:[_bandModel.brandLogo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        cell.titleNameLabel.text = _bandModel.brandName ;
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
#pragma mark 高度设置
-(CGFloat)cellHight:(NSString*)string{
    
    if (string==nil || [string isEqualToString:@""]) {
        return 1;
    }
    
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
    CGFloat titleHeight;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, CGFLOAT_MAX)options:options context:nil];
    titleHeight = ceilf(rect.size.height);
    return  titleHeight ;
}


-(void)getBandDetail{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_bands_brandDetail];
    NSDictionary* diction ;
    if ([CommonVariable  getUserInfo]) {
        diction = @{@"brandId":_bandID , @"scheduleId":(_scheduleId?_scheduleId:@""), @"limit":@10, @"page":@(_page), @"userId": [CommonVariable  getUserInfo].userId};
    }else{
        return ;
    }
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        [weakself.rootTableView.mj_header endRefreshing];
        [weakself.rootTableView.mj_footer endRefreshing];

        if (weakself.page==1) {
            if ([responseObject objectForKey:@"data"] ) {
                weakself.bandModel = [LMHBandModel mj_objectWithKeyValues: [responseObject objectForKey:@"data"]] ;
            }
        }
        [self addNewData:[[responseObject objectForKey:@"data"] objectForKey:@"goodsList"]];
        
    } failure:^(NSError *error) {
        [weakself.rootTableView.mj_header endRefreshing];
        [weakself.rootTableView.mj_footer endRefreshing];

        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        
        if ([userInfo[@"code"] integerValue] == 403) {
            [AFAlertViewHelper alertViewWithTitle:@"" message:@"该品牌暂未排期，敬请期待！" delegate:self cancelTitle:@"确定" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
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

/**
 根据规格宽度判断是一行展示多少个
 宽度大于一半cell宽度 一行显示一个
 宽度小于一半cell宽度  大于三分之一cell宽度 一行显示两个
 否则 一行显示3个
 */
-(NSInteger)cellWith:(NSString*)string{
    
    if (string==nil || [string isEqualToString:@""]) {
        return 1;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
    CGFloat titleWith;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, 20)options:options context:nil];
    titleWith = ceilf(rect.size.width);
    
    if (titleWith>=(SCREEN_WIDTH-60)/2) {
        return  1;
    }else  if (titleWith<(SCREEN_WIDTH-60)/2 && titleWith>(SCREEN_WIDTH-60)/3) {
        return  2;
    }else {
        return 3;
    }
    
}

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return ceil(height);
}

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return ceil(width);
}


@end
