//
//  BikeSearchController.m
//  BikeUser
//
//  Created by libj on 2019/11/16.
//  Copyright © 2019 gwp. All rights reserved.
//

#import "BikeSearchController.h"
#import "TagView.h"
#import "YBHTextFiled.h"
#import "MainCollectionCell.h"

#import "BSAddChildHeaderView.h"
//#import "GamesDetailViewController.h"
//#import "StroeVC.h"
//#import "PLMessgaeDetailController.h"

@interface BikeSearchController ()<UITableViewDelegate,UITableViewDataSource,TagViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BSAddChildHeaderView *headerView;
@property (nonatomic, strong) TagView *tagView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation BikeSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBaseAttribute];
    [self setupSubviews];
    [self setupSubviewsLayout];
}


- (void) setBaseAttribute {
    self.customNavBar.hidden = YES;
    self.view.backgroundColor = White_Color;
    [self getSearchData];
    self.currentPage = 1;
    WS(weakself);
    self.headerView.sendBlock = ^{
        [weakself saveSearchData:weakself.headerView.textStr];
        [weakself.tableView reloadData];
        [weakself getListData];
    };
    
    self.headerView.cancelBtnBlock = ^{
        [weakself cancelBtnAction];
    };
}

- (void) setupSubviews {

    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];

}

- (void) setupSubviewsLayout {

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(iphoneXTop+27);
        make.height.equalTo(@30);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(7);
    }];
}

#pragma mark - 返回
- (void)cancelBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 设置 tag
- (void)setTagViewArr:(NSArray *)tagViewArr{
    [[self.tagView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.tagView.arr = tagViewArr;
}
- (void)getSearchData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults objectForKey:@"gameSearchHistory"];
    if (array.count) {
        [self setTagViewArr:array];
    }
}
- (void)saveSearchData:(NSString *)text {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"gameSearchHistory"]];
    if (![array containsObject:text]) {
//        [array addObject:text];
        [array insertObject:text atIndex:0];
    }
    if (array.count>6) {
        [array removeLastObject];
    }
    [userDefaults setObject:array forKey:@"gameSearchHistory"];
    [userDefaults synchronize];
}
- (void)delectAction {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"gameSearchHistory"];
    [self setTagViewArr:@[]];
    
}
#pragma mark - NetWorking
#pragma mark 获取赛事列表
- (void)getListData {
    
    [self.listArray removeAllObjects];
    self.currentPage = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = @"";
    if (self.type == 0) {
        url = FORMAT(@"%@%@",API_HOST,@"");
    }else if (self.type == 1){
        url = FORMAT(@"%@%@",API_HOST,@"");
        params[@"longitude"] = @(self.longitude);
        params[@"latitude"] = @(self.latitude);
    }else if (self.type == 2) {
        url = FORMAT(@"%@%@",API_HOST,@"");
    }
    params[@"keyword"] = self.headerView.textStr;
    params[@"page"] = @(self.currentPage);
    [MBProgressHUD showActivityIndicator];
    [HttpEngine requestPostWithURL:url params:params isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        NSArray *array = nil;
        if (self.type == 0) {
//            array = [BikeGameListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        }
        [self.listArray addObjectsFromArray:array];
        [self.tableView reloadData];
//        [self.tableView endRefresh];
        
        if (!self.listArray.count){
            self.tableView.mj_footer.hidden = YES;
        }else {
            self.tableView.mj_footer.hidden = NO;
            [self.view endEditing:YES];
        }
        if ( array.count < 15 ) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer resetNoMoreData];
        }
        self.currentPage++;
        
    } failure:^(NSError *error) {
        NSLog(@"error=%@",error);
        [self.tableView endRefresh];
        [MBProgressHUD hideActivityIndicator];
    }];
}
#pragma mark - TagViewDelegate
- (void)handleSelectTag:(NSString *)keyWord isSelect:(BOOL)isSelect {
    self.headerView.textField.text = keyWord;
    self.headerView.textStr = keyWord;
    [self saveSearchData:self.headerView.textStr];
    [self.tableView reloadData];
    [self getListData];
}
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.headerView.textStr.length ? self.listArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.headerView.textStr.length) {
        if (self.type == 0) {
            MainCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MainCollectionCell class])];
//            cell.priceDesLabel.text = @"￥";
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if (self.listArray.count) {
//                cell.model = self.listArray[indexPath.row];
//            }
            return cell;
        }
    
    }
    static NSString *identify =@"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    [cell.contentView addSubview:self.tagView];
    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(CGFloatBasedI375(15));
        make.top.offset(CGFloatBasedI375(20));
        make.right.offset(CGFloatBasedI375(-15));
//        make.height.equalTo(50);
        make.bottom.equalTo(cell.contentView).offset(-15);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.headerView.textStr.length)
        return CGFLOAT_MIN;
    else
        return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    header.backgroundColor = White_Color;
    UILabel *label = [UILabel new];
    label.text = @"历史搜索";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor HexString:@"909090"];
    [header addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(CGFloatBasedI375(15));
        make.bottom.equalTo(header.mas_bottom);
    }];
    
    UIButton *delectBtn = [UIButton new];
    [delectBtn setImage:UIImageName(@"btn_dustbin") forState:0];
    [header addSubview:delectBtn];
    [delectBtn addTarget:self action:@selector(delectAction) forControlEvents:UIControlEventTouchUpInside];
    
    [delectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.right.offset(CGFloatBasedI375(-15)-10);
    }];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
}
- (void) pushWebViewWithId:(NSString *)Id path:(NSString *)path {
    NSString *url = FORMAT(@"%@%@",API_HOST,path);
    [MBProgressHUD showActivityIndicator];
    [HttpEngine requestPostWithURL:url params:@{@"id" : Id.length ? Id : @""} isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
//         BikeMessageModel *model = [BikeMessageModel mj_objectWithKeyValues:responseObject[@"data"]];
//         PLMessgaeDetailController *VC = [[PLMessgaeDetailController alloc]init];
//         VC.model = model;
//         VC.customNavBar.title = model.title;
//        [self.navigationController pushViewController:VC animated:YES];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
         [_tableView registerNib:[UINib nibWithNibName:@"MainCollectionCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MainCollectionCell class])];

    }
    return _tableView;
}
- (BSAddChildHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[BSAddChildHeaderView alloc] init];
        _headerView.placeholder = @"请输入搜索关键字";
    }
    return _headerView;
}
- (TagView *)tagView{
    if (!_tagView) {
        _tagView = [[TagView alloc] initWithFrame:CGRectZero];
        _tagView.space = 12;
        _tagView.height = 35;
        _tagView.titleMargin = 37;
        _tagView.cornerRadius = 17.5;
        _tagView.delegate = self;
        _tagView.selectType = selectType_one;
    }
    return _tagView;
}

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
@end
