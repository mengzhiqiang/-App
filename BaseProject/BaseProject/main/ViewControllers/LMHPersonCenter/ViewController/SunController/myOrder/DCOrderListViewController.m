//
//  DCOrderListViewController.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 30/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCOrderListViewController.h"
#import "HMSegmentedControl.h"
#import "JFJorderTabelView.h"
#import "LMHOrderListModel.h"
@interface DCOrderListViewController ()<UIScrollViewDelegate>
{
    HMSegmentedControl * segmentedControl ;
    
    JFJorderTabelView *order_all;
    JFJorderTabelView *order_NoPay;     //未支付
    JFJorderTabelView *order_stayGoods;  //未发货
    JFJorderTabelView *order_deliverGoods;  //已发货
    JFJorderTabelView *order_over;   //已完成

}
@property(strong,nonatomic) UIScrollView * scrollView ;

@property(assign,nonatomic) int  orderStatus ;
@property(assign,nonatomic) int  page ;

@end

@implementation DCOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"我的订单";
    _page = 1 ;
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"待付款",@"待发货",@"待收货", @"已取消"]];
    segmentedControl.frame = CGRectMake(0, SCREEN_top, SCREEN_WIDTH, 40);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorColor = Main_Color;
    segmentedControl.selectionIndicatorHeight = 2.0;
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : Main_Color};
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HexString:@"333333"], NSFontAttributeName : [UIFont fontWithName:nil size:15.0]};
    segmentedControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:segmentedControl ];
        
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat lisTheight = SCREEN_HEIGHT-SCREEN_top -40;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_top+40, SCREEN_WIDTH, lisTheight)];
    self.scrollView.backgroundColor = Main_BG_Color;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, lisTheight);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, 200) animated:NO];
    [self.view addSubview:self.scrollView];
    self.scrollView.scrollEnabled = NO;
    
    order_all = [[JFJorderTabelView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, lisTheight)];
    order_all.orderStyle = @"0";
    [self.scrollView addSubview:order_all];
    
    order_NoPay = [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, lisTheight)];
    order_NoPay.orderStyle = @"1";
    [self.scrollView addSubview:order_NoPay];
    
    order_stayGoods = [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, lisTheight)];
    order_stayGoods.orderStyle = @"2";
    [self.scrollView addSubview:order_stayGoods];
    
    order_deliverGoods = [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, lisTheight)];
    order_deliverGoods.orderStyle = @"3";
    [self.scrollView addSubview:order_deliverGoods];
    
    order_over= [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 4, 0, SCREEN_WIDTH, lisTheight)];
    order_over.orderStyle = @"7";
    [self.scrollView addSubview:order_over];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadUI) name:@"reloadOrderUI" object:nil];
    
    segmentedControl.selectedSegmentIndex = _selectIndex;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _selectIndex, 0) animated:YES];


}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    _selectIndex = segmentedControl.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (long)segmentedControl.selectedSegmentIndex, 0) animated:YES];
    [self loadNewOfStyle:_selectIndex];
}

-(void)loadNewOfStyle:(NSInteger)index{
    switch (index) {
        case 0:
            {
                [order_all GetNewData];
            }
            break;
        case 1:
        {
            [order_NoPay GetNewData];
        }
            break;
        case 2:
        {
            [order_stayGoods GetNewData];
        }
            break;
        case 3:
        {
            [order_deliverGoods GetNewData];
        }
            break;
        case 4:
        {
            [order_over GetNewData];
        }
            break;
        default:
            break;
    }
}

-(void)reloadUI{
    [self GetAllOrder];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_selectIndex==4) {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _selectIndex, 0) animated:YES];

    }
}

#pragma mark 订单
-(void)GetOrderWithStatus:(NSInteger)status{
    NSString *path = [API_HOST stringByAppendingString:client_order_getOrderList];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setObject:@(10) forKey:@"limit"];
    [diction setObject:@(_page) forKey:@"page"];
    [diction setObject:@(status) forKey:@"statue"];

    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
//        NSLog(@"=订单==%@",JSONDic );
        [order_all updataData:JSONDic tagre:self];

    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"订单=code==%@",Dic_data);
        [MBProgressHUD showError:Dic_data[@"msg"]];

    }];
    
}

-(void)GetAllOrderWithStatus:(NSInteger)status{

    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    _selectIndex = page;

    [segmentedControl setSelectedSegmentIndex:page animated:YES];
    [self loadNewOfStyle:_selectIndex];

}


-(void)loadUIViewOrder:(NSArray*)orderArray{
    
    
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
