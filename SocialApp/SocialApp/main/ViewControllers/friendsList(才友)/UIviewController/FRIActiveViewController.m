//
//  FRIActiveViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 14/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIActiveViewController.h"
#import "FRIActiveModel.h"
#import "FRIActiveTableViewCell.h"
#import "FRIFriendsActiveViewController.h"
#import "FRIUnReadActiveViewController.h"

@interface FRIActiveViewController ()<UITableViewDelegate , UITableViewDataSource>
@property(nonatomic, strong) UITableView * rootTableView ;
@property(nonatomic, assign) NSInteger  page ;

@property(nonatomic, copy) NSMutableArray *  bandArray ;

@end

@implementation FRIActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      _page = 1;
        [self.view addSubview:self.rootTableView];
        
        WS(weakself);
        self.rootTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.page = 1;
            [weakself.rootTableView.mj_footer resetNoMoreData];
            [self.rootTableView.mj_header endRefreshing];
        }];
        
        [self.rootTableView.mj_footer endRefreshingWithNoMoreData];

        [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"tab_icon_gwc_default"]];
        [self.customNavBar setOnClickRightButton:^{
               [UIViewController getCurrentController].tabBarController.selectedIndex = 2;
           }];
    
}

-(UITableView*)rootTableView{
    
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top) style:UITableViewStyleGrouped];
        _rootTableView.delegate=self;
        _rootTableView.dataSource=self;
        _rootTableView.separatorStyle=UITableViewCellAccessoryNone;
        _rootTableView.backgroundColor = Main_BG_Color;
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
    if (section==0) {
        return 50;
    }
    return 10.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]init];
    
    UIButton * messageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = CGRectMake((SCREEN_WIDTH-100)/2, 12.5, 100, 25);
    [messageBtn setTitle:@"5条未读消息 »" forState:UIControlStateNormal];
    messageBtn.backgroundColor = Main_Color;
    [messageBtn setTitleColor:White_Color forState:UIControlStateNormal];
    messageBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [messageBtn addTarget:self action:@selector(lookMessage) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn draCirlywithColor:nil andRadius:messageBtn.height/2];
    
    [view addSubview:messageBtn];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 10;
    }
    return  _bandArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = [UILabel cellHight:@"硬骨头硬"];
    if (indexPath.row == 2) {
        height = [UILabel cellHight:@"硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头"];
        return 75+height+ 117*RATIO_IPHONE6*2 +55;
    }
    return 75 +height+ 117*RATIO_IPHONE6*1+55 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *CellIdentifier = @"FRIActiveTableViewCell";
        FRIActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FRIActiveTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

    FRIActiveModel *model =  [FRIActiveModel new];
    model.content = @"硬骨头";
    if (indexPath.row == 2) {
    model.zanCount = @"5";
    model.content = @"硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头";

    }
    cell.model = model;
    
    cell.backgroundColor = White_Color;
    cell.contentView.backgroundColor = White_Color;

    return cell ;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath===%ld",indexPath.row);
    
    FRIFriendsActiveViewController* friVC=[[FRIFriendsActiveViewController alloc]init];
    
    if (indexPath.row==1) {
        friVC.isBand = YES;
    }else if (indexPath.row==2) {
        friVC.isFirend = YES;
    }
    [self.navigationController pushViewController:friVC animated:YES];
    
}

-(void)lookMessage{
    
    FRIUnReadActiveViewController * unReadVc =[[FRIUnReadActiveViewController alloc]init];
    [self.navigationController pushViewController:unReadVc animated:YES];
}

@end
