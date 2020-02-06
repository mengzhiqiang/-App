//
//  FRIFriendsActiveViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 15/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIFriendsActiveViewController.h"

#import "FRIActiveModel.h"
#import "FRIActiveTableViewCell.h"
#import "FRIPersonInfoTableViewCell.h"
#import "BSGradientButton.h"
#import "FRIFriendSetViewController.h"
@interface FRIFriendsActiveViewController ()<UITableViewDelegate , UITableViewDataSource>
@property(nonatomic, strong) UITableView * rootTableView ;
@property(nonatomic, assign) NSInteger  page ;

@property(nonatomic, copy) NSMutableArray *  bandArray ;

@property(nonatomic, strong) BSGradientButton *  lowButton ;


@end

@implementation FRIFriendsActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customNavBar.title = @"个人主页";
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
    
    self.view.backgroundColor = Main_BG_Color;
     
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"btn_caozuo"]];
       [self.customNavBar setOnClickRightButton:^{
           FRIFriendSetViewController *vc = [FRIFriendSetViewController new];
           [weakself.navigationController pushViewController:vc animated:YES];
       }];
    
    if (_isBand) {
        [self.lowButton setTitle:@"申请解除绑定匹配关系" forState:UIControlStateNormal];
    }else  if (_isFirend) {
           [self.lowButton setTitle:@"申请绑定匹配关系" forState:UIControlStateNormal];
    }else {
        [self.lowButton setTitle:@"添加好友" forState:UIControlStateNormal];
    }
    
}

-(UITableView*)rootTableView{
        
        if (!_rootTableView) {
            _rootTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top) style:UITableViewStyleGrouped];
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
            return 0.01;
        }
        return 10.0;
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
    if (section==1) {
        return 10;
    }
    return  1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 2 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 265;
    }
    
        CGFloat height = [UILabel cellHight:@"硬骨头硬"];
        if (indexPath.row == 2 && indexPath.section==1) {
            height = [UILabel cellHight:@"硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头硬骨头"];
            return 75+height+ 117*RATIO_IPHONE6*2 +50;
        }
        return 75 +height+ 117*RATIO_IPHONE6*1+50 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"FRIPersonInfoTableViewCell";
        FRIPersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FRIPersonInfoTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        return cell ;
    }else{
    
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
        return cell ;

    }
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        NSLog(@"indexPath===%ld",indexPath.row);
}


-(BSGradientButton*)lowButton{
    if (!_lowButton) {
        _lowButton = [BSGradientButton buttonWithType:UIButtonTypeCustom];
        _lowButton.frame = CGRectMake(50, SCREEN_HEIGHT-70, SCREEN_WIDTH-100, 50);
        [_lowButton addTarget:self action:@selector(clickLowButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:_lowButton];
    return  _lowButton;
}

-(void)clickLowButton{
    
    NSLog(@"===clickLowButton===");
    
}

@end
