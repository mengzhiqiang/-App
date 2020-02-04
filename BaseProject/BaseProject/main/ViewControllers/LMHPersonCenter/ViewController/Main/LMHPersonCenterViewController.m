//
//  LMHPersonCenterViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 28/6/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHPersonCenterViewController.h"
#import "DCCenterItemCell.h"
#import "DCMyCenterHeaderView.h"
#import "LLPersonalViewController.h"
#import "DCOrderListViewController.h"
#import "FRMAddressViewController.h"
#import "LMHAccountViewController.h"
#import "LMHTeamCenterVC.h"
#import "LMHInviteFriendVC.h"
#import "LMHSellCenterVC.h"
#import "LMHAfterSaleVC.h"
#import "LMHMemberLevelVC.h"
#import "HttpRequestToken.h"
#import "BENLoginViewController.h"
#import "LMHPersonCenterModel.h"
#import "LMHMessageViewController.h"
#import "WKBaseWebViewController.h"

@interface LMHPersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

/* headView */
@property (strong , nonatomic)DCMyCenterHeaderView *headView;
/* 头部背景图片 */
@property (nonatomic, strong) UIImageView *headerBgImageView;
/* tableView */
@property (strong , nonatomic)UITableView *tableView;

@property (strong , nonatomic)LMHPersonCenterModel* personModel;

@property (strong , nonatomic)UILabel * meassageLabel;


@end

static NSString *const DCCenterItemCellID = @"DCCenterItemCell";

@implementation LMHPersonCenterViewController
#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -50);
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = Main_BG_Color ;
        [_tableView registerClass:[DCCenterItemCell class] forCellReuseIdentifier:DCCenterItemCellID];
    }
    return _tableView;
}
- (UIImageView *)headerBgImageView{
    if (!_headerBgImageView) {
        _headerBgImageView = [[UIImageView alloc] init];
        [_headerBgImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sy_bg"]]];
        [_headerBgImageView setBackgroundColor:Main_BG_Color];
        //        [_headerBgImageView setClipsToBounds:YES];
    }
    return _headerBgImageView;
}

- (DCMyCenterHeaderView *)headView
{
    if (!_headView) {
        _headView = [DCMyCenterHeaderView dc_viewFromXib];
        _headView.frame =  CGRectMake(0, 0, SCREEN_WIDTH, 220+iphoneXTop);
    }
    return _headView;
}
-(UILabel*)meassageLabel{
    
    if (!_meassageLabel) {
        _meassageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.customNavBar.width-15, 30+iphoneXTop, 8, 8)];
        _meassageLabel.backgroundColor = Red_Color ;
        [_meassageLabel draCirlywithColor:nil andRadius:4];
    }
    
    return _meassageLabel ;
}

#pragma mark - 初始化头部
- (void)setUpHeaderCenterView{
    
    //    self.tableView.tableHeaderView = self.headView;
    self.headerBgImageView.frame = self.headView.bounds;
    self.headerBgImageView.top =  -iphoneXTop-20 ;
    self.headerBgImageView.height =  self.headView.height+iphoneXTop;

    [self.headView insertSubview:self.headerBgImageView atIndex:0]; //将背景图片放到最底层
    
    WS(weakself);
    self.headView.headClickBlock = ^{
        LLPersonalViewController * personVC = [[LLPersonalViewController alloc]init];
        personVC.PersonModel = weakself.personModel;
        [weakself.navigationController pushViewController:personVC animated:YES];
    };
    self.headView.seeVipClickBlock = ^{
        LMHMemberLevelVC *vc = [[LMHMemberLevelVC alloc] initWithNibName:@"LMHMemberLevelVC" bundle:[NSBundle mainBundle]];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.customNavBar.title = @"个人中心";
    //    self.customNavBar.hidden = YES;
    [self setUpHeaderCenterView];
    [self.view addSubview:self.tableView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.customNavBar wr_setBackgroundAlpha:0];
    self.customNavBar.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"grzx_icon_xtxx"]];
    WS(weakself);
    [self.customNavBar setOnClickRightButton:^{
        LMHMessageViewController *vc = [LMHMessageViewController new];
        [weakself.navigationController pushViewController:vc animated:YES];
    }];
    [self.customNavBar addSubview:self.meassageLabel];
    self.customNavBar.left = 100;
    self.customNavBar.width = SCREEN_WIDTH-100;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getAccountInfo ];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([[HttpRequestToken getToken] length] <1) {
        BENLoginViewController* login= [[BENLoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cusCell = [UITableViewCell new];
    DCCenterItemCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCenterItemCellID forIndexPath:indexPath];
    [cell loadNewUIWithStyle:indexPath.section+1 andData:_personModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backIndex = ^(int index) {
        switch (indexPath.section) {
            case 0:
            {
//                LMHSellCenterVC *vc =[[LMHSellCenterVC alloc] initWithNibName:@"LMHSellCenterVC" bundle:[NSBundle mainBundle]];
//                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                if (index == 3) {
                    LMHAfterSaleVC *vc = [LMHAfterSaleVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    DCOrderListViewController *orderVC =[[DCOrderListViewController alloc]init];
                    orderVC.selectIndex =((index ==100 ||index==3)?0:index+1);
                    [self.navigationController pushViewController:orderVC animated:YES];
                }
            }
                break;
            case 2:
            {
                [self selectTools:index];
            }
                break;
                
            default:
                break;
        }
    };
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return  120 ;
    }else  if (indexPath.section==1) {
        return  115 ;
    }else  if (indexPath.section==2) {
        return  200 ;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 200+iphoneXTop ;
    }
//    else if (section==1){
//        return  57*RATIO_IPHONE6;
//    }
    return 0.01 ;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return self.headView;
    }
//    else if (section == 1 ){
//
//        UIView * view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  57*RATIO_IPHONE6)];
//        view.backgroundColor = [UIColor clearColor];
//
//        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 57*RATIO_IPHONE6);
//        [btn setImage:[UIImage imageNamed:@"grzx_yqyl_banner"] forState:UIControlStateNormal];
//        //        [btn setBackgroundImage:[UIImage imageNamed:@"grzx_yqyl_banner"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(clickInvite) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:btn];
//        return  view ;
//    }
    return nil;
}

-(void)clickInvite{
    
    LMHInviteFriendVC *vc = [[LMHInviteFriendVC alloc] initWithNibName:@"LMHInviteFriendVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)selectTools:(NSInteger)index{
    
    switch (index) {
        case 0:
        {
            LMHAccountViewController *vc = [[LMHAccountViewController alloc] initWithNibName:@"LMHAccountViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
//        case 1:
//        {
//            LMHTeamCenterVC *vc = [[LMHTeamCenterVC alloc] initWithNibName:@"LMHTeamCenterVC" bundle:[NSBundle mainBundle]];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
        case 1:
        {
            [self.navigationController pushViewController:[FRMAddressViewController new] animated:YES];
        }
            break;
//        case 3:
//        {
//            LMHInviteFriendVC *vc = [[LMHInviteFriendVC alloc] initWithNibName:@"LMHInviteFriendVC" bundle:[NSBundle mainBundle]];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
        case 2:
        {
            [self getHelpCenter];
        }
            break;
        case 3:
        {
            [self callWithPhone];
        }
            break;
        case 4:
        {
            LLPersonalViewController *personVC = [[LLPersonalViewController alloc]init];
            personVC.PersonModel = self.personModel;
            [self.navigationController pushViewController:personVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark  打电话
-(void)callWithPhone{
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4008882435"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:nil completionHandler:nil];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)getAccountInfo{
    
    if ([CommonVariable getUserInfo].userId) {
        NSString * url = [API_HOST stringByAppendingString:client_userManager_getPersonalCenter];
        WS(weakself);
        [HttpEngine requestPostWithURL:url params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"data"]allKeys].count<1) {
                return ;
            }
            weakself.personModel = [LMHPersonCenterModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [weakself.tableView reloadData];
            weakself.headView.model = weakself.personModel;
            [[CommonVariable shareCommonVariable] setPersonModel:weakself.personModel];

            if (weakself.personModel.unreadAmount.integerValue>0) {
                weakself.meassageLabel.hidden = NO;
            }else{
                weakself.meassageLabel.hidden = YES;
            }
            
        } failure:^(NSError *error) {
            
            
        }];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"===%f",scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y<=0) {
        self.customNavBar.backgroundColor = [UIColor clearColor];
        self.customNavBar.left = 100;
        self.customNavBar.width = SCREEN_WIDTH-100;
           
    }else  if (scrollView.contentOffset.y<=64){
         self.customNavBar.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:125.0/255.0 blue:26.0/255.0 alpha:(scrollView.contentOffset.y/64)/1.25];
        self.customNavBar.left = 0;
              self.customNavBar.width = SCREEN_WIDTH-0;
    }else{
        self.customNavBar.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:125.0/255.0 blue:26.0/255.0 alpha:0.8];
        self.customNavBar.left = 0;
              self.customNavBar.width = SCREEN_WIDTH-0;

    }
    
    
}

-(void)getHelpCenter{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_Iamage_HOST stringByAppendingString:client_clause_getClause];
    NSDictionary*dict = @{@"clauseType":@(5)};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:dict isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [MBProgressHUD hideActivityIndicator];
        NSArray * array = [responseObject objectForKey:@"data"] ;
        if (array.count ) {
            WKBaseWebViewController *vc = [[WKBaseWebViewController alloc] init];
            vc.headTitle = @"帮助中心";
            vc.webStr = [[array objectAtIndex:0]objectForKey:@"content"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}

@end
