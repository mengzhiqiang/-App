//
//  LMHlogisticsViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 8/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHlogisticsViewController.h"
#import "LMHPostModel.h"

@interface LMHlogisticsViewController ()
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) NSArray <LMHPostModel*> * arary;

@end

@implementation LMHlogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"物流信息";
    _rootView.top = SCREEN_top;
    _rootView.width = SCREEN_HEIGHT - SCREEN_top;

//    [self loadUIWithLogisticsData];
    self.nameLabel.text = [NSString stringWithFormat:@"%@:%@",_logisticsCompany,self.postageSn];

    [self GetlogisticsInfo];
}

-(void)loadUIWithLogisticsData{
    
    NSMutableArray *viewArr = [NSMutableArray array];
    UIView *tempCircle;
    for (int i = 0; i < _arary.count; i++) {
        BOOL isReady = i==0;
        LMHPostModel * model = _arary[i];
        UIView *view = [UIView new];
        UILabel *lbl1 = [UILabel new];
        lbl1.text = model.context;
        lbl1.textColor = isReady ? Main_Color : Main_title_Color;
        lbl1.font = [UIFont systemFontOfSize:12];
        lbl1.numberOfLines = 0 ;
        [view addSubview:lbl1];
        [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(view);
            make.right.offset(-300);

            make.left.offset(100);

        }];
        
        UILabel *lbl2 = [UILabel new];
        lbl2.text = [NSString stringWithFormat:@"%@ \n%@",[model.time substringToIndex:10],[model.time substringFromIndex:11]];
        lbl2.textColor = [UIColor colorWithHexValue:0x666666];
        lbl2.font = [UIFont systemFontOfSize:12];
        lbl2.numberOfLines = 0 ;
        lbl2.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lbl2];
        [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbl1);
            make.left.offset(5);
        }];
        
        [self.scrollView addSubview:view];
        [viewArr addObject:view];
        //左边圆点
        
        UIView *circleView1 = [UIView new];
        circleView1.backgroundColor = [UIColor colorWithHexValue:0xCCCCCC];
        circleView1.layer.cornerRadius = 6;
        [self.scrollView addSubview:circleView1];
        [circleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lbl1);
            make.width.height.offset(12);
            make.left.offset(95);
        }];
        
        UIView *circleView2 = [UIView new];
        circleView2.backgroundColor = isReady ? Main_Color : Sub_title_Color;
        circleView2.layer.cornerRadius = 4;
        [circleView1 addSubview:circleView2];
        [circleView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(circleView1);
            make.width.height.offset(8);
        }];
        
        if (i != 0) {
            UIView *line = [UIView new];
            line.backgroundColor = isReady ? Main_Color : [UIColor colorWithHexValue:0xCCCCCC];
            [self.scrollView insertSubview:line atIndex:0];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(1);
                make.centerX.equalTo(circleView1);
                //                make.height.offset(40);
                make.bottom.equalTo(circleView1.mas_top);
                make.top.equalTo(tempCircle.mas_bottom);
            }];
        }
        tempCircle = circleView1;
    }
    [viewArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:80 leadSpacing:16 tailSpacing:16];
    [viewArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-26);
        make.width.equalTo(self.scrollView).offset((iPhone6plus?-100:(IS_X_?-150:36)));
        make.width.equalTo(self.scrollView).offset(36);

    }];
}

#pragma mark 订单
-(void)GetlogisticsInfo{
    
    NSString *path = [API_LogisticsInfo_HOST stringByAppendingString:gt100_getLogisticsInfo];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setObject:self.logisticsCode forKey:@"com"];
    [diction setObject:self.postageSn forKey:@"num"];

    
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;

        if (JSONDic[@"data"]) {
            weakself.arary = [LMHPostModel mj_objectArrayWithKeyValuesArray:JSONDic[@"data"]];
            [self loadUIWithLogisticsData];
        } else if (JSONDic[@"message"]) {
            [MBProgressHUD showError:JSONDic[@"message"]];
        }
        else{
            [MBProgressHUD showError:@"没有查询到物流信息"];

        }
       
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"订单=code==%@",Dic_data);
        [MBProgressHUD showError:Dic_data[@"msg"]];
        
    }];
    
}
@end
