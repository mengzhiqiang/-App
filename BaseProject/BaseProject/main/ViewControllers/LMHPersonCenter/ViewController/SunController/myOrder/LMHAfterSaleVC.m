//
//  LMHAfterSaleVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAfterSaleVC.h"
#import "HMSegmentedControl.h"
#import "LMHAfterSaleRecordTV.h"
#import "LMHOrderListModel.h"

@interface LMHAfterSaleVC ()
@property (nonatomic, strong) HMSegmentedControl *segment;
@property (nonatomic, strong) UIScrollView *sv;
@property (nonatomic, strong) LMHAfterSaleRecordTV *applyTV;
@property (nonatomic, strong) LMHAfterSaleRecordTV *recordTV;

@property (nonatomic, strong) NSMutableArray * orderArray;

//@property (nonatomic, strong) NSMutableArray  <LMHOrderListModel*> *orderModelArray;


@end

@implementation LMHAfterSaleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"售后";
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"售后申请", @"申请记录"]];
//    segmentedControl.frame = CGRectMake(0, SCREEN_top, SCREEN_WIDTH, 40);
//    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorColor = Main_Color;
    segmentedControl.selectionIndicatorHeight = 2.0;
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : Main_Color};
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : Main_title_Color, NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    segmentedControl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segmentedControl];
    self.segment = segmentedControl;
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(44);
        make.left.right.offset(0);
        make.height.offset(40);
    }];
    
    UIScrollView *sv = [[UIScrollView alloc] init];
    sv.pagingEnabled = YES;
    sv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sv];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segmentedControl.mas_bottom).offset(12);
        make.left.right.bottom.offset(0);
    }];
    self.sv = sv;
    sv.scrollEnabled = NO;
    
    LMHAfterSaleRecordTV *applyTV = [[LMHAfterSaleRecordTV alloc] init];
    [sv addSubview:applyTV];
    [applyTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.width.height.equalTo(sv);
    }];
    applyTV.relaodDataWithIndex = ^(NSInteger index) {
        [self GetAllOrderWithPage:index];
    };
    self.applyTV = applyTV;
    
    LMHAfterSaleRecordTV *recordTV = [[LMHAfterSaleRecordTV alloc] init];
    recordTV.IsRequest = YES;
    [sv addSubview:recordTV];
    [recordTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.width.equalTo(sv);
        make.left.equalTo(applyTV.mas_right);
    }];
    recordTV.relaodDataWithIndex = ^(NSInteger index) {
        [self getAferOrderList];
    };
    self.recordTV = recordTV;
    
//    [self getAferOrderList];
    [self GetAllOrderWithPage:1];
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender {
    [self.sv setContentOffset:CGPointMake(sender.selectedSegmentIndex * SCREEN_WIDTH, 0) animated:YES];
    if (sender.selectedSegmentIndex==1) {
        if (_recordTV.orderArray.count<0 || _recordTV.orderArray==nil) {
            [self getAferOrderList];
        }
    }
    
}

#pragma 获取售后记录
-(void)getAferOrderList{
    NSString *path = [API_HOST stringByAppendingString:client_afterSales_getAfterOrderList];
    NSDictionary * diction = @{@"limit":@"100" , @"page":@(_recordTV.page)};
    WS(weakself);
    [MBProgressHUD showActivityIndicator];
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [weakself.recordTV.mj_header endRefreshing];
        [weakself.recordTV.mj_footer endRefreshing];
        [MBProgressHUD hideActivityIndicator ];
        [self  updataData:responseObject[@"data"] withView:weakself.recordTV];
    } failure:^(NSError *error) {
        [weakself.recordTV.mj_header endRefreshing];
        [weakself.recordTV.mj_footer endRefreshing];
        [MBProgressHUD hideActivityIndicator ];
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code=取消订单====%@",Dic_data);
        [MBProgressHUD showError:Dic_data[@"msg"]];
        
    }];
}

#pragma mark 获取 允许售后的订单
-(void)GetAllOrderWithPage:(NSInteger)page{
    NSString *path = [API_HOST stringByAppendingString:client_order_getAfterOrderList];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setObject:@(10) forKey:@"limit"];
    [diction setObject:@(_applyTV.page) forKey:@"page"];
    [diction setObject:@"0" forKey:@"statue"];
    
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        [weakself.applyTV.mj_header endRefreshing];
        [weakself.applyTV.mj_footer endRefreshing];

        [self  updataData:responseObject[@"data"] withView:weakself.applyTV];

    } failure:^(NSError *error) {
        [weakself.applyTV.mj_header endRefreshing];
        [weakself.applyTV.mj_footer endRefreshing];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"订单=code==%@",Dic_data);
        [MBProgressHUD showError:Dic_data[@"msg"]];
    }];
    
}

-(void)updataData:(NSArray* )array withView:(LMHAfterSaleRecordTV*)table{
    
     NSArray <LMHOrderListModel*>* arrayList =  [LMHOrderListModel mj_objectArrayWithKeyValuesArray:array] ;
    for (int i=0; i<array.count; i++) {
        NSDictionary * diction ;
        NSArray * arrayTB ;
        if (table == _applyTV) {
            diction = [array[i][@"tbOrderSpecifications"] firstObject];
            arrayTB = array[i][@"tbOrderSpecifications"] ;
        }else{
            diction = [array[i][@"tbOrderSpecificationsList"] firstObject];
            arrayTB = array[i][@"tbOrderSpecificationsList"] ;
        }
        LMHOrderbandsModel * bandM= [LMHOrderbandsModel mj_objectWithKeyValues:diction];
        bandM.schedule = array[i][@"schedule"] ;
        arrayList[i].brand = bandM ;
       
        NSDictionary * brandDic = [diction objectForKey:@"brand"];
        arrayList[i].brand.brandLogo = brandDic[@"brandLogo"];
        arrayList[i].brand.brandName = brandDic[@"brandName"];
        
        NSMutableArray* goods = [NSMutableArray arrayWithCapacity:20];
        for (NSDictionary* d  in arrayTB) {
            
            NSDictionary * GoodDic = [d objectForKey:@"goods"];
            NSDictionary * specifiDic = [d objectForKey:@"specifications"];

            NSDictionary * goodDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      GoodDic[@"goodsName"], @"goodsName",
                                      GoodDic[@"pictue"],@"pictue",
                                      specifiDic[@"specificationName"],@"specificationName",
                                      specifiDic[@"sellPrice"],@"sellPrice",
                                      bandM.num,@"num", nil];
            [goods addObject:goodDic];
        }
        arrayList[i].brand.goodInfos = goods;
        
        NSDictionary * GoodDic = [diction objectForKey:@"goods"];
        arrayList[i].brand.goodName = GoodDic[@"goodsName"];
        arrayList[i].brand.goodLogo = GoodDic[@"pictue"];

        NSDictionary * specifiDic = [diction objectForKey:@"specifications"];
        arrayList[i].brand.specificationName = specifiDic[@"specificationName"];
        arrayList[i].brand.sellPrice = specifiDic[@"sellPrice"];
        NSLog(@"===log==url==%@",arrayList[i].brand.url);
    }
    if (array.count<10) {
        [table.mj_footer endRefreshingWithNoMoreData];
    }
    
    if (table.page<1) {
        [table.orderArray addObjectsFromArray:array];
    }else{
        table.orderArray = [NSMutableArray arrayWithArray:arrayList];
    }
}

@end
