//
//  FRIHomeListViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 28/10/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIHomeListViewController.h"
#import "EMContactsViewController.h"

#import "EMConversationsViewController.h"
#import "EMContactsViewController.h"
#import "EMInviteFriendViewController.h"
#import "HMSegmentedControl.h"
#import "BENLoginViewController.h"
#import "FRIActiveViewController.h"

@interface FRIHomeListViewController ()

@property(nonatomic ,strong)UIScrollView  * rootScrollView;
@property(nonatomic ,strong)HMSegmentedControl  * segmentedControl;


@end

@implementation FRIHomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"nav_btn_tjpy"]];
    [self.customNavBar setOnClickRightButton:^{
        NSLog(@"===添加好友==");
        [self.navigationController pushViewController:[EMInviteFriendViewController new] animated:YES];
    }];
    
    EMConversationsViewController * sationsCV = [[EMConversationsViewController alloc]init];
       [self addChildViewController:sationsCV];
       sationsCV.view.frame =self.rootScrollView.bounds;
       [self.rootScrollView addSubview:sationsCV.view];
       
    
    EMContactsViewController * contactCV = [[EMContactsViewController alloc]init];
    [self addChildViewController:contactCV];
    contactCV.view.frame =self.rootScrollView.bounds;
    contactCV.view.left = SCREEN_WIDTH;
    [self.rootScrollView addSubview:contactCV.view];
    
    FRIActiveViewController * activeCV = [[FRIActiveViewController alloc]init];
    [self addChildViewController:activeCV];
    activeCV.view.frame =self.rootScrollView.bounds;
    activeCV.view.left = SCREEN_WIDTH*2;
    [self.rootScrollView addSubview:activeCV.view];
    
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:kSmartDeviceLoginTokenKey];
    if (!token) {
        [self.navigationController pushViewController:[BENLoginViewController new] animated:YES];
    }
    [self addSegment];
}

-(void)addSegment{
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"消息", @"联系人", @"才友圈"]];
      _segmentedControl.frame = CGRectMake((SCREEN_WIDTH-200)/2, iphoneXTop+25, 200, 34);
      _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
      [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
      _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
      _segmentedControl.selectionIndicatorColor = Main_Color;
      _segmentedControl.selectionIndicatorHeight = 2.0;
      _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : Main_Color , NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
      _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont fontWithName:nil size:14.0]};
      _segmentedControl.backgroundColor = [UIColor clearColor];
      [self.customNavBar addSubview:_segmentedControl];
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    [self.rootScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (long)segmentedControl.selectedSegmentIndex, 0) animated:YES];

}

-(UIScrollView*)rootScrollView{
    
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top-iphoneXTab-50)];
        [_rootScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*3, _rootScrollView.height)];
        _rootScrollView.pagingEnabled = YES;
        [self.view addSubview:_rootScrollView];
    }
    
    return  _rootScrollView ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
