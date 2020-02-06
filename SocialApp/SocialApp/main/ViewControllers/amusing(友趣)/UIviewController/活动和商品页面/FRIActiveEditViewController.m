//
//  FRIActiveEditViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 4/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "FRIActiveEditViewController.h"
#import "BSMacthPlanCell.h"
#import "BRStringPickerView.h"
#import "BRDatePickerView.h"
#import "BSGradientButton.h"
#import "FRIActiveLIistViewController.h"

#import "FRIActiveStyleModel.h"
#import "FRIAgeModel.h"

@interface FRIActiveEditViewController ()<
UITableViewDelegate,
UITableViewDataSource,
BSMacthPlanCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *titlesArray;
@property (nonatomic, copy) NSArray *placeholder;
@property (nonatomic, copy) NSArray *textFieldType;

@property (nonatomic, copy) NSArray <FRIActiveStyleModel*>*styleList;
@property (nonatomic, copy) NSArray <FRIActiveStyleModel*>*ageList;


@property (nonatomic, copy) NSString *activeID;

@property (nonatomic, strong) NSMutableArray *inputArray;

@end

@implementation FRIActiveEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"添加活动";

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@SCREEN_top);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self getAgeList];
    [self getActiveStyle];
}

- (void) setBaseAttribute {
    

}
-(NSMutableArray*)inputArray{
    if (!_inputArray) {
        _inputArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",
                       @"",@"",@"",@"",@"",nil];
    }
    return _inputArray;
}
#pragma mark 添加
- (void)addBtnAction {
    
    NSString *name = self.inputArray[0];
    NSString *style = self.inputArray[1];
    NSString *time = self.inputArray[2];
    NSString *goodID = self.inputArray[3];

    NSString *count = self.inputArray[4];
    NSString *price = self.inputArray[5];
    NSString *sex = self.inputArray[6];
    NSString *age = self.inputArray[7];
    NSString *edu = self.inputArray[8];
    NSString *merry = self.inputArray[9];


    if (!name.length) {
        [MBProgressHUD showError:@"请输入活动名称！"]; return;
    }else if (!style.length) {
        [MBProgressHUD showError:@"请选择活动类型！"]; return;
    }else if (!time.length) {
        [MBProgressHUD showError:@"请选择活动时间！"]; return;
    }else if (!goodID.length) {
        [MBProgressHUD showError:@"请选择活动！"]; return;
    }else if (!count.length) {
        [MBProgressHUD showError:@"请输入活动人数！"]; return;
    }else if (!price.length) {
        [MBProgressHUD showError:@"请输入人均金额！"]; return;
    }else if (!sex.length) {
        [MBProgressHUD showError:@"请选择性别！"]; return;
    }
    else if (!age.length) {
        [MBProgressHUD showError:@"请选择年龄层次！"]; return;
    }else if (!edu.length) {
        [MBProgressHUD showError:@"请选择学历要求！"]; return;
    }else if (!merry.length) {
        [MBProgressHUD showError:@"请选择婚恋情况！"]; return;
    }
    
    NSString *url = FORMAT(@"%@%@",API_HOST,youFun_setActivity);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([sex isEqualToString:@"男"]) {
        params[@"sex"] = @(0);
    }else if ([sex isEqualToString:@"女"]) {
        params[@"sex"] = @(1);
    }
    params[@"activityAve"] = price;
    params[@"activityName"] = name;
    params[@"activityNum"] = count;
    params[@"activityTime"] = time;
    params[@"commodityId"] = goodID;

    params[@"requireEducation"] = edu;
    params[@"requireMarriage"] = merry;
    params[@"requireSex"] = sex;
    params[@"requireAge"] = age;

    
    for (FRIActiveStyleModel * model in _styleList) {
        if ([model.selectName isEqualToString:style]) {
            params[@"activityType"] = model.selectId;
        }
    }
    for (FRIActiveStyleModel * model in _ageList) {
           if ([model.selectName isEqualToString:age]) {
               params[@"requireAge"] = model.selectId;
           }
       }
    
    [HttpEngine requestPostWithURL:url params:params isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
      
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSDictionary *userInfo = error.userInfo;
        [MBProgressHUD showError:userInfo[@"message"]];
    }];
}

- (void)BSMacthPlanCell:(BSMacthPlanCell *)cell textString:(NSString *)textString {
    NSInteger row = [[self.tableView indexPathForCell:cell] row];
    self.inputArray[row] = textString;
    if (row==5) {
        
    }
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray*)self.titlesArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BSMacthPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BSMacthPlanCell class])];
    
    if(!cell) {
        cell = [[BSMacthPlanCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([BSMacthPlanCell class])];
    }
    cell.textFieldType = [self.textFieldType[indexPath.section][indexPath.row] integerValue];
    cell.titleStr = self.titlesArray[indexPath.section][indexPath.row];
    cell.placeholder = self.placeholder[indexPath.section][indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    if (indexPath.row==5) {
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }else{
        cell.textField.keyboardType = UIKeyboardTypeDefault;
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 42.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    if (section==1) {
        return 120;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9/16)];
        view.backgroundColor =  Main_BG_Color;
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 220, 20)];
        label.text = @"注：分值到达xx分才能发起活动  ";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor HexString:@"BABFCD"];
        [view addSubview:label];
    
    if (section==1) {
        label.text = @"参与要求";
    }
        return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section==1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        view.backgroundColor =  Main_BG_Color;

        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 30, 30, 30);
        [btn setImage:[UIImage imageNamed:@"btn_round_default"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_round_pressed"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectServer:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(btn.right+0, 30, 90, 30)];
        label.text = @"我已阅读并接受";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor HexString:@"333333"];
        [view addSubview:label];

        UIButton*btn_server = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_server.frame = CGRectMake(label.right, 30, 160, 30);
        [btn_server setTitle:@"《活动须知》、《免责条款》" forState:UIControlStateNormal];
        btn_server.titleLabel.font = [UIFont systemFontOfSize:12];
//        btn_server.backgroundColor = [UIColor redColor];
        [btn_server setTitleColor:[UIColor HexString:@"BABFCD"] forState:UIControlStateNormal];
        [btn_server addTarget:self action:@selector(lookServer) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn_server];
        
        BSGradientButton*commitBtn = [BSGradientButton buttonWithType:UIButtonTypeCustom];
        commitBtn.frame = CGRectMake(40,64, SCREEN_WIDTH-80, 50);
        [commitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        commitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [commitBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [commitBtn addTarget:self action:@selector(creatActive) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:commitBtn];
        
        return view;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];//隐藏键盘
    BSMacthPlanCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section==0) {
         if (indexPath.row == 1) {
             
             NSMutableArray* array = [NSMutableArray arrayWithCapacity:20];
             for (FRIActiveStyleModel*model in _styleList) {
                 [array addObject:model.selectName];
             }
                [BRStringPickerView showStringPickerWithTitle:@"" dataSource:array
                                              defaultSelValue:nil resultBlock:^(id selectValue) {
                    cell.textStr = selectValue;
                    self.inputArray[indexPath.row] = selectValue;
                }];
            }else if (indexPath.row == 2) {
                [BRDatePickerView showDatePickerWithTitle:nil dateType:BRDatePickerModeYMDHM defaultSelValue:nil minDate:[NSDate date] maxDate:nil isAutoSelect:NO themeColor:nil resultBlock:^(NSString *selectValue) {
                    
                    cell.textStr = selectValue;
                    self.inputArray[indexPath.row] = selectValue;
        //            NSLog(@"%@--%@",selectValue,[NSDate dateToOld:selectValue]);
        //            cell.textStr = [NSDate dateToOld:selectValue];
        //            self.inputArray[indexPath.row] = [NSDate dateToOld:selectValue];
        //            self.ageStr = [selectValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
                }];
            }else if (indexPath.row == 3) {
              ///跳转
                FRIActiveLIistViewController* activeVC =[[FRIActiveLIistViewController alloc]init];
                activeVC.backActiveModel = ^(FRIGoodModel * _Nonnull model) {
                    _activeID = model.commodityId;
                    cell.textStr = model.commodityName;
                    self.inputArray[indexPath.row] = model.commodityId;
                };
                activeVC.storeID = _storeID;
                [self.navigationController pushViewController:activeVC animated:YES];
                
            }else if (indexPath.row == 4) {
            
                [BRStringPickerView showStringPickerWithTitle:nil dataSource:@[@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"] defaultSelValue:nil resultBlock:^(id selectValue) {
                    cell.textStr = selectValue;
                    self.inputArray[indexPath.row] = selectValue;
                }];
            }
            else if (indexPath.row == 5) {
            
            }
    }else{
         if (indexPath.row == 0) {
                [BRStringPickerView showStringPickerWithTitle:@"" dataSource:@[@"同性",@"不限"] defaultSelValue:nil resultBlock:^(id selectValue) {
                    cell.textStr = selectValue;
                    self.inputArray[indexPath.row+6] = ([selectValue isEqualToString:@"同性"]?@"1":@"2");
                }];
            }else if (indexPath.row == 1) {
                NSMutableArray* array = [NSMutableArray arrayWithCapacity:20];

                for (FRIActiveStyleModel*model in _ageList) {
                    [array addObject:[NSString stringWithFormat:@"%@",model.selectName]];
                    }
                
                [BRStringPickerView showStringPickerWithTitle:@"" dataSource:array defaultSelValue:nil resultBlock:^(id selectValue) {
                    cell.textStr = selectValue;
                    self.inputArray[indexPath.row+6] = selectValue;
                }];
            }else if (indexPath.row == 2) {
                NSArray * array = @[@"不限",@"大专以下",@"大专",@"本科",@"研究生",@"博士以上"] ;
                [BRStringPickerView showStringPickerWithTitle:@"" dataSource:array defaultSelValue:nil resultBlock:^(id selectValue) {
                    cell.textStr = selectValue;
                    for (int i=0; i<array.count; i++) {
                        if ([array[i] isEqualToString:selectValue]) {
                            self.inputArray[indexPath.row+6] = @(i);
                        }
                    }
                }];
            }else if (indexPath.row == 3) {
            
                [BRStringPickerView showStringPickerWithTitle:nil dataSource:@[@"不限",@"单身",@"非单身"] defaultSelValue:nil resultBlock:^(id selectValue) {
                    cell.textStr = selectValue;
                    self.inputArray[indexPath.row+6] = selectValue;
                    
                    self.inputArray[indexPath.row+6] = ([selectValue isEqualToString:@"不限"]?@"0":[selectValue isEqualToString:@"单身"]?@"1":@"2");

                }];
            }
          
    }
   
}
-(NSString*)EducationWithID:(NSString*)eduID{
  

    
    return @"0";
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.backgroundColor = Main_BG_Color ;
    }
    return _tableView;
}
- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[ @[@"活动名称",@"活动类型",@"活动时间",@"选择活动",@"活动人数",@"人均"], @[@"性别",@"年龄层次",@"学历",@"婚恋情况"]];
    }
    return _titlesArray;
}

- (NSArray *)placeholder {
    if (!_placeholder) {
        _placeholder =  @[ @[@"请输入活动名称",@"请选择",@"请选择",@"请选择",@"请选择",@"¥"], @[@"请选择",@"请选择",@"请选择",@"请选择"]];
    }
    return _placeholder;
}

- (NSArray *)textFieldType {
    if (!_textFieldType) {
        _textFieldType = @[@[@(textFieldType_default),@(textFieldType_select_icon),@(textFieldType_select_icon),@(textFieldType_select_icon),@(textFieldType_select_icon),@(textFieldType_default)],@[@(textFieldType_select_icon),@(textFieldType_select_icon),@(textFieldType_select_icon),@(textFieldType_select_icon)]];
    }
    return _textFieldType;
}

-(void) selectServer:(UIButton*)sender{
    
    sender.selected = ! sender.selected ;
    
}

-(void) lookServer{
    
    NSLog(@"====查看用户协议==");
    
}

-(void) creatActive{
    
    [self addBtnAction];
}


#pragma 获取公共参数
-(void)getAgeList{
    
    NSString *url = FORMAT(@"%@%@",API_HOST,common_select);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"5" forKey:@"selectType"];
    WS(weakself);
    [HttpEngine requestGetWithURL:url params:params isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
       
        weakself.ageList = [FRIActiveStyleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];

    } failure:^(NSError *error) {
         NSDictionary *userInfo = error.userInfo;
         [MBProgressHUD showError:userInfo[@"message"]];
     }];
    
}

-(void)getActiveStyle{
    
    NSString *url = FORMAT(@"%@%@",API_HOST,common_select);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"6" forKey:@"selectType"];
    WS(weakself);
    [HttpEngine requestGetWithURL:url params:params isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
       weakself.styleList = [FRIActiveStyleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];

    } failure:^(NSError *error) {
         NSDictionary *userInfo = error.userInfo;
         [MBProgressHUD showError:userInfo[@"message"]];
     }];
    
}
@end
