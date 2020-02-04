//
//  LMHMessageController.m
//  BaseProject
//
//  Created by libj on 2019/9/17.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHMessageController.h"
#import "LMHMessageCell.h"
#import "LMHMessageModel.h"

@interface LMHMessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation LMHMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBaseAttribute];
    [self setupSubviews];
    [self setupSubviewsLayout];
    
    [self getMessageData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataSource removeAllObjects];
        self.currentPage = 1;
        [self getMessageData];
        [self.tableView.mj_footer resetNoMoreData];

    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getMessageData];
    }];
}

- (void) setBaseAttribute {
    self.currentPage = 1;
    if (self.messageType == 1) {
         self.customNavBar.title = @"系统消息";
    }else {
         self.customNavBar.title = @"交易消息";
    }
}

- (void) setupSubviews {
    [self.view addSubview:self.tableView];
}

- (void) setupSubviewsLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(DCTopNavH);
        make.left.right.bottom.offset(0);
    }];
}

#pragma mark 获取消息数据
- (void)getMessageData {
    NSString *client_message = @"/client/message/getMessage";
    NSString * url = [API_HOST stringByAppendingString:client_message];
    
    UserInfo *userInfo = [CommonVariable getUserInfo];
    NSDictionary *params = @{
                             @"limit" : @(30),
                             @"messageType" : @(self.messageType),
                             @"page" : @(self.currentPage),
                             @"userId" : userInfo.userId,
                              @"isRead" : @"",
                             };
    
    [HttpEngine requestGetWithURL:url params:params isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        NSArray *array = [LMHMessageModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.dataSource addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        if (!self.dataSource.count)
            self.tableView.mj_footer.hidden = YES;
        else
            self.tableView.mj_footer.hidden = NO;
        if ( array.count < 30 ) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        self.currentPage++;
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify =@"LMHMessageCell";
    LMHMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if(!cell) {
        cell = [[LMHMessageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.backgroundColor = [UIColor HexString:@"#F5F5F5"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
