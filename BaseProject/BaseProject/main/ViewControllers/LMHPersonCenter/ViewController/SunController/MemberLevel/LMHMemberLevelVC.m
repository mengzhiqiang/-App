//
//  LMHMemberLevelVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/6.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHMemberLevelVC.h"
#import "LMHvipModel.h"
#import "WKBaseWebViewController.h"

@interface LMHMemberLevelVC ()
@property (weak, nonatomic) IBOutlet UILabel *memberLbl;
@property (weak, nonatomic) IBOutlet UILabel *memberDesLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UIView *currentLevelView;
@property (weak, nonatomic) IBOutlet UIView *nextLevelView;

@property (strong, nonatomic)  LMHvipModel *vipModel;

@end

@implementation LMHMemberLevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"等级详情";
    [self.customNavBar wr_setRightButtonWithTitle:@"规则" titleColor:Main_title_Color];
    self.customNavBar.onClickRightButton = ^(void) {
        [self getVIpRule];
    };
    self.memberLbl.text = @"普通会员";
    self.memberDesLbl.text = @"会员等级：VVI普通会员";

    
//    [self updateCurrentLevel];
//    [self updateNextLevel];
    [self getRoleLevelDetails];
}

-(void)loadNewDataWithView{
    self.memberLbl.text    = _vipModel.levelName;
    self.memberDesLbl.text = [NSString stringWithFormat:@"会员等级：vip%@",_vipModel.level];
    [self  updateCurrentLevel];
    [self updateNextLevel];
    
    NSInteger current = _vipModel.sellMoney.integerValue;
    NSString* total   = [NSString stringWithFormat:@"%.2f",_vipModel.sellMoneyUp.floatValue];
    NSString *str = [NSString stringWithFormat:@"￥%.2f/%@", (float)current, total];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : Main_title_Color}];
    [att addAttributes:@{NSForegroundColorAttributeName : Main_Color} range:[str rangeOfString:_vipModel.sellMoneyUp]];
    self.amountLbl.attributedText = att;

}

- (void)updateCurrentLevel {
    if (_vipModel.itselfRebate.floatValue==0 && _vipModel.levelaRebate.floatValue==0 && _vipModel.levelbRebate.floatValue==0 ) {
        UILabel *lbl = [UILabel new];
        lbl.text = @"当前没有任何奖励，请努力提升您的等级";
        lbl.textColor = Main_title_Color;
        lbl.font = [UIFont systemFontOfSize:15];
        [self.currentLevelView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.currentLevelView);
        }];
    } else {
        NSMutableArray * imageArray = [NSMutableArray arrayWithCapacity:20];
        NSMutableArray * titleArray = [NSMutableArray arrayWithCapacity:20];

        if (_vipModel.itselfRebate.floatValue!=0) {
            [imageArray addObject:@"grzx_icon_hydjxq_xsfl"];
            [titleArray addObject:[NSString stringWithFormat:@"销售返利\n%@%%",_vipModel.itselfRebate]];
        }
        if (_vipModel.levelaRebate.floatValue!=0) {
            [imageArray addObject:@"grzx_icon_hydjxq_tdjj"];
            [titleArray addObject:[NSString stringWithFormat:@"直接返利\n%@%%",_vipModel.levelaRebate]];
        } if (_vipModel.levelaRebate.floatValue!=0) {
            [imageArray addObject:@"grzx_icon_hydjxq_tdjj"];
            [titleArray addObject:[NSString stringWithFormat:@"间接返利\n%@%%",_vipModel.levelbRebate]];
        }
        [self listViewWithImages:imageArray titles:titleArray superView:self.currentLevelView];
    }
}

- (void)updateNextLevel {
    if (_vipModel.itselfRebateUp.floatValue==0.0 && _vipModel.levelaRebateUp.floatValue==0 && _vipModel.levelbRebateUp.floatValue==0 ) {
        UILabel *lbl = [UILabel new];
        lbl.text = @"当前没有任何奖励，请努力提升您的等级";
        lbl.textColor = Main_title_Color;
        [self.nextLevelView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.nextLevelView);
        }];
    } else {
        NSMutableArray * imageArray = [NSMutableArray arrayWithCapacity:20];
        NSMutableArray * titleArray = [NSMutableArray arrayWithCapacity:20];
        
        if (_vipModel.itselfRebateUp.floatValue!=0) {
            [imageArray addObject:@"grzx_icon_hydjxq_xsfl1"];
            [titleArray addObject:[NSString stringWithFormat:@"销售返利\n%@%%",_vipModel.itselfRebateUp]];
        }
        if (_vipModel.levelaRebateUp.floatValue!=0) {
            [imageArray addObject:@"grzx_icon_hydjxq_tdjj1"];
            [titleArray addObject:[NSString stringWithFormat:@"直接返利\n%@%%",_vipModel.levelaRebateUp]];
        } if (_vipModel.levelaRebateUp.floatValue!=0) {
            [imageArray addObject:@"grzx_icon_hydjxq_tdjj1"];
            [titleArray addObject:[NSString stringWithFormat:@"间接返利\n%@%%",_vipModel.levelaRebateUp]];
        }
        
        [self listViewWithImages:imageArray titles:titleArray superView:self.nextLevelView];
    }
}

- (void)listViewWithImages:(NSArray *)imgs titles:(NSArray *)titles superView:(UIView *)superView {
    UIScrollView *sv = [UIScrollView new];
    sv.bounces = NO;
    sv.alwaysBounceHorizontal = YES;
    [superView addSubview:sv];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    NSInteger count = imgs.count;
    UIView *leftView = sv;
    for (int i = 0; i < count; i++) {
        UIView *view = [UIView new];
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:imgs[i]];
        [view addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view).offset(12);
        }];
        
        UILabel *lbl = [UILabel new];
        lbl.textColor = Main_title_Color;
        lbl.text = titles[i];
        lbl.numberOfLines = 0;
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(iv.mas_bottom).offset(8);
        }];
        [sv addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.height.equalTo(sv);
            if (i == 0) {
                make.left.equalTo(sv);
            } else {
                make.left.equalTo(leftView.mas_right);
            }
            make.width.equalTo(sv).multipliedBy(1.0/3);
            if (i == count-1) {
                make.right.equalTo(sv);
            }
        }];
        leftView = view;
    }
}

#pragma mark getRoleLevelDetails
-(void)getRoleLevelDetails{
    
    NSString * url = [API_HOST stringByAppendingString:client_roleLevel_getRoleLevelDetails];
    WS(weakself);
    [HttpEngine requestGetWithURL:url params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        
        if ([responseObject objectForKey:@"data"]) {
            weakself.vipModel = [LMHvipModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [self loadNewDataWithView];
        }
 
    } failure:^(NSError *error) {
        
        
    }];
    
}

-(void)getVIpRule{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_Iamage_HOST stringByAppendingString:client_clause_getClause];
    NSDictionary*dict = @{@"clauseType":@(1)};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:dict isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [MBProgressHUD hideActivityIndicator];
        NSArray * array = [responseObject objectForKey:@"data"] ;
        if (array.count ) {
            WKBaseWebViewController *vc = [[WKBaseWebViewController alloc] init];
            vc.headTitle = @"会员中心";
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
