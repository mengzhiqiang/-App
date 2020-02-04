//
//  FWRPickerView.m
//  FindWorker
//
//  Created by zhiqiang meng on 11/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FWRPickerView.h"

@interface FWRPickerView ()

@property(nonatomic,strong)NSArray *dataSouce;
@property (weak, nonatomic) NSString  *beginString;
@property (weak, nonatomic) NSString  *endString;

@property (strong, nonatomic) UIButton  *cancelButton;
@property (strong, nonatomic) UIButton  *submitButton;
@property (strong, nonatomic) UILabel  *titiLabel;
@property (strong, nonatomic) UILabel  *lineLabel;
@property (strong, nonatomic) UIView  *headView;

@property (assign, nonatomic) pickerDataType  pickerType;

@end

@implementation FWRPickerView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupView];
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0  blue:0.0/255.0  alpha:0.3];
    }
    return self;
}

-(UIPickerView*)pickerView{
    
    if (!_pickerView) {
        _pickerView  = [[UIPickerView alloc]init];
        _pickerView.frame = CGRectMake(0, 44, SCREEN_WIDTH, 216);
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView ;
}
-(UIButton*)cancelButton{
    
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(20, 7, 40, 30);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:Main_Color forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton ;
}
-(UIButton*)submitButton{
    
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(SCREEN_WIDTH-60, 7, 40, 30);
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setTitleColor:Main_Color forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(SubmitPicker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton ;
}
-(UILabel* )titiLabel{
    if (!_titiLabel) {
        _titiLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, SCREEN_WIDTH-100, 30)];
        _titiLabel.text = @"服务时间";
        _titiLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titiLabel ;
}
-(UILabel* )lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 0.5)];
        _lineLabel.text = @"";
        _lineLabel.backgroundColor = [UIColor grayColor];
        _lineLabel.alpha = 0.3 ;
    }
    return _lineLabel ;
}

-(UIView*)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-260, SCREEN_WIDTH, 260)];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    
    [_headView addSubview:self.pickerView];
    [_headView addSubview:self.cancelButton];
    [_headView addSubview:self.submitButton];
    [_headView addSubview:self.titiLabel];
    [_headView addSubview:self.lineLabel];
    return _headView ;
}
-(void)cancelPicker{
    self.backgroundColor = [UIColor clearColor];

    [UIView animateWithDuration:0.3 animations:^{
        self.top = SCREEN_HEIGHT;
//        self.hidden = YES;
    }];
}

- (void)showPickerView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.top = 0;

    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0  blue:0.0/255.0  alpha:0.3];
    }];
}

-(void)SubmitPicker{
    
    if (_backPickerInfo) {
        NSDictionary*diction ;
        if (_pickerType==pickerDataTypeDay) {
            diction =@{@"day":_beginString } ;
        } else if (_pickerType==pickerDataTypeTime) {
            diction =@{@"bengin":_beginString ,@"end":_endString} ;
        } else if (_pickerType==pickerDataTypeAccount) {
            diction =@{@"0":self.dataSouce[0][[self.pickerView selectedRowInComponent:0]],
                       @"1":self.dataSouce[1][[self.pickerView selectedRowInComponent:1]],
                       } ;
        } else if (_pickerType==pickerDataTypeTeam) {
            diction =@{@"0":self.dataSouce[0][[self.pickerView selectedRowInComponent:0]],
                       @"1":self.dataSouce[1][[self.pickerView selectedRowInComponent:1]],
                       @"2":self.dataSouce[3][[self.pickerView selectedRowInComponent:3]],
                       @"3":self.dataSouce[4][[self.pickerView selectedRowInComponent:4]],
                       } ;
        }
        NSLog(@"===%@",diction);
        _backPickerInfo(diction);
    }
    [self cancelPicker];
}

#pragma mark - life cycle
-(void)setupView {
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = YES;
    //将触摸事件添加到当前view
    [self addGestureRecognizer:tapGestureRecognizer];
    [self addSubview:self.headView];
    //    默认选中数据
}
#pragma mark - public methods

#pragma mark - private methods

- (IBAction)random:(id)sender {
    
    // 遍历集合中的所有组
    for (int i = 0; i < self.dataSouce.count; ++i) {
        // 第i组里面的所有数据
        NSUInteger count = [self.dataSouce[i] count];
        // 生成随机数去选中
        u_int32_t ranNum = arc4random_uniform((int)count);
        // 获取第i组当前选中的行
        NSInteger selRowNum = [self.pickerView selectedRowInComponent:i];
        // 如果随机数与当前选中的行号一致,需要重新生成随机数
        while (selRowNum == ranNum) {
            ranNum = arc4random_uniform((int)count);
        }
        // 让pickerView选中数据
        [self.pickerView selectRow:ranNum inComponent:i animated:YES];
        // 将数据现实到label上
        [self pickerView:self.pickerView didSelectRow:ranNum inComponent:i];
    }
        
}

- (NSArray *)dataSouce {
    if (!_dataSouce) {
        _dataSouce = @[@[@"11:00"]];
    }
    return _dataSouce;
}

#pragma mark - dataSouce
//有几行
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataSouce.count;
}
//行中有几列
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSouce[component] count];
}
//列显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    return self.dataSouce[component][row];
}

//- (UIView *)pickerView:(UIPickerView *)pickerView
//            viewForRow:(NSInteger)row forComponent:(NSInteger)component
//           reusingView:(UIView *)view{
//
//    //普通状态的颜色
//    UILabel* norLabel = (UILabel*)view;
//    if (!norLabel){
//        norLabel = [[UILabel alloc] init];
//        norLabel.textColor = [UIColor darkTextColor];
//        norLabel.adjustsFontSizeToFitWidth = YES;
//        [norLabel setTextAlignment:NSTextAlignmentCenter];
////        [norLabel setBackgroundColor:[UIColor blueColor]];
//        [norLabel setFont:[UIFont systemFontOfSize:17]];
//
//    }
//    norLabel.text = [self pickerView:pickerView
//                         titleForRow:row
//                        forComponent:component];
//    //设置分割线
//    for (UIView *line in pickerView.subviews) {
//        if (line.frame.size.height <= 1) {//0.6667
//            line.backgroundColor = [UIColor lightGrayColor];
//            CGRect tempRect = line.frame;
//            line.frame = CGRectMake(0, tempRect.origin.y, SCREEN_WIDTH, 0.5);
//            line.alpha = 0.3;
//        }
//    }
//
//    if (component==1) {
//        norLabel.textColor = [UIColor redColor];
//    }
//
//    return norLabel ;
//}

#pragma mark - delegate
// 选中某一组的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *selFood = self.dataSouce[component][row];
    NSLog(@"%@", selFood);
    switch (component) {
        case 0:
            self.beginString = selFood;
            break;
        case 2:
            self.endString = selFood;
            break;
            
        default:
            break;
    }
  
}

#pragma mark 数据设置
-(void)setDateOftime{
    NSMutableArray * array = [NSMutableArray array];
    for (int i=0; i<24; i++) {
        NSArray * min = @[@"00",@"15",@"45"];
        for (int j=0; j<3; j++) {
            NSString * string = [NSString stringWithFormat:@"%d:%@",i,min[j]];
            [array addObject:string];
        }
    }
    _dataSouce = [NSArray arrayWithObjects:array,@[@"至"],array, nil];
}

-(void)setDateOfDay{
    
    NSMutableArray * array = [NSMutableArray array];
    for (int i=0; i<30; i++) {
            NSString *string = [NSString stringWithFormat:@"%d天",i];
            [array addObject:string];
    }
    _dataSouce = [NSArray arrayWithObjects:array, nil];
}

- (void)setDataOfAccount {
    NSMutableArray *firstArr = [NSMutableArray array];
    NSMutableArray *secondArr = [NSMutableArray array];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy";
    NSString *year = [df stringFromDate:[NSDate date]];
    for (int i = 0; i < 20; i++) {
        [firstArr insertObject:[NSString stringWithFormat:@"%ld", year.integerValue-i] atIndex:0];
    }
    for (int i = 0; i < 12; i++) {
        [secondArr addObject:[NSString stringWithFormat:@"%02d", i+1]];
    }
    self.dataSouce = @[firstArr, secondArr];
}

- (void)setDataOfTeam {
    NSMutableArray *firstArr = [NSMutableArray array];
    NSMutableArray *secondArr = [NSMutableArray array];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy";
    NSString *year = [df stringFromDate:[NSDate date]];
    for (int i = 0; i < 20; i++) {
        [firstArr insertObject:[NSString stringWithFormat:@"%ld", year.integerValue-i] atIndex:0];
    }
    for (int i = 0; i < 12; i++) {
        [secondArr addObject:[NSString stringWithFormat:@"%02d", i+1]];
    }
    self.dataSouce = @[firstArr, secondArr, @[@"至"], firstArr, secondArr];
}

-(void)setupPickerStyle:(pickerDataType)style{
    
    _pickerType = style ;
    switch (style) {
        case pickerDataTypeTime:
            self.titiLabel.text = @"服务时间";
            [self setDateOftime];
            [_pickerView reloadAllComponents];

            if (_dataSouce.count==3) {
                [self.pickerView selectRow:20 inComponent:0 animated:YES];
                [self.pickerView selectRow:20 inComponent:2 animated:YES];
                _beginString = @"6:45";
                _endString = @"6:45";
            }
            break;
        case pickerDataTypeDay:
            self.titiLabel.text = @"预计工时";
            [self setDateOfDay];
            [_pickerView reloadAllComponents];

            [self.pickerView selectRow:1 inComponent:0 animated:YES];
            _beginString = @"1天";
            break;
        case pickerDataTypeAccount:
            self.titiLabel.text = @"";
            [self setDataOfAccount];
            [_pickerView reloadAllComponents];
            
            [self.pickerView selectRow:19 inComponent:0 animated:YES];
            [self.pickerView selectRow:9 inComponent:1 animated:YES];

            break;
        case pickerDataTypeTeam:
            self.titiLabel.text = @"";
            [self setDataOfTeam];
            [_pickerView reloadAllComponents];
            break;
        default:
            break;
    }
}
@end
