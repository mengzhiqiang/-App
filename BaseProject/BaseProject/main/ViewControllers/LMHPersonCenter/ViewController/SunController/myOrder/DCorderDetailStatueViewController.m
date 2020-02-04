//
//  DCorderDetailViewController.m
//  jiefujia
//
//  Created by zhiqiang meng on 8/4/2019.
//  Copyright © 2019 TeeLab. All rights reserved.
//

#import "DCorderDetailStatueViewController.h"
#import "JFJOrderTableViewCell.h"
#import "FWRAddressTableViewCell.h"
#import "LLRightCell.h"
#import "CustomLowShadowView.h"
#import "LMHAddressModel.h"
#import "LMHOrderListModel.h"
#import "LMHOrderbandsModel.h"
#import "LMHGoodDetailModel.h"
#import "LMHOrderGoodModel.h"
#import "LMHGoodSpecifiaModel.h"

#import "LMHlogisticsViewController.h"
#import "LMHAfterSaleApplyVC.h"
#import "UIAlertController+Simple.h"
#import "WXApiManager.h"
#import "AlipayManager.h"
#import "LMHAfterSaleVC.h"
#import "LMHAfterSaleDetailVC.h"
#import "CustomlowTableView.h"

static NSString *const LLRightCellid = @"LLRightCell";

@interface DCorderDetailStatueViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView *rootTableView;
@property (strong, nonatomic) IBOutlet UIView *headOrderView;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *payAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeOutLabel;

@property (strong, nonatomic) IBOutlet UIView *footOrderView;
@property (weak, nonatomic) IBOutlet UILabel *goodeSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (strong, nonatomic) NSArray * goodsArray;
@property (strong, nonatomic) NSDictionary * goodsPayDiction;

@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStyleLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabael;
@property (weak, nonatomic) IBOutlet UILabel *payTimesLabel;

@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet CustomShadowView *lowView;

@property (strong, nonatomic) LMHAddressModel * addresModel;
@property (strong, nonatomic) LMHOrderListModel * orderModel;

@property (strong, nonatomic) NSMutableArray <LMHOrderGoodModel*> * goodModelArray;
@property (strong, nonatomic) NSMutableArray <LMHGoodSpecifiaModel*> * specifiModeArray;

@property (strong, nonatomic) NSString * stateString;


@property(strong ,nonatomic) CustomlowTableView * lowsSumView ;

//@property (strong, nonatomic) LMHOrderGoodModel * goodModel;
//@property (strong, nonatomic) LMHGoodSpecifiaModel * SpecifiaModel;


@end

@implementation DCorderDetailStatueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"订单详情";
    _goodModelArray = [NSMutableArray arrayWithCapacity:20];
    _specifiModeArray = [NSMutableArray arrayWithCapacity:20];

    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_top-50) style:UITableViewStyleGrouped];
    _rootTableView .frame = CGRectMake(0,  SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_top-50);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rootTableView.sectionHeaderHeight = 0 ;
    _rootTableView.sectionFooterHeight = 0;
    _rootTableView.backgroundColor= Main_BG_Color;
    self.view.backgroundColor=Main_BG_Color;
    [ _rootTableView  registerClass:[LLRightCell class] forCellReuseIdentifier:LLRightCellid];

    [self.view addSubview:_rootTableView];
    
    [_deleteButton draCirlywithColor:Main_Color andRadius:2.5f];
    [_payButton draCirlywithColor:nil andRadius:2.5f];
    

    [_lowView layoutIfNeeded];
    [self.view addSubview:_lowView];
   
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
//    [self setStatusBarBackgroundColor:[UIColor clearColor]];

    [[UINavigationBar appearance] setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self getOrderDetail];
}

-(void)getOrderDetail{
    
    NSString *path = [API_HOST stringByAppendingString:client_order_getOrderDetail];

    NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:self.orderID,@"orderId", nil];
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"=订单信息====%@",responseObject );
        [weakself loadNewUI:JSONDic];
        
        
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code=订单信息====%@",Dic_data);
        [MBProgressHUD  showError:Dic_data[@"msg"]];
    }];
}


-(void)loadNewUI:(NSDictionary*)diction{

    _addresModel = [LMHAddressModel mj_objectWithKeyValues: diction[@"address"]];
    _orderModel = [LMHOrderListModel mj_objectWithKeyValues:diction];
    
    if ([diction[@"tbOrderSpecifications"] count]>0) {
         NSDictionary * dic = [diction[@"tbOrderSpecifications"] firstObject];
           _orderModel.brand = [LMHOrderbandsModel mj_objectWithKeyValues:dic];
           NSDictionary * brans = [dic objectForKey:@"brand"];
           _orderModel.brand.brandLogo = brans[@"brandLogo"];
           _orderModel.brand.brandName = brans[@"brandName"];
           
           if (_goodModelArray.count) {
               [_goodModelArray removeAllObjects];
           }
           if (_specifiModeArray.count) {
               [_specifiModeArray removeAllObjects];
           }
    }
    for (NSDictionary* orderDic in diction[@"tbOrderSpecifications"]) {
       LMHGoodSpecifiaModel *SpecifiaModel = [LMHGoodSpecifiaModel mj_objectWithKeyValues: orderDic[@"specifications"]];
        LMHOrderGoodModel*goodModel     = [LMHOrderGoodModel mj_objectWithKeyValues: orderDic[@"goods"]];
        
        SpecifiaModel.num = orderDic[@"num"];
        
        if (goodModel) {
          [_goodModelArray addObject:goodModel];
        }
        if (SpecifiaModel) {
        [_specifiModeArray addObject:SpecifiaModel];

        }
    }
    
    [self setOrderStatue ];
    
    [_rootTableView reloadData];
}

-(void)setOrderStatue{
    
    switch ([_orderModel.orderStatus intValue]) {
        case 1:
            _stateString = @"待付款";
            
            break;
        case 2:
            _stateString = @"待发货";
            _deleteButton.hidden = YES;
//            [_payButton setTitle:@"取消订单" forState:UIControlStateNormal];
            _payButton.hidden =YES;
            _lowView.hidden = YES;
            _rootTableView .frame = CGRectMake(0,  SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_top);

            break;
        case 3:
            _stateString = @"待收货";
//            _deleteButton.hidden = YES;
            [_deleteButton setTitle:@"申请售后" forState:UIControlStateNormal];
            [_payButton setTitle:@"确认收货" forState:UIControlStateNormal];
            break;
        case 4:
            _stateString = @"已完成";
            [_deleteButton setTitle:@"申请售后" forState:UIControlStateNormal];
            [_payButton setTitle:@"已完成" forState:UIControlStateNormal];

            break;
        case 5:
            _stateString = @"";
            _deleteButton.hidden = YES;
            [_payButton setTitle:@"查看售后" forState:UIControlStateNormal];

            break;
        case 6:
            _stateString = @"已完成";
            [_deleteButton setTitle:@"申请售后" forState:UIControlStateNormal];
            [_payButton setTitle:@"删除订单" forState:UIControlStateNormal];
            _payButton.hidden =YES;
//            _lowView.hidden = YES;
//            _rootTableView .frame = CGRectMake(0,  SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_top);
            break;
        case 7:
            _stateString = @"已取消";
            _deleteButton.hidden = YES;
            [_payButton setTitle:@"删除订单" forState:UIControlStateNormal];
            _payButton.hidden =YES;
                       _lowView.hidden = YES;
                                 _rootTableView .frame = CGRectMake(0,  SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_top);
            break;
        case 8:
            _stateString = @"已取消";
            _deleteButton.hidden = YES;
            [_payButton setTitle:@"删除订单" forState:UIControlStateNormal];
            _payButton.hidden =YES;
            _lowView.hidden = YES;
            _rootTableView .frame = CGRectMake(0,  SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_top);
            break;
        case 10:
            _stateString = @"已完成";
            _deleteButton.hidden = YES;
            [_payButton setTitle:@"删除订单" forState:UIControlStateNormal];
            _payButton.hidden =YES;
            _lowView.hidden = YES;
                      _rootTableView .frame = CGRectMake(0,  SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_top);

            break;
        default:
            break;
    }
}

-(NSString*)time:(NSString*)time{
    if ([time integerValue] == 0) {
        return  @"暂无";
    }
   return   [NSDate timeWithTimeIntervalString:time];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
//            return  1;
            return  (_goodModelArray.count?_goodModelArray.count:1); ;
            break;
        case 2:
            
            if (_orderModel.finishTime) {
                return 5;
            }else  if (_orderModel.takeTime) {
                return 5;
            }else  if (_orderModel.deliveryTime) {
                return 4;
            }else  if (_orderModel.payTime) {
                return 3;
            }
            
            return 2;
            break;
        case 3:
            return 3;
            break;
            
        default:
            break;
    }
    
    return  5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 81 ;
    }else if (indexPath.section==1) {
        return 104 ;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==1) {
        return 70;
    }
    return 10;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * View  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    View.backgroundColor = [UIColor clearColor];
    
    if (section == 1) {
        View.height = 70;
        UIView * Viewbg  = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 59)];
        Viewbg.backgroundColor = [UIColor whiteColor];
        [View addSubview:Viewbg];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        [imageView setImageWithURL:[_orderModel.brand.brandLogo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        [Viewbg addSubview:imageView];
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(65, 10, SCREEN_WIDTH - 65 -15, 40)];
        label.textColor = Main_title_Color;
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = _orderModel.brand.brandName;
        
        [Viewbg addSubview:label];
    }
    
    return View;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0 && _orderModel.logisticsCompany.length>0 && [_orderModel.orderStatus intValue]>=3) {
        return 50;
    }
    return 0.001;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * View  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    View.backgroundColor= Main_BG_Color ;
  
    
    UIView * Viewbg  = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    Viewbg.backgroundColor= White_Color ;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-50, 30)];
    label.textColor = Main_Color;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"查询物流状态";
    [Viewbg addSubview:label];
    
    UIImageView * imagev =[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 13, 7, 13)];
    imagev.image = [UIImage imageNamed:@"grzx_icon_jt_gray"];
    [Viewbg addSubview:imagev];
    
    if (section==0 && _orderModel.logisticsCompany.length>0 && [_orderModel.orderStatus intValue]>=3) {
        [View addSubview:Viewbg];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(queryLogistics)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [Viewbg addGestureRecognizer:tapGestureRecognizer];
        
    }
    return View;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"FWRAddressTableViewCell";
        FWRAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FWRAddressTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.repaceLabel.hidden= YES;
        cell.defaultLabel.hidden = YES;
        cell.editButton.hidden = YES;
        if (_addresModel) {
            cell.addressModel = _addresModel;
        }
        return   cell;
        
    } else   if (indexPath.section==1){
    
    static NSString *CellIdentifier = @"JFJOrderTableViewCell";
    JFJOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JFJOrderTableViewCell" owner:self options:nil] objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
        if (_goodModelArray.count>indexPath.row) {
            
            LMHGoodSpecifiaModel * specModel = _specifiModeArray[indexPath.row];
            LMHOrderGoodModel * goodModel = _goodModelArray[indexPath.row];
            [cell.goodsImageView setImageWithURL:[goodModel.pictue changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
            cell.goodsDetailLabel.text = goodModel.goodsName;
            cell.stateLabel.text = [NSString stringWithFormat:@"%@  x%@",specModel.specificationName,specModel.num];
            cell.priceLabel.text = [NSString stringWithFormat:@"结算价格：¥ %.2f",specModel.sellPrice.floatValue];
            cell.priceLabel.attributedText = [NSString PriceStringWithContent:cell.priceLabel.text andTitle:[NSString stringWithFormat:@"¥ %.2f",specModel.sellPrice.floatValue] color:[UIColor redColor]];
            cell.priceLabel.left = cell.goodsDetailLabel.left;
        }
        
        return   cell;
    }else {
        LLRightCell *cell = [tableView dequeueReusableCellWithIdentifier:LLRightCellid];
        cell.textview.hidden = YES;
        cell.showimage.hidden = YES;
        cell.rightlable.hidden = YES;
        cell.titlelable.width = SCREEN_WIDTH-50;
        [cell.titlelable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(CGFloatBasedI375(15));
            make.width.offset(CGFloatBasedI375(290));
            make.height.offset(CGFloatBasedI375(14));
            make.centerY.equalTo(cell.mas_centerY);
        }];
        if (indexPath.section==2) {
            switch (indexPath.row) {
                case 0:
                    {
                        cell.titlelable.text = [NSString stringWithFormat:@"订单编号:%@",( _orderModel.orderCode? _orderModel.orderCode: _orderModel.orderSn)];

                        cell.rightlable.text = _stateString;
                        cell.rightlable.hidden = NO;
                        cell.rightlable.right = 10;
                        [cell.rightlable mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.right.offset(CGFloatBasedI375(-10));
                            make.width.offset(CGFloatBasedI375(50));
                            make.height.offset(CGFloatBasedI375(14));
                            make.centerY.equalTo(cell.mas_centerY);
                        }];
                        cell.rightlable.textColor =Main_Color;
                    }
                    break;
                case 1:
                {
                    cell.titlelable.text = @"下单时间";
                    cell.titlelable.text = [NSString stringWithFormat:@"下单时间:%@",_orderModel.creatTime];
                }
                    break;
                case 2:
                {
                    cell.titlelable.text = [NSString stringWithFormat:@"支付时间:%@",(_orderModel.payTime?_orderModel.payTime:_orderModel.creatTime)];

                }
                    break;
                case 3:
                {
                    cell.titlelable.text = [NSString stringWithFormat:@"发货时间:%@",_orderModel.deliveryTime];
                }
                    break;
                case 4:
                {
                    cell.titlelable.text = [NSString stringWithFormat:@"收货时间:%@",_orderModel.takeTime];
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            [cell.rightlable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.offset(CGFloatBasedI375(-15));
            }];
            switch (indexPath.row) {
                case 0:
                    {
                        NSString *number = [NSString stringWithFormat:@"%lu",(unsigned long)[_goodModelArray count]];

                        cell.titlelable.text = [NSString stringWithFormat:@"商品总额(%@种)",number];
                        cell.rightlable.text = [NSString stringWithFormat:@"¥%.2f",_orderModel.pricePay.floatValue];
                        cell.rightlable.hidden = NO;
                    }
                    break;
                case 1:
                {
                    cell.titlelable.text = @"运费";
                    cell.rightlable.text = [NSString stringWithFormat:@"¥%.2f",_orderModel.pricePostage.floatValue];
                    cell.rightlable.hidden = NO;

                }
                    break;
                case 2:
                {
                    cell.titlelable.text = @"合计";
                    cell.rightlable.text = [NSString stringWithFormat:@"¥%.2f",[_orderModel.pricePay floatValue]+[_orderModel.pricePostage floatValue]];
                    cell.rightlable.hidden = NO;

                }
                    break;
                    
                default:
                    break;
            }
        }
        
        return cell ;
    }
        
}

-(void)queryLogistics{
    
    LMHlogisticsViewController * LogisticsVC =[[LMHlogisticsViewController alloc]init];
    LogisticsVC.postageSn = _orderModel.postageSn;
    LogisticsVC.logisticsCompany  = _orderModel.logisticsCompany;
    LogisticsVC.logisticsCode  = _orderModel.logisticsCode;
    [self.navigationController pushViewController:LogisticsVC animated:YES];
}

- (IBAction)payOrder:(UIButton *)sender {
    
    switch ([_orderModel.orderStatus intValue]) {
        case 1:
            //支付
//            [self pay:_orderModel.orderSn] ;
            [self.view addSubview:self.lowSumView];
            break;
        case 2:
            //
            [self deleteOrder:nil];
            break;
        case 3:
            //确认收货
            [self submintOrder];
            break;
        case 4:
            //评价 跳转评价
            break;
        case 5:
        {
            LMHAfterSaleVC *vc = [LMHAfterSaleVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:case 7:case 8:case 10:
            //删除订单
            [self removeOrder];
            break;
            
        default:
            break;
    }
    
}

-(CustomlowTableView*)lowSumView{
    WS(weakself);
    if (!_lowsSumView) {
        _lowsSumView = [[CustomlowTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _lowsSumView.hidden = NO;
        _lowsSumView.backPay = ^(NSString * _Nonnull string) {
            if ([string isEqualToString:@"1"]) {
                [weakself pay:self.orderModel];
            }else{
                
            }
            //支付
        };
    }
    _lowView.hidden = NO;
    NSString * sum =   [NSString stringWithFormat:@"%.2f",[[CommonVariable shareCommonVariable] personModel].balance.floatValue] ;
    CGFloat pay = (sum.floatValue>_orderModel.pricePay.floatValue?0:(_orderModel.pricePay.floatValue-sum.floatValue));
       CGFloat balance = (sum.floatValue>_orderModel.pricePay.floatValue?_orderModel.pricePay.floatValue:sum.floatValue);
       _lowsSumView.costDiction = @{@"sum":@(_orderModel.pricePay.floatValue),@"balance":@(balance),@"pay":@(pay)};
       return _lowsSumView ;
//    
//    _lowsSumView.costDiction = @{@"sum":@(_orderModel.pricePay.floatValue),@"balance":sum,@"pay":@(_orderModel.pricePay.floatValue)};
//    return _lowsSumView ;
}

- (IBAction)deleteOrder:(UIButton *)sender {
    
    
    if ([_orderModel.orderStatus intValue]==1 || [_orderModel.orderStatus intValue]==2) {
        [AFAlertViewHelper alertViewWithTitle:@"取消订单" message:@"确认取消此订单？" delegate:self cancelTitle:@"取消" otherTitle:@"确定" clickBlock:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                NSString *path = [API_HOST stringByAppendingString:client_order_cancelOrder];
                NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:_orderModel.identifier,@"orderId", nil];
                WS(weakself);
                [MBProgressHUD showActivityIndicator];
                [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
                    [MBProgressHUD hideActivityIndicator ];
                    [weakself getOrderDetail ];
                } failure:^(NSError *error) {
                    [MBProgressHUD hideActivityIndicator ];
                    NSDictionary *Dic_data = error.userInfo;
                    NSLog(@"code=取消订单====%@",Dic_data);
                    [MBProgressHUD showError:Dic_data[@"msg"]];
                    
                }];
            }
        }];
    }else{
        ///售后
        LMHAfterSaleApplyVC * applyvc =[[LMHAfterSaleApplyVC alloc]init];
        applyvc.model = _orderModel;
        
        NSMutableArray* goods = [NSMutableArray arrayWithCapacity:20];
        for (int i=0 ;i<_specifiModeArray.count;i++) {
                LMHGoodSpecifiaModel * specModel = _specifiModeArray[i];
                LMHOrderGoodModel * goodModel = _goodModelArray[i];
      
                   NSDictionary * goodDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                             goodModel.goodsName, @"goodsName",
                                             goodModel.pictue,@"pictue",
                                             specModel.specificationName,@"specificationName",
                                             specModel.sellPrice,@"sellPrice",
                                             specModel.num,@"num", nil];
                   [goods addObject:goodDic];
        }
        applyvc.model.brand.goodInfos = goods;

        applyvc.model.brand.goodName = [_goodModelArray objectAtIndex:0].goodsName;
        applyvc.model.brand.specificationName = [_specifiModeArray objectAtIndex:0].specificationName;
        applyvc.model.brand.sellPrice = [_specifiModeArray objectAtIndex:0].sellPrice;

        [self.navigationController pushViewController:applyvc animated:YES];
    }
   
}

-(void)removeOrder{
    
    [AFAlertViewHelper alertViewWithTitle:@"删除订单" message:@"确认删除此订单" delegate:self cancelTitle:@"取消" otherTitle:@"确定" clickBlock:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            
            NSString *path = [API_HOST stringByAppendingString:client_order_deleteOrder];
            NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:_orderModel.identifier,@"orderId", nil];
            WS(weakself);
            [MBProgressHUD showActivityIndicator];
            [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
                [MBProgressHUD hideActivityIndicator ];
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [MBProgressHUD hideActivityIndicator ];
                
                NSDictionary *Dic_data = error.userInfo;
                NSLog(@"code=取消订单====%@",Dic_data);
                [MBProgressHUD showError:Dic_data[@"msg"]];
                
            }];
        }
    }];
    
}

-(void)submintOrder{
    
    [AFAlertViewHelper alertViewWithTitle:@"确认收货" message:@"您是否已收到该订单商品" delegate:self cancelTitle:@"未收到" otherTitle:@"已收货" clickBlock:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            NSString *path = [API_HOST stringByAppendingString:client_order_confirmOrder];
            NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:_orderModel.identifier,@"orderId", nil];
            WS(weakself);
            [MBProgressHUD showActivityIndicator];
            [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
                [MBProgressHUD hideActivityIndicator ];
                
                [weakself getOrderDetail ];
            } failure:^(NSError *error) {
                [MBProgressHUD hideActivityIndicator ];
                NSDictionary *Dic_data = error.userInfo;
                NSLog(@"code=取消订单====%@",Dic_data);
                [MBProgressHUD showError:Dic_data[@"msg"]];
                
            }];
            
        }
    }];
    
  
}

#pragma mark  支付
- (void)pay:(LMHOrderListModel*)orderModel{
    UIAlertController *sheet = [UIAlertController showSheetTitles:@[@"微信支付", @"支付宝支付"] titleColor:Main_Color cancelColor:Sub_title_Color backIndex:^(UIAlertAction * _Nonnull UIAlertAction, NSInteger index) {
        if (index == 0) {
            [[WXApiManager sharedManager]requestPayWithOrder:orderModel.orderSn num:orderModel.identifier backResult:^(NSString *result) {
                       [self getOrderDetail];
            }];
        } else if (index == 1) {
            [[AlipayManager sharedManager]requestAliPayWithOrder:orderModel.orderSn  sum:orderModel.identifier backResult:^(NSString *result) {
                        [self getOrderDetail];
            }];
        } else {
            
        }
    }];
    [[UIViewController getCurrentController] presentViewController:sheet animated:YES completion:nil];
}

@end
