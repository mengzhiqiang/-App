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

#import "LMHHomeTableViewController.h"

@interface LMHHomeViewController ()
{
    HMSegmentedControl *segmentedControl;
}
/* collectionView */
@end

@implementation LMHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.customNavBar setNavigationUITitle:nil];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"sy_icon_pp"]];
//    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"sy_icon_pp"]];
    [self addSegmentView];
    
    LMHHomeTableViewController *  web = [[LMHHomeTableViewController alloc]init];
    web.view.frame = CGRectMake(0, self.customNavBar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-self.customNavBar.bottom-50-iphoneXTop);
    [self addChildViewController:web];
    [self.view addSubview:web.view];
    
    [self.view addSubview:self.customNavBar];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;

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
    
    UIButton * btn  =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(48, 28, SCREEN_WIDTH-96, 30);
    [btn draCirlywithColor:nil andRadius:btn.height/2];
    [btn setTitle:@" 输入商品关键字/品牌名称" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"sy_icon_ss"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor HexString:@"999999"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.backgroundColor = White_Color;
    [self.customNavBar addSubview:btn ];

}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}



@end
