//
//  LMHShopCarViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 28/6/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHShopCarViewController.h"

// Views
#import "DCEmptyCartView.h"
#import "DCShopCarTableViewCell.h"
#import "FWRAddressTableViewCell.h"
// Vendors
#import <MJExtension.h>

// vc
#import "FRMAddressViewController.h"
#import "LMHpayViewController.h"
// Others
#import "DCShopCar.h"
#import "CustomShadowView.h"
@interface LMHShopCarViewController() <UITableViewDataSource , UITableViewDelegate >
{
    DCShopCar * shopCarModel ;
    DCEmptyCartView *emptyCartView ;
   
}


/* 通知 */
@property (weak ,nonatomic) id dcObserve;

@property (strong, nonatomic) IBOutlet UITableView *rootTableView;


@property (assign ,nonatomic) BOOL isSelectAll;
@property (assign ,nonatomic) NSInteger countAll;


@property (strong, nonatomic)  UILabel *selectCountLabel;
@property (strong, nonatomic)  UILabel *sumLabel;
@property (strong, nonatomic)  CustomShadowView *sumView;
@property (strong, nonatomic)  UIButton *selectAllButton;
@property (strong, nonatomic)  UIButton *ComintButton;
@property (strong, nonatomic)   FRMAddressViewController * addressVC ;

@property (assign, nonatomic)  int  page;

@end

@implementation LMHShopCarViewController

-(CustomShadowView*)sumView{
    if (!_sumView) {
        _sumView = [[CustomShadowView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-iphoneXTab-49-50, SCREEN_WIDTH, 49)];
        _sumView.backgroundColor = White_Color;
        [_sumView addSubview:self.selectAllButton ];
        [_sumView addSubview:self.sumLabel ];
        [_sumView addSubview:self.ComintButton ];
        [self.view addSubview:_sumView ];

    }
    return _sumView ;
}

-(UILabel*) sumLabel{
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-200-90, 0, 200, 49)];
        _sumLabel.textColor = Main_Color;
        _sumLabel.textAlignment = NSTextAlignmentRight;
        _sumLabel.text = @"合计：¥668.00";
        _sumLabel.font = PFR14Font;
    }
    return _sumLabel;
}
-(UIButton*)ComintButton{
    if (!_ComintButton) {
        _ComintButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ComintButton.frame = CGRectMake(SCREEN_WIDTH-84, 0, 84, 49);
        [_ComintButton setTitle:@"去下单" forState:UIControlStateNormal];
        _ComintButton.titleLabel.font = PFR14Font;
        [_ComintButton setTitleColor:White_Color forState:UIControlStateNormal];
        _ComintButton.backgroundColor = Main_Color ;
        [_ComintButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ComintButton;
}

-(UIButton*)selectAllButton{
    if (!_selectAllButton) {
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllButton.frame = CGRectMake(15, 0, 84, 49);
        [_selectAllButton setTitle:@" 已选(0)" forState:UIControlStateNormal];
        _selectAllButton.titleLabel.font = PFR14Font;
        [_selectAllButton setImage:[UIImage imageNamed:@"gwc_icon_xjdz_swmrdz1"] forState:UIControlStateNormal];
        [_selectAllButton setTitleColor:Main_Color forState:UIControlStateNormal];
        [_selectAllButton addTarget:self action:@selector(selectAllGood:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAllButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"购物车";
    _isSelectAll = YES ;
    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStyleGrouped];
    _rootTableView .frame = CGRectMake(0,  DCTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT- DCTopNavH - 50-iphoneXTab-49);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.backgroundColor=Main_BG_Color;
    _rootTableView.sectionHeaderHeight = 16 ;
    _rootTableView.sectionFooterHeight = 0;
    _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_rootTableView];
    
    [self.view addSubview:_sumView];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (@available(iOS 11.0, *)) {
        _rootTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    WS(weakself);
    self.rootTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 1;
        [weakself getallShopCars];
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getallShopCars ];
//    [self getAddressList];
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultAddress"];
    
    if ([dic isKindOfClass:[NSString class]] || [dic isEqual:@"Newlogin"]) {
            
        self.addressVC.addressModel = nil ;
      }else{
               if (self.addressVC.IsCarSelect) {
                    
                }else{
                    self.addressVC.addressModel = nil ;
                    if (dic) {
                    self.addressVC.addressModel = [LMHAddressModel mj_objectWithKeyValues:dic];
                   }
                   
        }
      }
    
    
  
   
    shopCarModel = [DCShopCar sharedDataBase];
    [_rootTableView reloadData];
    
    [self selectSum ];
    
    if (!(shopCarModel.carList.count>0)) {
        [self setUpEmptyCartView];
        self.sumView.hidden = YES;
        _rootTableView.hidden = YES;
    }else{
        [self.view addSubview:_rootTableView];
        self.sumView.hidden = NO;
        _rootTableView.hidden = NO;
    }
    

}

#pragma mark - 初始化空购物车View
- (void)setUpEmptyCartView
{
    if (!emptyCartView) {
        emptyCartView = [[DCEmptyCartView alloc] init];
        emptyCartView.frame = CGRectMake(0, DCTopNavH, SCREEN_WIDTH, 400);
        emptyCartView.buyingClickBlock = ^{
            NSLog(@"点击了立即抢购");
            self.navigationController.tabBarController.selectedIndex = 0;
        };
    }
    emptyCartView.hidden = NO;
    [self.view addSubview:emptyCartView];
    
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1 ;
    }
    if (shopCarModel.carList.count+1>section) {
        return  [shopCarModel.carList objectAtIndex:section-1].data.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return shopCarModel.carList.count+1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 ) {
        if (self.addressVC.addressModel) {
            return 81 ;
        }
        return 40 ;
    }
    return 104;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 ) {
        return 10.01 ;
    }
    return 70.0;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
      if (indexPath.section==0) {
        static NSString *CellIdentifier = @"FWRAddressTableViewCell";
        FWRAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FWRAddressTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
          
          [cell.editButton setImage:[UIImage imageNamed:@"grzx_icon_jt_gray"] forState:UIControlStateNormal];
          cell.editButton.userInteractionEnabled = NO;
          
          LMHAddressModel * model      = self.addressVC.addressModel;
          if (model) {
              cell.addressModel = model;
              cell.accessoryType = UITableViewCellAccessoryNone;
              cell.phoneLabel.left = 80;

          }else{
              cell.addrssNameLabel.hidden = YES;
              cell.defaultLabel.hidden = YES;
              cell.addressDetailLabel.hidden = YES;
              cell.repaceLabel.hidden = YES;
              cell.phoneLabel.text = @"添加收货地址";
              cell.phoneLabel.left = 20;
              cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

          }
          return   cell;

      }else {
          
          static NSString *CellIdentifier = @"Cell";
          
          DCShopCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          
          if (cell == nil) {
              cell = [[[NSBundle mainBundle] loadNibNamed:@"DCShopCarTableViewCell" owner:self options:nil] objectAtIndex:0];
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              
          }
   
          DCShopModel * shopModel =  [shopCarModel.carList objectAtIndex:indexPath.section-1];
          DCShopCarModel * iten  = [shopModel.data objectAtIndex:indexPath.row];
          cell.shopCar = iten;
          
          cell.backSelect = ^(DCShopCarModel * _Nonnull model) {
              
              if (model==nil) {
                  [self deleteShopCar:iten withindex:indexPath];
                  return ;
              }
              if (!model.isSelect) {
                  shopModel.isSelect = NO;
              }
              [_rootTableView reloadData];
              [self selectSum ];
          };
          return   cell;

      }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        self.addressVC.IsCarSelect = YES;
        [self.navigationController pushViewController:_addressVC animated:YES];
    }
    
}
-(FRMAddressViewController*)addressVC{
    if (!_addressVC) {
        _addressVC = [[FRMAddressViewController alloc] init];
    }
    return _addressVC;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 ) {
        return nil ;
    }
    if (shopCarModel.carList.count<=section-1) {
        return nil;
    }
    DCShopModel * shopModel =  [shopCarModel.carList objectAtIndex:section-1];
//    DCShopModel * shopModel = nil;
    
    UIView * viewbg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    viewbg.backgroundColor = Main_BG_Color;

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 59)];
    view.backgroundColor = [UIColor HexString:@"ffffff"];
    [viewbg addSubview:view];
    
    UIButton * shopSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopSelectBtn.frame = CGRectMake(5, 15, 30, 30);
    if (shopModel.isSelect) {
        [shopSelectBtn setImage:[UIImage imageNamed:@"gwc_icon_xjdz_swmrdz1"] forState:UIControlStateNormal];
    }else{
        [shopSelectBtn setImage:[UIImage imageNamed:@"gwc_icon_xjdz_swmrdz"] forState:UIControlStateNormal];
    }
    shopSelectBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:16];
    shopSelectBtn.tag = section+100 ;
    [shopSelectBtn addTarget:self action:@selector(shopSelect:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shopSelectBtn];
    
    UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(48, 10, 40, 40)];
    [imagev setImageWithURL:[shopModel.brandUrl changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
    imagev.contentMode =  UIViewContentModeScaleAspectFit;
    [view addSubview:imagev];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(105, 15, SCREEN_WIDTH-50-80, 30)];
    label.text = shopModel.brandName;
    label.font = PFR15Font;
    [view addSubview:label];
    
    return viewbg;
}

-(void)shopSelect:(UIButton*)sender{
    
    DCShopModel * shopModel = [shopCarModel.carList objectAtIndex:sender.tag-100-1];
    shopModel.isSelect = ! shopModel.isSelect;
    
    for (DCShopCarModel * carModel in shopModel.data) {
        carModel.isSelect = shopModel.isSelect;
    }
    [_rootTableView reloadData];
    [self selectSum];
}
#pragma mark 计算总额
-(void)selectSum{
    
    float  sumPrice = 0 ;
    int  selctCount = 0;
    BOOL  isGoods = NO;
    _countAll = 0;
    for (DCShopModel* shop in shopCarModel.carList) {
        
        for (DCShopCarModel * model in shop.data) {
            isGoods = YES;
            _countAll++ ;
            if (model.isSelect) {
                sumPrice = (float)[model.price floatValue]*[model.num intValue]+sumPrice;
                selctCount++;
            }
        }
    }
    
    if (!isGoods) {
        [self setUpEmptyCartView];
    }
    _selectCountLabel.text = [NSString stringWithFormat:@"%d",selctCount];
    _sumLabel.text = [NSString stringWithFormat:@"¥：%.2f",sumPrice];
    [_selectAllButton setTitle:[NSString  stringWithFormat:@" 已选(%ld)",(long)selctCount] forState:UIControlStateNormal];

}

#pragma  mark - 设置编辑 删除
//-(void)setEditing:(BOOL)editing animated:(BOOL)animated{  ///设置可以编辑 并有动画
//
//    [super setEditing:YES animated:YES];
//    [_rootTableView setEditing:YES animated:YES];
//
//}
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{    ///实施方法 进行增减行的操作
//
//    DCShopModel * shopModel = [shopCarModel.carList objectAtIndex:indexPath.section];
//    if (shopModel.data.count>indexPath.row) {
//        [self deleteShopCar:[shopModel.data objectAtIndex:indexPath.row] withindex:indexPath];
//    }
//}

- (IBAction)buyNow:(UIButton *)sender {
    
    if (self.addressVC.addressModel==nil) {
      [MBProgressHUD showError:@"未选择地址"];  return;
    }
    
    if (shopCarModel.buyList.count>=1) {
        [shopCarModel.buyList removeAllObjects];
    }
    for (DCShopModel * model in shopCarModel.carList) {
        
        DCShopModel * shopModel= model;
        for (DCShopCarModel* carModel in shopModel.data) {
            if (carModel.isSelect) {
                [shopCarModel.buyList addObject:carModel];
            }
        }
    }
    if (shopCarModel.buyList.count<1) {
        [MBProgressHUD showError:@"未选择购物车商品"];  return;
        return ;
    }
    
    LMHpayViewController * orderVC = [[LMHpayViewController alloc]init];
    orderVC.buyList= shopCarModel.carList;
    orderVC.addressModel = _addressVC.addressModel;
    [self.navigationController pushViewController:orderVC animated:YES];
    
    return ;
}

#pragma mark 购物车
-(void)getallShopCars{
    
    NSString *path = [API_HOST stringByAppendingString:client_cart_getCarts];
    WS(weakself);
    NSDictionary *diction = @{@"limit":@"20" , @"page":@(1)};
    
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [self.rootTableView.mj_header endRefreshing];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"===%@",responseObject );
        
        if (JSONDic.count>0) {
            weakself.sumView.hidden = NO;
            weakself.rootTableView.hidden = NO;

            [weakself  setShopCarWithData:JSONDic];
        }else{
            weakself.rootTableView.hidden = YES;
            [shopCarModel.carList removeAllObjects];
            emptyCartView.hidden = NO;
            [_rootTableView reloadData];
            [self selectSum];
            
        }
    } failure:^(NSError *error) {
        [self.rootTableView.mj_header endRefreshing];
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code==%@",Dic_data);
    }];
}
#pragma mark 删除购物车
-(void)deleteShopCar:(DCShopCarModel*)carModel withindex:(NSIndexPath*)indepath{
    
    NSString *path = [API_HOST stringByAppendingString:client_cart_deleteCart];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setObject:carModel.identifier forKey:@"id"];
    
    [MBProgressHUD showActivityIndicator];
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        [weakself getallShopCars];

        
    } failure:^(NSError *error) {
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"deleteShopCar==code==%@",Dic_data);
     
    }];
    
}
-(void)deleteSuccessShopCar:(DCShopCarModel*)carModel withindex:(NSIndexPath*)indepath{
    DCShopModel * shopModel = [shopCarModel.carList objectAtIndex:indepath.section];
    
    [shopModel.data removeObjectAtIndex:indepath.row];
    [_rootTableView reloadData];
    [self selectSum ];
    
    
    if (!(shopCarModel.carList.count>0)) {
        [self setUpEmptyCartView];
    }
}

-(void)backAndReloadData:(DCShopCarModel*)carModel withIndex:(NSIndexPath*)indexpath{
    
    DCShopModel * shopModel =  [shopCarModel.carList objectAtIndex:indexpath.section];
    [shopModel.data replaceObjectAtIndex:indexpath.row withObject:carModel];
    [_rootTableView reloadData];
    [self selectSum];
    
}

-(void)setShopCarWithData:(NSArray *)array{
    
    if (array.count>=1) {
        
        if (shopCarModel.carList.count>=1) {
            [shopCarModel.carList removeAllObjects];
        }
        if (shopCarModel.buyList.count>=1) {
            [shopCarModel.buyList removeAllObjects];
        }
        int  count = 0;
        for (int i=0; i< [array count]; i++) {
            NSDictionary * dic = [array objectAtIndex:i];
            DCShopModel * model = [DCShopModel mj_objectWithKeyValues:dic];
            model.data = [DCShopCarModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"cartList"]];
            for (DCShopCarModel* carShop in model.data) {
                carShop.isSelect = YES;
                count++;
            }
            model.isSelect = YES;
            [shopCarModel.carList addObject:model];
        }
        emptyCartView.hidden = YES;
        [_rootTableView reloadData];
        [self selectSum];
        
        _countAll = 0 ;
        for (DCShopModel* shop in shopCarModel.carList) {
            _countAll = _countAll +shop.data.count;
        }
        [_selectAllButton setTitle:[NSString  stringWithFormat:@" 已选(%ld)",(long)count] forState:UIControlStateNormal];
        [_selectAllButton setImage:[UIImage imageNamed:@"gwc_icon_xjdz_swmrdz1"] forState:UIControlStateNormal];
    }else{
        
    }
    
    
}
- (IBAction)selectAllGood:(UIButton *)sender {
    
    _isSelectAll = !_isSelectAll ;
    if (_isSelectAll) {
        [_selectAllButton setImage:[UIImage imageNamed:@"gwc_icon_xjdz_swmrdz1"] forState:UIControlStateNormal];
        [_selectAllButton setTitle:[NSString  stringWithFormat:@" 已选(%ld)",(long)_countAll] forState:UIControlStateNormal];
        for (DCShopModel * shopModel in shopCarModel.carList) {
            shopModel.isSelect = YES;
            for (DCShopCarModel * carModel in shopModel.data) {
                carModel.isSelect = shopModel.isSelect;
            }
        }
    }else{
        [_selectAllButton setImage:[UIImage imageNamed:@"gwc_icon_xjdz_swmrdz"] forState:UIControlStateNormal];
        [_selectAllButton setTitle:[NSString  stringWithFormat:@" 已选(%ld)",(long)_countAll] forState:UIControlStateNormal];
        
        for (DCShopModel * shopModel in shopCarModel.carList) {
            shopModel.isSelect = NO;
            for (DCShopCarModel * carModel in shopModel.data) {
                carModel.isSelect = shopModel.isSelect;
            }
        }
    }
    [_rootTableView reloadData];
    [self selectSum];
    
}

#pragma mark - 消失
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObserve];
}


-(void)getAddressList{
    
    NSString * url = [API_HOST stringByAppendingString:client_getAddresses];
    
    [HttpEngine requestPostWithURL:url params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"data"]count]<1) {
            return ;
        }
        self.addressVC.addressModel = [LMHAddressModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]].firstObject;
        [self.rootTableView reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

@end
