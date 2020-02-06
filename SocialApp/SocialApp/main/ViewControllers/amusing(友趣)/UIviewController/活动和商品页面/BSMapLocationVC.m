//
//  BSMapLocationVC.m
//  BikeStore
//
//  Created by wfg on 2019/11/22.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "BSMapLocationVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CustomAnnotationView.h"
@interface BSMapLocationVC ()<MAMapViewDelegate>
@property (nonatomic, strong ) MAMapView *mapView ;

@end

@implementation BSMapLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"商家定位";
    [AMapServices sharedServices].enableHTTPS = YES;
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top)];
    ///把地图添加至view
    [self.view addSubview:_mapView];
    ///如果您需要进入地图就显示定位小蓝点
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.zoomLevel = 16;
    _mapView.showsScale = YES;
    self.mapView.delegate = self;
    
    MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
    anno.coordinate = self.coordinate;
    [self.mapView addAnnotation:anno];
    self.mapView.centerCoordinate = self.coordinate;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.frame = CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top);

}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        //        if (self.centerCoordinate.latitude == annotation.coordinate.latitude &&  self.centerCoordinate.longitude == annotation.coordinate.longitude) {
        annotationView.enabled = NO;
        annotationView.image = [UIImage imageNamed:@"gpsStat2"];
        [annotationView setSelected:NO];
        //        }
        //        else if([ZCBMapTools sharedInstance].location.coordinate.latitude == annotation.coordinate.latitude && [ZCBMapTools sharedInstance].location.coordinate.longitude == annotation.coordinate.longitude) {
        //            annotationView.image = [UIImage imageNamed:@"gpsStat2"];
        //        }
        
        
        return annotationView;
    }
    return nil;
}

@end
