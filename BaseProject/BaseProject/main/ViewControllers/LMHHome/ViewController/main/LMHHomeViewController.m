//
//  LMHHomeViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 28/6/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHHomeViewController.h"
#import "BENLoginViewController.h"
#import "HMSegmentedControl.h"
#import "HttpRequestToken.h"
#import "LMHHomeTableViewController.h"
#import "LMHSearchSideView.h"
#import "LMHHomeSearchVC.h"
@interface LMHHomeViewController ()<UIScrollViewDelegate>
{
    HMSegmentedControl *segmentedControl;
}
@property(strong,nonatomic) UIScrollView * scrollView ;

@property(strong,nonatomic) NSArray * classArray ;
@property (nonatomic, strong) LMHSearchSideView *searchSideView;
@end

@implementation LMHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.customNavBar setNavigationUITitle:nil];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"sy_icon_pp"]];
    WS(weakself);
    LMHSearchSideView *searchSideView = [[NSBundle mainBundle] loadNibNamed:@"LMHSearchSideView" owner:self options:nil].firstObject;
    [self.tabBarController.view addSubview:searchSideView];
    [searchSideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(searchSideView.superview);
        make.left.equalTo(searchSideView.superview).offset(-SCREEN_WIDTH);
    }];
    self.searchSideView = searchSideView;
    self.customNavBar.onClickLeftButton = ^{
        [weakself.searchSideView show];
    };
    [self addSegmentView];
    [self addScrollViewAndTable];
    
    UIButton * btn  =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(48, iphoneXTop+24, SCREEN_WIDTH-96, 30);
    [btn draCirlywithColor:nil andRadius:btn.height/2];
    [btn setTitle:@" 输入商品关键字/品牌名称" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"sy_icon_ss"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor HexString:@"999999"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.backgroundColor = White_Color;
    [self.customNavBar addSubview:btn];
    [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[HttpRequestToken getToken] length] <1) {
        BENLoginViewController* login= [[BENLoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:NO];
    }
    
}

-(void)addScrollViewAndTable{
    CGFloat lisTheight = SCREEN_HEIGHT-41-SCREEN_top ;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.customNavBar.bottom, SCREEN_WIDTH, lisTheight)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, 200);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, 200) animated:NO];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.customNavBar];

//    [self addNewClassView];
}

-(void)addNewClassView{
    
    NSMutableArray * array =[NSMutableArray arrayWithCapacity:20];
    if (_classArray.count>0) {
        for (UIView*view in self.scrollView.subviews) {
            if ([view isKindOfClass:[LMHHomeTableViewController class]]) {
                view.hidden = YES;
                [view removeFromSuperview ];

            }
        }
//        [self removeFromParentViewController];
    }
    
    CGFloat withSegment = 0 ;
    for (int i=0; i<_classArray.count; i++) {
        NSDictionary *diction = _classArray[i];
        LMHHomeTableViewController *  webVC = [[LMHHomeTableViewController alloc]init];
        webVC.view.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.customNavBar.bottom-50-iphoneXTab);
        webVC.type = diction[@"classifyId"];
        [self addChildViewController:webVC];
        webVC.Index = i;
        [self.scrollView addSubview:webVC.view];
        [array addObject:[NSString stringWithFormat:@"%@",diction[@"classifyName"]]];
        
//        withSegment = withSegment + [diction[@"classifyName"] widthOfStringFont:[UIFont boldSystemFontOfSize:16]]+10;
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _classArray.count, 200);

    [segmentedControl removeAllSubviews];
    segmentedControl= nil ;
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:array];
    segmentedControl.frame = CGRectMake(0, SCREEN_top, SCREEN_WIDTH, 40);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    segmentedControl.selectionIndicatorColor = [UIColor  clearColor];
    segmentedControl.selectionIndicatorHeight = 2.0;
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : White_Color, NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HexString:@"eeeeee"], NSFontAttributeName : [UIFont fontWithName:nil size:14.0]};
    [self.customNavBar addSubview:segmentedControl ];
    segmentedControl.backgroundColor = [UIColor clearColor];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (_classArray.count<1) {
        [self getClassify];
    }
}

- (void)searchAction:(UIButton *)sender {
    LMHHomeSearchVC *vc = [[LMHHomeSearchVC alloc] initWithNibName:@"LMHHomeSearchVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addSegmentView{
    
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部(200)",@"爆款(40)", @"爆款(40)", @"爆款(40)",@" 爆款(40)", @"爆款(40)", @"爆款(40)"]];
    segmentedControl.frame = CGRectMake(0, SCREEN_top, SCREEN_WIDTH, 40);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    segmentedControl.selectionIndicatorColor = [UIColor  clearColor];
    segmentedControl.selectionIndicatorHeight = 2.0;
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : White_Color};
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HexString:@"eeeeee"], NSFontAttributeName : [UIFont fontWithName:nil size:15.0]};
    [self.customNavBar addSubview:segmentedControl ];
    segmentedControl.backgroundColor = [UIColor clearColor];


}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    long  index = (long)segmentedControl.selectedSegmentIndex;
    [self.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, 200) animated:YES];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [segmentedControl setSelectedSegmentIndex:page animated:YES];
    
}

-(void)getClassify{
    
    [MBProgressHUD showActivityIndicator];
     NSString *path = [API_HOST stringByAppendingString:client_home_classify];
     [HttpEngine requestPostWithURL:path params:nil isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
         NSLog(@"===responseObject==%@",responseObject);

      [MBProgressHUD hideActivityIndicator];
         if ([[responseObject objectForKey:@"data"] objectForKey:@"classifies"]) {
             _classArray = [[responseObject objectForKey:@"data"] objectForKey:@"classifies"];
             [self addNewClassView];
         }
         
     } failure:^(NSError *error) {
    
       [MBProgressHUD hideActivityIndicator];
       NSDictionary *userInfo = error.userInfo;
       NSLog(@"==JSONDic=userInfo==%@",userInfo);
       [MBProgressHUD showError:userInfo[@"msg"]];
         
     }];

}
@end
