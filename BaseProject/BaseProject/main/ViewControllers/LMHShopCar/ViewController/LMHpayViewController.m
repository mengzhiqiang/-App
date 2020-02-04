//
//  LMHpayViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 30/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHpayViewController.h"
#import "FWRAddressTableViewCell.h"
#import "FWRAddressTableViewCell.h"
#import "LLRightCell.h"
#import "CustomLowShadowView.h"
#import "CustomlowTableView.h"
#import "UIAlertController+Simple.h"
#import "WXApiManager.h"
#import "AlipayManager.h"
#import "DCOrderListViewController.h"
#import "LMHPersonCenterModel.h"

static NSString *const LLRightCellid = @"LLRightCell";

@interface LMHpayViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *rootTableView;

@property (strong, nonatomic)  CustomLowShadowView *lowView;

@property (strong, nonatomic)  CustomlowTableView *lowSumView;

@property (assign, nonatomic)  CGFloat  sumCost;
@property (assign, nonatomic)  CGFloat  carprice;
@property (assign, nonatomic)  CGFloat  allCost;

@property (strong, nonatomic)  NSString  * orderID;

@property (assign, nonatomic)  float       postPrice;
@property (assign, nonatomic)  NSInteger   orderNumber;
@property (assign, nonatomic)  NSInteger   goodNumber;

@property (strong, nonatomic)  LMHPersonCenterModel  *AccountModel;


@end

@implementation LMHpayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"订单详情";
    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT -SCREEN_top) style:UITableViewStylePlain];
    _rootTableView .frame = CGRectMake(0,  SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_top);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.sectionHeaderHeight = 10.0f;
    _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rootTableView.backgroundColor= Main_BG_Color;
    self.view.backgroundColor=Main_BG_Color;
    [ _rootTableView  registerClass:[LLRightCell class] forCellReuseIdentifier:LLRightCellid];
    
    [self.view addSubview:_rootTableView];
    [self.view addSubview:self.lowView];
    
    [self  getcarCost];
    [self selectSum];
    [self getcarnumber];
    [self getAccountInfo];
}

#pragma mark 计算总额
-(void)selectSum{
    
    float  sumPrice = 0 ;
    int  selctCount = 0;
    for (DCShopModel* shop in _buyList) {
        
        for (DCShopCarModel * model in shop.data) {
            if (model.isSelect) {
                sumPrice = (float)[model.price floatValue]*[model.num intValue]+sumPrice;
                _goodNumber =  _goodNumber + model.num.integerValue;
            }
        }
    }
    
    _sumCost = sumPrice;
    
    for (DCShopModel* shop in _buyList) {
        
        for (DCShopCarModel * model in shop.data) {
            if (model.isSelect) {
                selctCount++;
                break;
            }
        }
    }
//    _carprice = selctCount * 10;r
    _allCost = _sumCost + 0.0;
    self.lowView.titleLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allCost];

    [_rootTableView reloadData];
}

-(CustomLowShadowView*)lowView{
    if (!_lowView) {
        _lowView = [[CustomLowShadowView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _lowView.buyingClickBlock = ^{
            [self submintOrder ] ;
        };
    }
    return _lowView;
}

-(CustomlowTableView*)lowSumView{
    if (!_lowSumView) {
        _lowSumView = [[CustomlowTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _lowSumView.hidden = NO;
        _lowSumView.backPay = ^(NSString * _Nonnull string) {
            if ([string isEqualToString:@"1"]) {
                [self pay];
            }else{
                [self alertPayView];
            }
            //支付
        };
    }
    _lowSumView.hidden = NO;
    NSLog(@"--balance---%@",self.AccountModel.balance);
    NSString * sum =   [NSString stringWithFormat:@"%.2f",self.AccountModel.balance.floatValue] ;
    
    CGFloat pay = (sum.floatValue>self.allCost?0:(_allCost-sum.floatValue));
    
    CGFloat balance = (sum.floatValue>self.allCost?_allCost:sum.floatValue);

    _lowSumView.costDiction = @{@"sum":@(self.allCost),@"balance":@(balance),@"pay":@(pay)};
    return _lowSumView ;
}

-(void)alertPayView
{
    [AFAlertViewHelper alertViewWithTitle:@"订单未支付" message:@"订单未支付，确认离开后可以在我的订单中继续完成支付" delegate:self cancelTitle:@"确认离开" otherTitle:@"继续支付" clickBlock:^(NSInteger buttonIndex) {
        if (buttonIndex==0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
             [self pay];
        }
    }];
}
#pragma mark  支付
- (void)pay{
    UIAlertController *sheet = [UIAlertController showSheetTitles:@[@"微信支付", @"支付宝支付"] titleColor:Main_Color cancelColor:Sub_title_Color backIndex:^(UIAlertAction * _Nonnull UIAlertAction, NSInteger index) {
        if (index == 0) {
            [[WXApiManager sharedManager]requestPayWithOrder:self.orderID num:nil backResult:^(NSString *result) {
                [self pushOrederListvc];
            }];
        } else if (index == 1) {
            [[AlipayManager sharedManager]requestAliPayWithOrder:self.orderID  sum:nil backResult:^(NSString *result) {
                [self pushOrederListvc];
            }];
        } else {
            
        }
    }];
    [self presentViewController:sheet animated:YES completion:nil];
}

-(void)pushOrederListvc{
    
    UIViewController * viewVC = self.navigationController.viewControllers.firstObject;

    DCOrderListViewController * orderVC =[[DCOrderListViewController alloc]init];
    orderVC.selectIndex =  0;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [viewVC.navigationController pushViewController:orderVC animated:YES];
}
#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        default:
            break;
    }
    
    return  3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  10.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [UIView new];
    view.backgroundColor = Main_BG_Color;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 81;
    }
    return 44 ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"FWRAddressTableViewCell";
        FWRAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FWRAddressTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.editButton.hidden = YES;
        cell.repaceLabel.hidden  = YES;
        cell.defaultLabel.hidden = YES ;
        if (self.addressModel) {
            cell.addressModel = self.addressModel;
        }
        return   cell;
        
    } else{
        
        LLRightCell *cell = [tableView dequeueReusableCellWithIdentifier:LLRightCellid];
        cell.textview.hidden = YES;
        cell.showimage.hidden = YES;
        cell.rightlable.hidden = NO;
        cell.rightlable.textColor = Main_Color;
        switch (indexPath.row) {
            case 0:
            {
                cell.titlelable.text = [NSString stringWithFormat:@"商品总额(%ld件)",(long)_goodNumber];
                cell.rightlable.text = [NSString stringWithFormat:@"¥%0.2f",_sumCost];
            }
                break;
            case 1:
            {
                cell.titlelable.text = @"运费";
                cell.rightlable.text = [NSString stringWithFormat:@"¥%0.2f",_carprice];
            }
                break;
            case 2:
            {
                cell.titlelable.text = @"应付总额";
                cell.rightlable.text = [NSString stringWithFormat:@"¥%0.2f",_allCost];
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
        
        
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if(self.rootTableView.contentOffset.y<=sectionHeaderHeight&&self.rootTableView.contentOffset.y>=0) {
        self.rootTableView.contentInset =  UIEdgeInsetsMake(-self.rootTableView.contentOffset.y, 0, 0, 0);
        
    }else if(self.rootTableView.contentOffset.y>=sectionHeaderHeight) {
        self.rootTableView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(NSString*)loadCarId{
    
    NSString * string = @"";
    for (DCShopModel * model in _buyList) {
        
        DCShopModel * shopModel= model;
        for (DCShopCarModel* carModel in shopModel.data) {
            if (carModel.isSelect) {
                if (string.length<1) {
                    string = carModel.identifier;
                }else{
                    string = [NSString stringWithFormat:@"%@,%@",string,carModel.identifier];

                }
            }
        }
    }
    return string;
}

#pragma mark 提交订单
-(void)submintOrder{
    
    NSString *path = [API_HOST stringByAppendingString:client_order_submitOrder];
    NSMutableDictionary* diction = [NSMutableDictionary dictionaryWithCapacity:20];
    
    [diction setObject:(_addressModel.identifier?_addressModel.identifier:@"") forKey:@"addressId"];
    [diction setObject:[self loadCarId] forKey:@"cartId"];
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        
        self.orderID = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"msg==%@",responseObject[@"msg"]);
        if (self.orderID) {
            UIWindow * win = [UIApplication sharedApplication].delegate.window;
            [win addSubview: self.lowSumView];
        }
    
    } failure:^(NSError *error) {
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"msg==%@",Dic_data[@"msg"]);
        
        
    }];
    
}

#pragma mark 获取运费
-(void)getcarnumber{
    
    NSString *path = [API_HOST stringByAppendingString:client_order_getOrderCount];
    NSDictionary * diction =@{@"cartIds":[self loadCarId]};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         weakself.orderNumber = [[(NSDictionary *)responseObject objectForKey:@"data"]integerValue] ;
        
        weakself.carprice =  weakself.orderNumber* weakself.postPrice;
        weakself.allCost = weakself.sumCost + weakself.carprice;
        weakself.lowView.titleLabel.text = [NSString stringWithFormat:@"¥%.2f",weakself.allCost];
        [weakself.rootTableView reloadData];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code==%@",Dic_data);
        
    }];
    
}
-(void)getcarCost{
    
    NSString *path = [API_HOST stringByAppendingString:client_order_getPostage];
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:nil isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        weakself.postPrice = [[(NSDictionary *)responseObject objectForKey:@"data"][@"price"]  floatValue] ;
        weakself.carprice =  weakself.postPrice * weakself.orderNumber ;
        weakself.allCost = weakself.sumCost + weakself.carprice;
        weakself.lowView.titleLabel.text = [NSString stringWithFormat:@"¥%.2f",weakself.allCost];
        [weakself.rootTableView reloadData];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code==%@",Dic_data);
        
    }];
    
}

#pragma mark 刷新账号信息
-(void)getAccountInfo{
    
    if ([CommonVariable getUserInfo].userId) {
        NSString * url = [API_HOST stringByAppendingString:client_userManager_getPersonalCenter];
        WS(weakself);
        [HttpEngine requestPostWithURL:url params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"data"]allKeys].count<1) {
                return ;
            }
            
            LMHPersonCenterModel * model  = [LMHPersonCenterModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            weakself.AccountModel = model;

            NSLog(@"--balance---%@",self.AccountModel.balance);

        } failure:^(NSError *error) {
            
            
        }];
    }
    
}

@end
