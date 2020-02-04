//
//  FWRAddressEditViewController.m
//  FindWorker
//
//  Created by zhiqiang meng on 18/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FWRAddressEditViewController.h"
#import "FWRAddressTableViewCell.h"
#import "MOFSPickerManager.h"

@interface FWRAddressEditViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    MOFSPickerManager * PickerManager ;
    
}

@property(nonatomic, strong) UITableView * rootTableView ;
@property(nonatomic, strong) UILabel *  addressLabel ;

@property(nonatomic, strong) UIButton *  saveButton ;

@property(nonatomic, strong) NSString * address ;
@property(nonatomic, strong) NSString * addressDetail ;
@property(nonatomic, strong) NSString * address_name ;
@property(nonatomic, strong) NSString * address_phone ;
@property(nonatomic, assign) BOOL  isDaFa ;
@property(nonatomic, assign) BOOL  isDefault ;


@property(nonatomic, assign) CGFloat  latitude ;
@property(nonatomic, assign) CGFloat  longitude ;

@property(nonatomic, strong) UISwitch* offView ;


@end

@implementation FWRAddressEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.view addSubview:self.rootTableView];
    [self loadDataUI ];
     self.customNavBar.title = @"编辑地址";
    [self.view addSubview:self.saveButton];
    self.view.backgroundColor = Main_BG_Color;

}

-(UISwitch*)offView{
    if (!_offView) {
        _offView = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-65, 8, 45, 27)];
        [_offView addTarget:self action:@selector(swithcdaFA:) forControlEvents:UIControlEventValueChanged];
        _offView.tintColor = Main_Color;
        _offView.onTintColor = Main_Color;

    }
    _offView.on = _addressModel.isTake;
    return  _offView;
}
-(void)swithcdaFA:(UISwitch*)sender{
    
    _isDaFa = sender.on ;
}

-(UITableView*)rootTableView{
    
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top) style:UITableViewStyleGrouped];
        _rootTableView.delegate=self;
        _rootTableView.dataSource=self;
        _rootTableView.separatorStyle=UITableViewCellAccessoryNone;
        _rootTableView.backgroundColor = Main_BG_Color;
        _rootTableView.sectionFooterHeight = 0.1;
        _rootTableView.sectionHeaderHeight = 0.1;
        _rootTableView.scrollEnabled = NO;
    }
    return _rootTableView;
}

-(UILabel*)addressLabel{
    
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = [UIColor HexString:@"333333"];
        _addressLabel.font = [UIFont systemFontOfSize:15];
        _addressLabel.textAlignment = NSTextAlignmentRight;
        _addressLabel.numberOfLines = 0 ;
    }
    return  _addressLabel ;
}
-(UIButton*)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(30, SCREEN_HEIGHT-80, SCREEN_WIDTH-60, 49);
        _saveButton.backgroundColor = Main_Color;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(AddressList) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton draCirlywithColor:nil andRadius:10.0f];
    }
    return _saveButton ;
}

-(void)loadDataUI{
    if (_addressModel) {
        _address_phone  = _addressModel.phone;
        _address_name   = _addressModel.name;
        _address        = [NSString stringWithFormat:@"%@-%@-%@",_addressModel.provinceId,_addressModel.cityId,_addressModel.areaId];
        _addressDetail  = _addressModel.address;
        _isDaFa         = _addressModel.isTake;
        _isDefault      = _addressModel.isDefault;
        
        [self.customNavBar wr_setRightButtonWithTitle:@"删除" titleColor:Main_Color];
        WS(weakself);
        [self.customNavBar setOnClickRightButton:^{
            [weakself deleteAddressID];
        }];
        
    }else{
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==2 && self.address) {
        return 64 ;
    }
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"FWRAddressTableViewCell";
    FWRAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FWRAddressTableViewCell" owner:self options:nil] objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray * array = @[@"收货人",@"手机号码",@"所在地区",@"详细地址",@"设置代发"];
    NSArray * array1 = @[@"请输入姓名",@"请输入手机号码",@"请选择地区",@"街道、楼牌号",@""];

    cell.addressTitleLabel.text = array[indexPath.row];
    cell.addressTextField.placeholder = array1[indexPath.row];
    cell.addressTextField.tag = 100+indexPath.row;
    [cell.addressTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    switch (indexPath.row) {
        case 0:
            {
                cell.addressTextField.text = _address_name ;
            }
            break;
        case 1:
        {
            cell.addressTextField.keyboardType = UIKeyboardTypePhonePad ;
            cell.addressTextField.text = _address_phone ;

        }
            break;
        case 2:
        {
            cell.pushTagImageView.hidden = NO;
            cell.addressTextField.left= 95 ;
            cell.addressTextField.userInteractionEnabled = NO;
            
            if (self.address) {
                cell.addressTextField.hidden = YES;
                self.addressLabel.frame = CGRectMake(100, 5, SCREEN_WIDTH-100-20, 54);
                [cell addSubview:self.addressLabel];
                self.addressLabel.text = [NSString stringWithFormat:@"%@",_address];
            }
        }
            break;
        case 3:
        {
            if (self.addressDetail) {
                cell.addressTextField.text = self.addressDetail;
            }
        }
            break;
        case 4:
        {
            cell.addressTextField.hidden = YES ;
            [cell  addSubview:self.offView];
        }
            break;
            
        default:
            break;
    }
    return cell ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"  设为默认地址" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:Sub_title_Color forState: UIControlStateNormal];
    if (_isDefault) {
        [btn setImage:[UIImage imageNamed:@"gwc_icon_xz"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"gwc_icon_xz1"] forState:UIControlStateNormal];
    }
    btn.frame = CGRectMake(100, 10, SCREEN_WIDTH-200, 30);
    btn.imageView.width = 15;
    btn.imageView.height = 15 ;
    [btn addTarget:self action:@selector(selectDefault:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}

-(void)selectDefault:(UIButton*)sender{
    
    _isDefault = !_isDefault ;
    if (_isDefault) {
        [sender setImage:[UIImage imageNamed:@"gwc_icon_xz"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"gwc_icon_xz1"] forState:UIControlStateNormal];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"===");
    if (indexPath.row==2) {
        [self selectPickerManager];
    }
}

- (void) textFieldDidChange:(UITextField *) TextField{
    
    switch (TextField.tag) {
        case 100:
        {
            _address_name = TextField.text;
        }
            break;
        case 101:
        {
            _address_phone = TextField.text;
        }
            break;
        case 102:
        {
            _address = TextField.text;
        }
            break;
        case 103:
        {
            _addressDetail = TextField.text;
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 选择地区
- (void )selectPickerManager{
    
    __weak typeof (self) weakSelf = self;
    if (PickerManager) {
        PickerManager = nil;
    }
    PickerManager = [MOFSPickerManager new];
    [PickerManager showMOFSAddressPickerWithDefaultZipcode:@"120000-120000-120101" title:@"选择地址" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString * _Nullable address, NSString * _Nullable zipcode) {
        NSLog(@"====%@===%@==",address,zipcode);
        weakSelf.address = address ;
        [weakSelf.rootTableView reloadData];
    } cancelBlock:^{
        
    }];
    
}

-(void)AddressList{
    

    if (_address_name.length<1) {
        [MBProgressHUD  showError:@"联系人姓名不能有空格！"]; return;
     }
    
    if (_address_phone.length<1) {
        [MBProgressHUD  showError:@"联系人手机号不能有空格！"];return;
    }
    if (_address_phone.length!=11) {
        [MBProgressHUD  showError:@"联系人手机号格式不对！"];return;
    }
    if (_address.length<1) {
        [MBProgressHUD  showError:@"请选择联系人地址！"];return;
    }
    
    NSString * url = [API_HOST stringByAppendingString:client_addAddress];
    NSMutableDictionary * diction = [NSMutableDictionary dictionaryWithCapacity:20];
    [diction setObject:self.addressDetail forKey:@"address"];
    [diction setObject:_address_name forKey:@"name"];
    [diction setObject:_address_phone forKey:@"phone"];
    
    [diction setObject:@(_isDefault) forKey:@"isDefault"];
    [diction setObject:@(_isDaFa) forKey:@"isTake"];

    NSArray*addresA = [_address componentsSeparatedByString:@"-"];
    
    if (addresA.count==3) {
        [diction setObject:addresA[2] forKey:@"areaId"];
        [diction setObject:addresA[1] forKey:@"cityId"];
        [diction setObject:addresA[0] forKey:@"provinceId"];
    }
    
    
    if(_addressModel.identifier){
      url = [API_HOST stringByAppendingString:client_putddresses];
     [diction setObject:_addressModel.identifier forKey:@"id"];
    }
    [MBProgressHUD showActivityIndicator];
    [HttpEngine requestPostWithURL:url params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        NSLog(@"resonseObject==%@",responseObject);
        [MBProgressHUD showSuccess:(_addressModel.identifier?@"修改成功":@"添加成功")];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"resonseObject==%@",error.userInfo);
        [MBProgressHUD hideActivityIndicator];

        [MBProgressHUD showError:(_addressModel.identifier?@"修改失败":@"添加失败")];

    }];
    
}

-(void)deleteAddressID{
    [MBProgressHUD showActivityIndicator];

    NSString * url = [API_HOST stringByAppendingString:client_deleteAddresses];
    NSMutableDictionary * diction = [NSMutableDictionary dictionaryWithCapacity:20];
    if(_addressModel.identifier){
        [diction setObject:_addressModel.identifier forKey:@"addressId"];
    }
    
    [HttpEngine requestPostWithURL:url params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];

        [MBProgressHUD showSuccess:@"已删除成功！"];
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        [MBProgressHUD hideActivityIndicator];

        NSLog(@"resonseObject==%@",error.userInfo);
    }];
    
}
@end
