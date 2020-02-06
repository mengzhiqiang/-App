//
//  FWRForgetPasswordController.m
//  FindWorker
//
//  Created by libj on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FWRForgetPasswordController.h"
#import "LLModyPayPassCell.h"
#import "TimeOfcCodeButton.h"
#import "BSGradientButton.h"
static NSString *const LLModyPayPassCellid = @"LLModyPayPassCell";

@interface FWRForgetPasswordController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)UITextField *phonetx;
@property (nonatomic,strong)UITextField *codetx;
@property (nonatomic,strong)UITextField *newpwd;
@property (nonatomic,strong)UITextField *renewpwd;
@property (nonatomic,strong) UIButton *yanzhengBtn;/** <#class#> **/

@property (nonatomic,assign) BOOL isEnable;/** <#class#> **/
@property (nonatomic,copy) NSString *code;/** <#class#> **/

@property (strong, nonatomic)  BSGradientButton *loginButton;

@end

@implementation FWRForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

#pragma mark--createUI
-(void)createUI{
    self.customNavBar.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.isEnable  = YES;
    
    BSGradientButton *confirmBtn = [BSGradientButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor = Main_Color;
    [confirmBtn setTitle:@"重置" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatBasedI375(17)];
    confirmBtn.layer.cornerRadius = 25;
    confirmBtn.clipsToBounds = YES;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(350);
        make.right.offset(-43);
        make.left.offset(43);
        make.height.equalTo(@50);
    }];
}
#pragma mark---点击事件
-(void)confirmBtnClick:(UIButton *)btn{
   

    if( self.phonetx.text.length == 0 ){
        [MBProgressHUD  showError:@"请输入用户手机号码！"];        return;
    }else if( self.phonetx.text.length != 11 ){
        [MBProgressHUD  showError:@"用户手机号码格式不对！"];        return;
    }else if (!self.codetx.text.length){
        [MBProgressHUD  showError:@"请输入验证码"];        return;
    }else if (!self.codetx.text.length){
        [MBProgressHUD  showError:@"请输入验证码"];        return;
    }else if(!self.newpwd.text.length){
        [MBProgressHUD  showError:@"请输入密码！"];        return;
    }else if(!self.renewpwd.text.length){
        [MBProgressHUD  showError:@"请再次输入密码！"];        return;
    }else if (![self.renewpwd.text isEqualToString:self.newpwd.text]) {
        [MBProgressHUD  showError:@"密码不一致，请重新输入！"];        return;
    }

   [self getForgetPwd];
}


#pragma mark 重置登录密码 或 支付密码
- (void) getForgetPwd {
    UserInfo *userinfo = [CommonVariable getUserInfo];
    
      NSString *url = [API_HOST stringByAppendingString:account_register];
    
    NSDictionary *params = @{
                             @"verificationCode" : self.codetx.text,
                             @"password" : self.newpwd.text,
                             @"userPhone" : self.phonetx.text,
                             @"type" : @(2),
                             };
    
    [MBProgressHUD showActivityIndicator];
    [HttpEngine requestPostWithURL:url params:params isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        
        if ([responseObject[@"code"] intValue]==200) {
           
            [MBProgressHUD showSuccess:@"找回密码成功"];
            [self.navigationController popViewControllerAnimated:YES];

        }else {
            [MBProgressHUD showError:responseObject[@"message"]];
        }
       
    } failure:^(NSError *error) {
        [MBProgressHUD hideActivityIndicator];
        [MBProgressHUD showError:error.userInfo[@"message"]];
    }];
}

#pragma mark  退出登录

-(void)logout{
    [CommonVariable removeUserInfoData];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)loadNewCodeWithIphone:(TimeOfcCodeButton *)sender{
    if(  self.phonetx.text.length <= 0){
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    [self.view endEditing:YES];
    sender.codeStyle=[NSString stringWithFormat:@"2"];
    [sender loadNewCodeWithIphone:self.phonetx.text];
    
}

#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLModyPayPassCell *cell=[tableView dequeueReusableCellWithIdentifier:LLModyPayPassCellid forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.placeholder = self.titleArray[indexPath.row];
    cell.index = indexPath.row;
    cell.textField.delegate = self;
//    if (self.passwordType != PassworkType_login) {
       
//    }
     cell.textField.keyboardType = UIKeyboardTypeDefault;
    if(indexPath.row == 0){
        self.phonetx = cell.textField;
    }else if (indexPath.row == 1){
        TimeOfcCodeButton *rightBtn = [[TimeOfcCodeButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80-20, 0, 80, 44)];
//        [rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(loadNewCodeWithIphone:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.count_label.textColor = [UIColor redColor];
        [cell.textField addSubview: rightBtn];
//        cell.textField.rightViewMode = UITextFieldViewModeAlways;
        self.codetx = cell.textField;
    cell.textField.keyboardType = UIKeyboardTypePhonePad;
        
    }else if (indexPath.row == 2){
        cell.textField.secureTextEntry = YES;
        self.newpwd = cell.textField;
        
    }else if (indexPath.row == 3){
        cell.textField.secureTextEntry = YES;
        self.renewpwd = cell.textField;
    }
    return cell;
}
/*  限制textfield输入长度  */
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == self.newpwd) {
//        if (range.length == 1 && string.length == 0) {
//            return YES;
//        }
//        else if (self.newpwd.text.length >= 6) {
//            self.newpwd.text = [textField.text substringToIndex:6];
//            return NO;
//        }
//    }
//    return YES;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGFloatBasedI375(40);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [UIView new];
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFloatBasedI375(10);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

#pragma mark--lazy---
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor HexString:@"#F5F5F5"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[LLModyPayPassCell class] forCellReuseIdentifier:LLModyPayPassCellid];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = CGFloatBasedI375(44);
    }
    return _tableView;
}
-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSArray alloc]initWithObjects:@"请输入手机号码",@"输入验证码",@"输入新密码",@"再次输入新密码", nil];
    }
    return _titleArray;
}


@end
