//
//  JFJorderTabelView.m
//  jiefujia
//
//  Created by zhiqiang meng on 22/3/2019.
//  Copyright © 2019 TeeLab. All rights reserved.
//

#import "JFJorderTabelView.h"
#import "JFJOrderTableViewCell.h"
#import "LMHOrderListModel.h"
#import "DCorderDetailStatueViewController.h"
#import "WXApi.h"
#import "LMHOrderbandsModel.h"
#import "UIAlertController+Simple.h"
#import "WXApiManager.h"
#import "AlipayManager.h"
#import "CustomlowTableView.h"
@interface JFJorderTabelView()<UITableViewDataSource,UITableViewDelegate>

@property(strong ,nonatomic) UIViewController * controller ;

@property(strong ,nonatomic) NSMutableArray<LMHOrderListModel*>* data ;

@property(strong ,nonatomic) LMHOrderListModel * orderModel ;

@property(assign ,nonatomic) NSInteger  page ;
@property(strong ,nonatomic) CustomlowTableView * lowView ;


@end

@implementation JFJorderTabelView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor HexString:@"f2f2f2"];
        self.delegate =self;
        self.dataSource =self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.separatorInset = UIEdgeInsetsMake(10, 0, 0, 0);
        self.page = 1;
        WS(weakself);
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.page = 1;
            [weakself GetAllOrder];
            [weakself.mj_footer resetNoMoreData];

        }];
        
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakself.page++;
            [weakself GetAllOrder];
        }];
        self.data = [NSMutableArray arrayWithCapacity:200];

    }
    return self;
}


-(void)setOrderStyle:(NSString *)orderStyle{
    _orderStyle = orderStyle ;
    [self GetAllOrder];
}
-(void)GetNewData{
    self.page = 1;
    [self GetAllOrder];
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 ;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 145;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"manageTableViewCell";
    
    JFJOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JFJOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
  
    cell.orderTimeLabel.hidden = NO;

    if (self.data.count > indexPath.row) {
        LMHOrderListModel*orderM = [self.data objectAtIndex:indexPath.section];
        cell.orderTimeLabel.text = ( orderM.orderCode? orderM.orderCode: orderM.orderSn);
        cell.goodeTitleLabel.text = orderM.brand.brandName;
        cell.orderSumLabel.text = [NSString stringWithFormat:@"共%@种商品 合计：¥ %.2f",orderM.brand.num,orderM.pricePay.floatValue];;
        
        cell.orderSumLabel.attributedText = [NSString PriceStringWithContent:cell.orderSumLabel.text andTitle:[NSString stringWithFormat:@"¥ %.2f",orderM.pricePay.floatValue] color:[UIColor redColor]];
        
        [cell.oredreImageView setImageWithURL:[orderM.brand.brandLogo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        int status = [orderM.orderStatus intValue];

        [cell.payButton setTitle:@"已支付" forState:UIControlStateNormal];
        cell.sumCostLabel.hidden= NO;
        cell.payButton.hidden = NO;
        cell.orderStatusLabel.hidden = NO;
        switch (status) {
            case 5:
                {
                    cell.orderStatusLabel.text = @"退货退款";
                }
                break;
            case 1:
            {
                cell.orderStatusLabel.text = @"待付款";
                cell.payButton.hidden = NO;
                [cell.payButton setTitle:@"去支付" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                cell.orderStatusLabel.text = @"待发货";
//                [cell.payButton setTitle:@"取消订单" forState:UIControlStateNormal];
                cell.payButton.hidden = YES;
            }
                break;
            case 3:
            {
                cell.orderStatusLabel.text = @"待收货";
                [cell.payButton setTitle:@"确认收货" forState:UIControlStateNormal];
            }
                break;
            case 4:
            {
                cell.orderStatusLabel.text = @"已完成";
                [cell.payButton setTitle:@"已完成" forState:UIControlStateNormal];
            }
                break;
            case 6:
            {
                cell.orderStatusLabel.text = @"已完成";
                [cell.payButton setTitle:@"删除订单" forState:UIControlStateNormal];
                cell.payButton.hidden = YES;

            }
                break;
            case 7:
            {
                cell.orderStatusLabel.text = @"已取消";
                [cell.payButton setTitle:@"删除订单" forState:UIControlStateNormal];
                cell.payButton.hidden = YES;

            }
                break;
            case 8:
            {
                cell.orderStatusLabel.text = @"已取消";   ///超时自动取消
                [cell.payButton setTitle:@"删除订单" forState:UIControlStateNormal];
                cell.payButton.hidden = YES;

            }
                break;
            case 10:
            {
                cell.orderStatusLabel.text = @"已完成";   ///
                cell.payButton.hidden = YES;
                [cell.payButton setTitle:@"删除订单" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        
    }
    WS(weakself);
    cell.backSelect = ^(NSString * _Nonnull style) {
        weakself.orderModel = [self.data objectAtIndex:indexPath.section];
        
        switch ([weakself.orderModel.orderStatus intValue]) {
            case 1:
                {
//                   [self deleteOrderWithRow:indexPath.section];
                    [[UIViewController getCurrentController].view addSubview:self.lowSumView];
//                    [self pay:weakself.orderModel.orderSn];
                    
                }
                break;
            case 2:
            {
                [self deleteOrder];
            }
                break;
            case 3:
            {
                [self submintOrder];
            }
                break;
            case 4:
            {  ///评价
               
            }
                break;
            case 6:   case 7: case 8: case 10:
            {
                [self removeOrder];
            }
                break;
            default:
                break;
        }

        
    };
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view =[[UIView alloc]init];
    view.backgroundColor = Main_BG_Color;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMHOrderListModel*orderM = [self.data objectAtIndex:indexPath.section];
    
    DCorderDetailStatueViewController* statueVC =[[DCorderDetailStatueViewController alloc]init];
    statueVC.orderID = orderM.identifier;
    [[UIViewController getCurrentController].navigationController pushViewController:statueVC animated:YES];

    
}

-(CustomlowTableView*)lowSumView{
    WS(weakself);
    if (!_lowView) {
        _lowView = [[CustomlowTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _lowView.hidden = NO;
        _lowView.backPay = ^(NSString * _Nonnull string) {
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
     _lowView.costDiction = @{@"sum":@(_orderModel.pricePay.floatValue),@"balance":@(balance),@"pay":@(pay)};
     return _lowView ;

}

#pragma  mark
-(void)GetAllOrder{
    NSString *path = [API_HOST stringByAppendingString:client_order_getOrderList];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];

    [diction setObject:@(10) forKey:@"limit"];
    [diction setObject:@(_page) forKey:@"page"];
    [diction setObject:_orderStyle forKey:@"statue"];
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        [weakself updataData:JSONDic];
  
    } failure:^(NSError *error) {
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"订单=code==%@",Dic_data);
        [MBProgressHUD showError:Dic_data[@"msg"]];
        
    }];
    
}

#pragma mark  支付
- (void)pay:(LMHOrderListModel*)orderModel{
    UIAlertController *sheet = [UIAlertController showSheetTitles:@[@"微信支付", @"支付宝支付"] titleColor:Main_Color cancelColor:Sub_title_Color backIndex:^(UIAlertAction * _Nonnull UIAlertAction, NSInteger index) {
        if (index == 0) {
            [[WXApiManager sharedManager]requestPayWithOrder:orderModel.orderSn num:orderModel.identifier backResult:^(NSString *result) {
//                [self pushOrederListvc];
            }];
        } else if (index == 1) {
            [[AlipayManager sharedManager]requestAliPayWithOrder:orderModel.orderSn  sum:orderModel.identifier backResult:^(NSString *result) {
//                [self pushOrederListvc];
            }];
        } else {
            
        }
    }];
    [[UIViewController getCurrentController] presentViewController:sheet animated:YES completion:nil];
}

-(void)updataData:(NSArray* )array{

    if (array.count<10) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    NSMutableArray<LMHOrderListModel*>* arrayModels =  [LMHOrderListModel mj_objectArrayWithKeyValuesArray:array] ;
    for (int i=0; i<array.count; i++) {
        NSArray * arr = array[i][@"tbOrderSpecifications"];
        NSDictionary * diction = [arr firstObject];
        arrayModels[i].brand = [LMHOrderbandsModel mj_objectWithKeyValues:diction];
        NSDictionary * dic = [diction objectForKey:@"brand"];
        arrayModels[i].brand.brandLogo = dic[@"brandLogo"];
        arrayModels[i].brand.brandName = dic[@"brandName"];
        arrayModels[i].brand.num = [NSString stringWithFormat:@"%lu",(unsigned long)[arr count]];
    }
    
    if (_page>1) {
        [self.data addObjectsFromArray:arrayModels];;
    }else{
        self.data = arrayModels;
    }
    
    [self reloadData];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if(self.contentOffset.y<=sectionHeaderHeight&&self.contentOffset.y>=0) {
        self.contentInset =  UIEdgeInsetsMake(-self.contentOffset.y,0,0,0);
        
    }else if(self.contentOffset.y>=sectionHeaderHeight) {
        self.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight,0,0,0);
    }
}

- (IBAction)deleteOrder{
    
    [AFAlertViewHelper alertViewWithTitle:nil message:@"是否确认取消该订单" delegate:self cancelTitle:@"不取消" otherTitle:@"确定" clickBlock:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            
            NSString *path = [API_HOST stringByAppendingString:client_order_cancelOrder];
            NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:_orderModel.identifier,@"orderId", nil];
            WS(weakself);
            [MBProgressHUD showActivityIndicator];
            [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
                [MBProgressHUD hideActivityIndicator ];
                [weakself.mj_header beginRefreshing];
            } failure:^(NSError *error) {
                [MBProgressHUD hideActivityIndicator ];
                
                NSDictionary *Dic_data = error.userInfo;
                NSLog(@"code=取消订单====%@",Dic_data);
                [MBProgressHUD showError:Dic_data[@"msg"]];
                
            }];
        }
       }];
        
    
    
    
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
                [self.mj_header beginRefreshing];
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
                   
                   [self.mj_header beginRefreshing];
               } failure:^(NSError *error) {
                   [MBProgressHUD hideActivityIndicator ];
                   NSDictionary *Dic_data = error.userInfo;
                   NSLog(@"code=取消订单====%@",Dic_data);
                   [MBProgressHUD showError:Dic_data[@"msg"]];
                   
               }];
           }
       }];
    
  
}


@end
