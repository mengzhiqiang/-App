//
//  FRIAmusingViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 28/10/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIAmusingViewController.h"
#import "DCSlideshowHeadView.h"
#import "MainCollectionCell.h"
#import "HMSegmentedControl.h"
#import "LMHHomeTableViewController.h"
#import "FRIGameListViewController.h"
#import "SDCycleScrollView.h"
#import "UIButton+Extenxion.h"
#import "GYZChooseCityController.h"
#import "BikeSearchController.h"
#import "TZLocationManager.h"

@interface FRIAmusingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,GYZChooseCityDelegate>
{
    FRIGameListViewController * gameCV ;
    LMHHomeTableViewController * contactCV;
}

@property (strong , nonatomic)UICollectionView *collectionView;

@property(nonatomic ,strong)HMSegmentedControl  * segmentedControl;

@property(nonatomic ,strong)UIScrollView  * rootScrollView;

@property (nonatomic, strong) UIButton *addressBtn;

@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, assign) long  latitude;
@property (nonatomic, assign) long  longitude;


@end

@implementation FRIAmusingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addSegment];
    self.customNavBar.leftButton.hidden = YES;

    
    contactCV = [[LMHHomeTableViewController alloc]init];
    [self addChildViewController:contactCV];
    contactCV.view.frame =self.rootScrollView.bounds;
    [self.rootScrollView addSubview:contactCV.view];
    
    
    gameCV = [[FRIGameListViewController alloc]init];
    [self addChildViewController:gameCV];
    gameCV.view.frame =self.rootScrollView.bounds;
    gameCV.view.left = SCREEN_WIDTH;
    [self.rootScrollView addSubview:gameCV.view];
      
    [self setBaseAttribute];
    
    WS(weakself);
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"nav_btn_search"]];
    [self.customNavBar setOnClickRightButton:^{
        NSLog(@"===搜索==");
        [weakself.navigationController pushViewController:[BikeSearchController new] animated:YES];
    }];
    [self getCurrentCity];
    [self addActiveButton];
}

-(void)addActiveButton{

    UIButton  *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
     [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:addBtn];
    addBtn.frame = CGRectMake(SCREEN_WIDTH-48-15, SCREEN_HEIGHT-48-65-iphoneXTab, 48, 48);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, addBtn.width, addBtn.height)];
    label.text = [NSString stringWithFormat:@"发起\n活动"];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
}

-(UIScrollView*)rootScrollView{
    
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top-iphoneXTab-50)];
        [_rootScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*2, _rootScrollView.height)];
        _rootScrollView.pagingEnabled = YES;
        [self.view addSubview:_rootScrollView];
    }
    
    return  _rootScrollView ;
}
-(void)addSegment{
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"门店", @"广场"]];
      _segmentedControl.frame = CGRectMake((SCREEN_WIDTH-150)/2, iphoneXTop+25, 150, 34);
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

- (UIButton *)addressBtn {
    if (!_addressBtn) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *cityName = [userDefaults objectForKey:@"currentCity"];
        if (!cityName.length) {
            cityName = @"";
        }
        _addressBtn = [UIButton buttonWithTitle:cityName imageName:@"icon_xiala"];
        [_addressBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:15];
        [_addressBtn addTarget:self action:@selector(loactionAction:) forControlEvents:UIControlEventTouchUpInside];
        _addressBtn.backgroundColor = [UIColor clearColor];
        [_addressBtn setTitleColor:Black_Color forState:0];
    }
    return _addressBtn;
}

#pragma mark - 定位
-(void)loactionAction:(UIButton *)sender{
    
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];

    cityPickerVC.hotCitys = @[@"110100", @"310100", @"440100", @"440300", @"440600",@"810100"];
    cityPickerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityPickerVC animated:YES];
}

- (void) setBaseAttribute {
    [self.customNavBar wr_setRightButtonWithImage:UIImageName(@"nav_btn_search_white")];
    [self.customNavBar addSubview:self.addressBtn];
    self.addressBtn.userInteractionEnabled = YES;
    self.customNavBar.userInteractionEnabled = YES;
    [self.view addSubview:self.customNavBar];
    WS(weakself);
    [self.customNavBar setOnClickRightButton:^{
//        BikeSearchController *vc = [BikeSearchController new];
//        vc.type = 1;
//        vc.longitude = self.longitude;
//        vc.latitude = self.latitude;
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.customNavBar).offset(15);
         make.top.mas_equalTo(iphoneXTop+20);
         make.height.mas_equalTo(44);
     }];
}
#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city {
//    [chooseCityBtn setTitle:city.cityName forState:UIControlStateNormal];
    [chooseCityController.navigationController  popViewControllerAnimated:YES];
    [self.addressBtn setTitle:FORMAT(@"%@",city.cityName) forState:0];
    [self.addressBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    self.cityName = city.cityName;
//    self.area = @"";
//    [self getAreaList];
//    [self.tableView.mj_header beginRefreshing];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController {
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)setCityName:(NSString *)cityName{
    _cityName = cityName;
    contactCV.cityName = _cityName;
}
#pragma mark  开启定位
- (void)getCurrentCity {
    
    [MBProgressHUD showActivityIndicator];
    WS(weakself);
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"定位失败，请查看是否开启定位权限"];
    } geocoderBlock:^(NSArray *geocoderArray) {
        [MBProgressHUD hideActivityIndicator];
        CLPlacemark *placemark = [geocoderArray objectAtIndex:0];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *cityName = [userDefaults objectForKey:@"currentCity"];
              if (!cityName.length) {
                  cityName = placemark.locality;
                  self.cityName = placemark.locality;
              }else {
                  self.cityName = cityName;
              }
             
        [self.addressBtn setTitle:FORMAT(@"%@",self.cityName) forState:0];
        [self.addressBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
 
        self.longitude = placemark.location.coordinate.longitude;
        self.latitude = placemark.location.coordinate.latitude;
        
        contactCV.locition = placemark.location.coordinate;
        /*  暂时屏幕数据
     
        [self getStoreList];
        [self getAreaList];
         */
    }];
}



@end
