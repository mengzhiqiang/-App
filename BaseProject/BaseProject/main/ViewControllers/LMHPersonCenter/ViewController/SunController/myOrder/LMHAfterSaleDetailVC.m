//
//  LMHAfterSaleDetailVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAfterSaleDetailVC.h"
#import "LMHAfterSaleProgressDetailVC.h"
#import "LMHAfterModel.h"
@interface LMHAfterSaleDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *reasonLbl;

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *postalLbl;

@property (strong, nonatomic)  LMHAfterModel  * AfterModel;

@end

@implementation LMHAfterSaleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"退货记录详情";
    self.orderIdLbl.text    = @"订单编号：";
    self.orderTimeLbl.text  = @"申请时间：";
    
    [self submintAfterOrder];
}

- (void)setProgressView {
    NSArray *imgArr = @[@"grzx_icon_sqjlxq_sqjd", @"grzx_icon_sqjlxq_sqsh", @"grzx_icon_sqjlxq_shth", @"grzx_icon_sqjlxq_jxtk", @"grzx_icon_sqjlxq_clwc",];
    NSArray *titleArr =@[@"申请进度",@"申请审核",@"售后退货",@"进行退款",@"处理完成"];
    
    NSMutableArray *timeArr = [NSMutableArray arrayWithObjects:_AfterModel.creatTime,_AfterModel.creatTime, nil];
    int count = 2 ;
    if (_AfterModel.schedule.integerValue >=4) {
        count = 3;
        [timeArr addObject:(_AfterModel.deliveryTime?_AfterModel.deliveryTime:_AfterModel.creatTime)];
    }
    if (_AfterModel.schedule.integerValue >=5) {
        count = 4;
        [timeArr addObject:(_AfterModel.deliveryTime?_AfterModel.deliveryTime:_AfterModel.creatTime) ];
    }
    if (_AfterModel.schedule.integerValue >=6) {
        count = 5;
        [timeArr addObject:(_AfterModel.finishTime?_AfterModel.finishTime:_AfterModel.creatTime)];
        
    }
    
    for (int i = 0; i < 5; i++) {
        BOOL isReady = i ==0 || i == 1;
        switch (_AfterModel.schedule.integerValue) {
            case 4:
                isReady = i <=2;
                break;
            case 5:
                isReady = i <=3;
                break;
            case 6:
                isReady = i <=4;
                break;
            default:
                break;
        }
        
        UIView *view = [UIView new];
        UIImageView *iv = [UIImageView new];
        if (isReady) {
            iv.image = [UIImage imageNamed:[imgArr[i] stringByAppendingString:@"1"]];
        } else {
            iv.image = [UIImage imageNamed:imgArr[i]];
        }

        [view addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(view);
        }];
        
        UILabel *lbl1 = [UILabel new];
        lbl1.textColor = isReady ? Main_Color : [UIColor colorWithHexValue:0x666666];
        lbl1.font = [UIFont systemFontOfSize:11];
        lbl1.text = titleArr[i];
        [view addSubview:lbl1];
        [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(iv.mas_bottom).offset(12);
        }];
        UILabel *lbl2 = [UILabel new];
        lbl2.textColor = [UIColor colorWithHexValue:0x666666];
        lbl2.font = [UIFont systemFontOfSize:9];
        lbl2.numberOfLines = 0;
        lbl2.textAlignment = NSTextAlignmentCenter;
        if (isReady) {
            [view addSubview:lbl2];
            NSString  * sring = [NSString stringWithFormat:@"%@\n%@",[[timeArr objectAtIndex:i] substringToIndex:11],[[timeArr objectAtIndex:i] substringFromIndex:11]];
            lbl2.text = sring;

        }else{
            lbl2.text = @"2019-09-12\n 22:10:09";
            lbl2.textColor = [UIColor clearColor];
            [view addSubview:lbl2];
        }
        [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(view);
            make.top.equalTo(lbl1.mas_bottom);
        }];
        
        [self.progressView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.progressView).multipliedBy((i*2+1)/5.0);
            make.centerY.equalTo(self.progressView);
            make.width.equalTo(self.progressView).multipliedBy(0.2);
        }];
        
        if (i != 0) {
            UIView *line = [UIView new];
            line.backgroundColor = isReady ? Main_Color : [UIColor colorWithHexValue:0xCCCCCC];
            [self.progressView insertSubview:line atIndex:0];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).offset(20);
                make.height.offset(1);
                make.width.equalTo(self.progressView).multipliedBy(0.2);
                make.centerX.equalTo(self.progressView).multipliedBy(i*2/5.0);
            }];
        }
    }
}

- (IBAction)progressDetailAction:(UIButton *)sender {
    LMHAfterSaleProgressDetailVC *vc = [[LMHAfterSaleProgressDetailVC alloc] initWithNibName:@"LMHAfterSaleProgressDetailVC" bundle:[NSBundle mainBundle]];
    vc.AfterModel = _AfterModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 提交售后
-(void)submintAfterOrder{
    NSString *path = [API_HOST stringByAppendingString:client_order_getAfterSalesDetails];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    if (_orderID) {
        [diction setObject:_orderID forKey:@"orderId"];
    }else{
        [MBProgressHUD showError:@"网络异常！，请稍后处理"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        if (responseObject[@"data"]) {
            NSLog(@"=订单==%@",responseObject );
            weakself.AfterModel = [LMHAfterModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [self loadNewDataWithView];
        }
       
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"订单=code==%@",Dic_data);
        [MBProgressHUD showError:Dic_data[@"msg"]];
        
    }];
}

-(void)loadNewDataWithView{
    self.orderIdLbl.text    = [NSString stringWithFormat:@"订单编号：%@",_AfterModel.orderSn];
    self.orderTimeLbl.text  = [NSString stringWithFormat:@"申请时间：%@",_AfterModel.creatTime];
   
    _reasonLbl.text = _AfterModel.cause ;

    [self setProgressView];

    if (_AfterModel.schedule.integerValue>3 ||_AfterModel.schedule.integerValue==2) {
        self.addressLbl.text =[NSString stringWithFormat:@"退货地址：%@",_AfterModel.returnAddress];
        self.postalLbl.text = [NSString stringWithFormat:@"邮政编码：%@",_AfterModel.postcode];
   
    }else if (_AfterModel.schedule.integerValue==3){
        self.addressLbl.text = @"当前状态：卖家已拒绝您的请求";
        self.postalLbl.text = @"理由：无";
    }
    else {
        [self.addressView removeFromSuperview];
        [self.reasonView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.reasonView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.reasonView.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-12]];
    }
    
}

@end
