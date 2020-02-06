//
//  FRIUnReadActiveViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 16/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIUnReadActiveViewController.h"
#import "FRIActiveTableViewCell.h"

@interface FRIUnReadActiveViewController ()<UITableViewDelegate , UITableViewDataSource>
@property(nonatomic, strong) UITableView * rootTableView ;
@property(nonatomic, copy) NSMutableArray *  bandArray ;

@end

@implementation FRIUnReadActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"朋友圈";
    [self.view addSubview:self.rootTableView];
            
            WS(weakself);
            self.rootTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
        if (section==0) {
            return 0.01;
        }
        return 10.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
        if (section==0) {
            return 10;
        }
        return  _bandArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 3 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 119 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        static NSString *CellIdentifier = @"FRIActiveTableViewCell";
        FRIActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"FRIActiveTableViewCell" owner:self options:nil] objectAtIndex:1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

        FRIActiveModel *model =  [FRIActiveModel new];
        return cell ;
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        NSLog(@"indexPath===%ld",indexPath.row);
                
}


    

@end
