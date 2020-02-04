//
//  FRMAddressViewController.m
//  FindWorker
//
//  Created by zhiqiang meng on 18/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRMAddressViewController.h"
#import "FWRAddressTableViewCell.h"
#import "FWRAddressEditViewController.h"
#import "LMHAddressModel.h"
@interface FRMAddressViewController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic, strong) UITableView * rootTableView ;
@property(nonatomic, strong) NSArray * allArray ;

@end

@implementation FRMAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.rootTableView];
    
    self.customNavBar.title = @"服务地址";
    [self.customNavBar wr_setRightButtonWithTitle:@"新增地址" titleColor:Main_Color];
    WS(weakself);
    [self.customNavBar setOnClickRightButton:^{
        FWRAddressEditViewController* vc = [FWRAddressEditViewController new];
        [weakself.navigationController pushViewController:vc animated:YES];
    }];
    
//    self.navigationController.tabBarController.tabBar .hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAddressList];

}

-(UITableView*)rootTableView{
    
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top) style:UITableViewStyleGrouped];
        _rootTableView.delegate=self;
        _rootTableView.dataSource=self;
        _rootTableView.separatorStyle=UITableViewCellAccessoryNone;
        _rootTableView.backgroundColor = [UIColor HexString:@"f5f5f5"];
        _rootTableView.sectionFooterHeight = 0.1;
        _rootTableView.sectionHeaderHeight = 0.1;

    }
    return _rootTableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"FWRAddressTableViewCell";
    FWRAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FWRAddressTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LMHAddressModel * model      = [_allArray objectAtIndex:indexPath.row];
    cell.addrssNameLabel.text    = [NSString stringWithFormat:@"%@",model.name];
    cell.phoneLabel.text         = [NSString stringWithFormat:@"%@",[model.phone changePhone]];

    cell.addressDetailLabel.text = [NSString stringWithFormat:@"%@%@%@\n%@",model.provinceId,model.cityId,model.areaId,model.address];
    
    if (model.isDefault) {
        cell.defaultLabel.hidden = NO;
    }else{
        cell.defaultLabel.hidden = YES;
    }
    if (model.isTake) {
        cell.repaceLabel.hidden = NO;
    }else{
        cell.repaceLabel.hidden = YES;
    }
    
    cell.backEditAddress = ^{
        FWRAddressEditViewController* vc = [FWRAddressEditViewController new];
        vc.addressModel = model ;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_allArray.count>indexPath.row) {
        LMHAddressModel * model      = [_allArray objectAtIndex:indexPath.row];
        if (_IsCarSelect) {
            self.addressModel = model ;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (model) {
                FWRAddressEditViewController* vc = [FWRAddressEditViewController new];
                vc.addressModel = model ;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                FWRAddressEditViewController* vc = [FWRAddressEditViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
  
}

-(void)getAddressList{
    
    NSString * url = [API_HOST stringByAppendingString:client_getAddresses];

    [HttpEngine requestPostWithURL:url params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"data"]count]<1) {
            return ;
        }
      self.allArray = [LMHAddressModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
     [self.rootTableView reloadData];
        [self saveDefalutAddress];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)saveDefalutAddress{
    
    for (LMHAddressModel *model in self.allArray) {
        
        if (model.isDefault) {
            NSDictionary *dic = [model mj_keyValues];
            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"DefaultAddress"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    
}

@end
