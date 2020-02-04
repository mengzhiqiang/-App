//
//  LMHHomeSearchVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/6.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHHomeSearchVC.h"
#import "LMHBandGoodsTableViewCell.h"
#import "JFBubbleHeader.h"
#import "LMHGoodDetailModel.h"
#import "LMHCellSizeTools.h"

@interface LMHHomeSearchVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,JFBuddleViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (nonatomic, strong) JFNormalBubbleView *hotTagView;
@property (nonatomic, strong) JFNormalBubbleView *hisTagView;

@property (nonatomic, strong) NSMutableArray<LMHGoodDetailModel*> *array;

@end

@implementation LMHHomeSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.customNavBar removeFromSuperview];
    [self searchTipsView];
    [self getHotSearch];
    _tv.separatorStyle=UITableViewCellAccessoryNone;

}

- (void)searchTipsView {
    UIScrollView *sv = self.sv;
    sv.userInteractionEnabled = YES;
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = @"热门搜索";
    [sv addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.offset(16);
    }];
   
    if (!self.hotTagView) {
        JFNormalBubbleView *tagView = [[JFNormalBubbleView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 90)];
        //        _searchBubbleView.editBubbleViewDelegate = self;
        //    tagView.scrollEnabled = NO;
        tagView.bubbleDelegate = self;
        [sv addSubview:tagView];
        self.hotTagView = tagView;
        self.hotTagView.bubbleDelegate = self;
         self.hotTagView.dataArray = @[@"ss", @"sagahaha", @"ss", @"sagahaha", @"ss", @"sagahaha", @"ss", @"ss", @"sagahaha", @"ss", @"sagahaha", @"ss", @"sagahaha", ];
    }
   
    {
        UILabel *lbl_history = [[UILabel alloc] init];
        lbl_history.text = @"搜索历史";
        [sv addSubview:lbl_history];
        [lbl_history mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(16);
            make.top.offset(136);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gwc_icon_sc"] forState:UIControlStateNormal];
        [sv addSubview:btn];
        btn.frame = CGRectMake(SCREEN_WIDTH-40, 136, 30, 30);
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.offset(-14);
//            make.height.width.offset(40);
//            make.top.offset(136);
//        }];
        [btn addTarget:self action:@selector(cleanHistory:) forControlEvents:UIControlEventTouchUpInside];
       
        JFNormalBubbleView *tagView = [[JFNormalBubbleView alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 90)];
        //        _searchBubbleView.editBubbleViewDelegate = self;
        tagView.scrollEnabled = NO;
        tagView.bubbleDelegate = self;
        [sv addSubview:tagView];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arr = [[ud valueForKey:@"HistorySearch"] mutableCopy];
        [ud synchronize];
        tagView.dataArray = arr;
        self.hisTagView = tagView;
    }
//    UIView *contentSizeView = [UIView new];
//    [sv addSubview:contentSizeView];
//    [contentSizeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(sv);
//        make.width.offset(SCREEN_WIDTH);
//        make.height.offset(self.hisTagView.top+self.hisTagView.height);
//    }];
    
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchAction:(UIButton *)sender {
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)cleanHistory:(UIButton *)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [[ud valueForKey:@"HistorySearch"] mutableCopy];
    if (arr) {
        [arr removeAllObjects];
        [ud setObject:arr forKey:@"HistorySearch"];
    }
    [ud synchronize];
    self.hisTagView.dataArray = arr;
}

- (void)searchText:(NSString *)text {
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_search_toSearch];
    NSDictionary *dic = @{@"key":text,@"limit":@(50),@"page":@(1)};
    [HttpEngine requestPostWithURL:path params:dic isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        if ([[responseObject objectForKey:@"data"] count]>0) {
            self.array = [NSMutableArray arrayWithCapacity:200];
            self.array = [LMHGoodDetailModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            [self.tv reloadData];
            self.sv.hidden = YES;
        }else{
            [MBProgressHUD showError:@"没有符合您要求的商品！"];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    LMHGoodDetailModel * model = _array[indexPath.row];
    CGFloat height = [LMHCellSizeTools cellHeightOfModel:model]+10;
    return 211+height;
    return 240;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"LMHBandGoodsTableViewCell";
    LMHBandGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMHBandGoodsTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        LMHGoodDetailModel * model = _array[indexPath.row];
        cell.goodModel = model;
        [cell.headerImageView setImageWithURL:[model.brandLogo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        cell.titleNameLabel.text = model.brandName ;
    return cell ;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length>0) {
        [searchBar resignFirstResponder];
        self.sv.hidden = YES;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arr = [[ud valueForKey:@"HistorySearch"] mutableCopy];
        if (!arr) {
            arr = [NSMutableArray array];
        }
        if (![arr containsObject:searchBar.text]) {
            [arr insertObject:searchBar.text atIndex:0];
            if (arr.count > 20) {
                [arr removeLastObject];
            }
            [ud setObject:arr forKey:@"HistorySearch"];
        }
        [ud synchronize];
        [self searchText:searchBar.text];
    } else {
        [MBProgressHUD showError:@"搜索内容不能为空"];
    }
}

- (void)bubbleView:(JFBubbleView *)bubbleView didTapItem:(JFBubbleItem *)item {
    [self searchText:item.textLabel.text];
}

-(void)getHotSearch{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_search_getHotSearch];
    [HttpEngine requestPostWithURL:path params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        if ([responseObject objectForKey:@"data"]) {
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:200];
            for (NSDictionary*dic in [responseObject objectForKey:@"data"]) {
                [array addObject:dic[@"key"]];
            }
            self.hotTagView.dataArray = array;
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}
@end
