//
//  LMHMessageViewController.m
//  BaseProject
//
//  Created by libj on 2019/9/17.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHMessageViewController.h"
#import "LMHMessageHeaderView.h"
#import "LMHMessageCell.h"
#import "LMHMessageController.h"
#import "LMHMessageModel.h"

@interface LMHMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LMHMessageHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation LMHMessageViewController

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
    self.customNavBar.title = @"消息";
    self.currentPage = 1;
    WS(weakself);
    self.headerView.selectIndexBlock = ^(NSInteger index) {
        LMHMessageController *vc = [LMHMessageController new];
        vc.messageType = index;
        [weakself.navigationController pushViewController:vc animated:YES];
    };
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
                             @"messageType" : @"",
                             @"page" : @(self.currentPage),
                             @"userId" : userInfo.userId,
                             @"isRead" : @(1),
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
        
        self.headerView.isShowdealDot = YES;
        self.headerView.isShowSystemDot = YES;
        for (LMHMessageModel *model in self.dataSource) {
            if (model.messageType == 1 && model.isRead == 1) {
                self.headerView.isShowSystemDot = NO;
            }
            if (model.messageType == 2 && model.isRead == 1) {
                self.headerView.isShowdealDot = NO;
            }
        }

        self.currentPage++;
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark 一键已读
- (void)editMessageAction {
    
    NSString *client_eidtMessage = @"/client/message/eidtMessage";
    NSString * url = [API_HOST stringByAppendingString:client_eidtMessage];
    
    NSString *messageID = @"";
    
    if (!self.dataSource.count) {
        return;
    }
    
    for (LMHMessageModel *model in self.dataSource) {
        messageID = [messageID stringByAppendingFormat:@"%@,",model.ID];
    }
    messageID = [messageID substringToIndex:messageID.length-1];
    NSDictionary *params = @{
                             @"id" : messageID,
                             };
    
    [HttpEngine requestPostWithURL:url params:params isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        [self.dataSource removeAllObjects];
        self.currentPage = 1;
        [self getMessageData];
    } failure:^(NSError *error) {
       
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
    UIView *header = [UIView new];
    UILabel *label = [UILabel new];
    label.text = @"未读消息";
    [header addSubview:label];
    label.font = PFR15Font;
    label.textColor = Sub_title_Color;
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setTitle:@"一键已读" forState:0];
    [rightBtn setTitleColor:Main_Color forState:0];
    rightBtn.titleLabel.font = PFR12Font;
    [rightBtn addTarget:self action:@selector(editMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:rightBtn];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(header);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(header);
    }];
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFloatBasedI375(44);
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
    
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.backgroundColor = [UIColor HexString:@"#F5F5F5"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
    }
    return _tableView;
}

- (LMHMessageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LMHMessageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 94)];
    }
    return _headerView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
