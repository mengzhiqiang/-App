//
//  LMHAfterSaleProgressDetailVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAfterSaleProgressDetailVC.h"

@interface LMHAfterSaleProgressDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@end

@implementation LMHAfterSaleProgressDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"退货申请进度";
    
    self.orderIdLbl.text    = [NSString stringWithFormat:@"订单编号：%@",_AfterModel.orderSn];
    self.orderTimeLbl.text  = [NSString stringWithFormat:@"申请时间：%@",_AfterModel.creatTime];
    
    [self setProgressView];
}

//1.您的订单已提交申请售后服务。
//2.您的订单提交成功，等待审核。
//3.您的订单已审核通过，请将退货商品快递到退货地址。
//4.您的订单退货成功，已进行退款，退款金额将在1~2个工作日内返还到账户余额。
//5.您的订单退款成功，请注意查收。
- (void)setProgressView {
    NSMutableArray *viewArr = [NSMutableArray array];
    UIView *tempCircle;
    
    NSMutableArray * array = [NSMutableArray arrayWithObjects:@"您的订单提交成功，等待审核。",@"您的订单已提交申请售后服务。", nil];
    NSMutableArray *timeArr = [NSMutableArray arrayWithObjects:_AfterModel.creatTime,_AfterModel.creatTime, nil];

    int count = 2 ;
    if (_AfterModel.schedule.integerValue >=4) {
        count = 3;
        [array insertObject:@"您的订单已审核通过，请将退货商品快递到退货地址。" atIndex:0];
        [timeArr insertObject:(_AfterModel.deliveryTime?_AfterModel.deliveryTime:_AfterModel.creatTime) atIndex:0];
    }
    if (_AfterModel.schedule.integerValue >=5) {
        count = 4;
        [array insertObject:@"您的订单退货成功，已进行退款，退款金额将在1~2个工作日内返还到账户余额。" atIndex:0];
        [timeArr insertObject:(_AfterModel.deliveryTime?_AfterModel.deliveryTime:_AfterModel.creatTime) atIndex:0];
    }
    if (_AfterModel.schedule.integerValue >=6) {
        count = 5;
        [array insertObject:@"您的订单退款成功，请注意查收。" atIndex:0];
        [timeArr insertObject:(_AfterModel.finishTime?_AfterModel.finishTime:_AfterModel.creatTime) atIndex:0];

    }
    for (int i = 0; i < count; i++) {
        BOOL isReady = i ==0 ;

        UIView *view = [UIView new];
        UILabel *lbl1 = [UILabel new];
        lbl1.text = [array objectAtIndex:i];
        lbl1.textColor = isReady ? Main_Color : Main_title_Color;
        lbl1.numberOfLines = 0;
        lbl1.font = [UIFont systemFontOfSize:15];
        [view addSubview:lbl1];
        [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(view);
        }];
        
        UILabel *lbl2 = [UILabel new];
        lbl2.text = _AfterModel.userName;
        lbl2.textColor = [UIColor colorWithHexValue:0x666666];
        lbl2.font = [UIFont systemFontOfSize:13];
        
        [view addSubview:lbl2];
        [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbl1.mas_bottom).offset(10);
            make.left.right.equalTo(view);
        }];
        
        UILabel *lbl3 = [UILabel new];
        lbl3.text = timeArr[i];
        lbl3.textColor = [UIColor colorWithHexValue:0x666666];
        lbl3.font = [UIFont systemFontOfSize:11];
        [view addSubview:lbl3];
        [lbl3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbl2.mas_bottom).offset(0);
            make.left.right.bottom.equalTo(view);
        }];
        
        [self.sv addSubview:view];
        [viewArr addObject:view];
        //左边圆点
        
        UIView *circleView1 = [UIView new];
        circleView1.backgroundColor = [UIColor colorWithHexValue:0xCCCCCC];
        circleView1.layer.cornerRadius = 6;
        [self.sv addSubview:circleView1];
        [circleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lbl1);
            make.width.height.offset(12);
            make.left.offset(14);
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
            [self.sv insertSubview:line atIndex:0];
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
    [viewArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:30 leadSpacing:16 tailSpacing:16];
    [viewArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.right.offset(-16);
        make.width.equalTo(self.sv).offset(-56);
    }];
}

@end
