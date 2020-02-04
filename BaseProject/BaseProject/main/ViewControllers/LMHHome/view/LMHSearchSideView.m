//
//  LMHSearchSideView.m
//  BaseProject
//
//  Created by wfg on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHSearchSideView.h"
#import "LMHLeftBrandModel.h"
#import "LMHBandDetailViewController.h"
#import "LMHSearchTableViewCell.h"

@interface LMHSearchSideView ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *typeBtns;
@property (weak, nonatomic) IBOutlet UILabel *typeCountLbl1;
@property (weak, nonatomic) IBOutlet UILabel *typeCountLbl2;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic)  NSMutableArray *array;
@property (assign, nonatomic)  NSInteger page;
@property (assign, nonatomic)  NSInteger type;
@property (assign, nonatomic)  NSInteger secondsCountDown;

@end

@implementation LMHSearchSideView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tv.rowHeight = 60;
    self.tv.sectionHeaderHeight = 50;
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tv.tableFooterView = [UIView new];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _type = 1;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.bgView addGestureRecognizer:tapGestureRecognizer];
}

-(void)hideKeyBoard{
    [self hide];
}
-(NSMutableArray*)array{
    if (!_array) {
        _array = [NSMutableArray arrayWithCapacity:20];
    }
    return _array;
}

- (IBAction)typeAction:(UIButton *)sender {
    for (UIButton *btn in self.typeBtns) {
        if ([btn isEqual:sender]) {
            [btn setTitleColor:Main_Color forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:Main_title_Color forState:UIControlStateNormal];

        }
    }
    if (sender.tag==10) {
        _type = 1;
    }else{
        _type = 2;
    }
    
    [self getLeftTotalBrand];
    [_searchBar resignFirstResponder];

    self.typeCountLbl1.backgroundColor = sender.tag == 10 ? Main_Color : [UIColor colorWithHexValue:0xCCCCCC];
    self.typeCountLbl2.backgroundColor = sender.tag == 11 ? Main_Color : [UIColor colorWithHexValue:0xCCCCCC];
}

- (IBAction)cancelAction:(id)sender {
    [self hide];
}

- (void)show {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview);
    }];
    [UIView animateWithDuration:.3 animations:^{
        [self.superview layoutIfNeeded];
        _bgView.alpha = 0.4;
    }];
    [self getLeftTotalBrand];
}

- (void)hide {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview).offset(-SCREEN_WIDTH);
    }];
    _bgView.alpha = 0.0;
    [UIView animateWithDuration:.3 animations:^{
        [self.superview layoutIfNeeded];
    }];
    [_searchBar resignFirstResponder];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [[self.array objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LMHSearchTableViewCell";
    LMHSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMHSearchTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LMHLeftBrandModel * model = [self.array[indexPath.section] objectAtIndex:indexPath.row];
    [cell.brandImageView setImageWithURL:[model.brandLogo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
    [cell.brandImageView draCirlywithColor:nil andRadius:5.0f];
    cell.brandTitleLabel.text = model.brandName;
    cell.brandTimeLabel.text = [self showTimeOfDate:model];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    LMHLeftBrandModel * model = [self.array[section] firstObject];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 200, 44)];
    lbl.text = @"10月26日";
    if (model) {
        lbl.text = [self brandFromDataTime:model.startTime];
    }
    lbl.textColor = Sub_title_Color;
    lbl.font = [UIFont boldSystemFontOfSize:22];
    [view addSubview:lbl];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchBar resignFirstResponder];
    [self hide];
    
  
    LMHLeftBrandModel * model = [self.array[indexPath.section] objectAtIndex:indexPath.row];

    if (_type == 1) {
           LMHBandDetailViewController* bandVC = [[LMHBandDetailViewController alloc] init];
             bandVC.bandID = model.brandId;
//             bandVC.scheduleId = model.scheduleId;
             [[UIViewController getCurrentController].navigationController pushViewController:bandVC animated:YES];
    }else{
        [MBProgressHUD showError:@"敬请期待！"];
    }
   

}
#pragma mark searchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self getLeftTotalBrand];
    
}
-(void)getLeftTotalBrand{
    [_searchBar resignFirstResponder];
    NSDictionary *dic;
    if (_searchBar.text.length<1) {
        dic = @{@"limit":@(50),@"page":@(1) , @"type":@(_type)};
    }else{
       dic = @{@"limit":@(50),@"page":@(1) , @"type":@(_type),@"key":_searchBar.text};
    }
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_home_getLeftTotalBrand];
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:dic isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        if ([[responseObject objectForKey:@"data"] count]>0) {
            [weakself mergeData:[LMHLeftBrandModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]]];
        }else{
            [weakself mergeData:nil];
            [MBProgressHUD showError:@"没有符合您要求的商品！"];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}

#pragma mark 时间转换
- (NSString *)brandFromDataTime:(NSString *)dateTime{
    
    NSArray * arr =[[dateTime substringToIndex:10] componentsSeparatedByString:@"-"];
    
    if ([arr count]>=3) {
        return [NSString stringWithFormat:@"%@月%@日",[arr objectAtIndex:1],[arr objectAtIndex:2]];
    }
    return @"某月某日";
}

-(void)mergeData:(NSMutableArray*)array{
    
    if (self.array.count) {
        [self.array removeAllObjects];
    }
    
    if (_type==1) {
        _typeCountLbl1.text = [NSString stringWithFormat:@" %lu ",(unsigned long)array.count];
    }else{
        _typeCountLbl2.text = [NSString stringWithFormat:@" %lu ",(unsigned long)array.count];
    }
    
    for (int i=0; i<array.count; i++) {
        LMHLeftBrandModel * model1 = array[i];
        NSMutableArray* arr = [NSMutableArray arrayWithCapacity:20];

        BOOL  iscontent = NO;
        for (NSArray * array1 in self.array ) {
            LMHLeftBrandModel * model2 = array1[0];
            if ([self isSameDay:model1.startTime andDay:model2.startTime]) {
                 iscontent = YES;
                break;
            }
        }
        if (iscontent) {
            continue;
        }
        
        [arr addObject:model1];
        for (int j=1; j<array.count; j++) {
            LMHLeftBrandModel * model2 = array[j];
            if ([self isSameDay:model1.startTime andDay:model2.startTime]  && model2!=model1) {
                [arr addObject:model2];
            }
        }
        
        [self.array addObject:arr];
    }
    [self.tv reloadData];

}

-(BOOL)isSameDay:(NSString*)data1 andDay:(NSString*)data2{
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    // 要比较的那个日期，NSDate类型
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:[NSDate dateForString:data1]];
    // 跟现在的时间相比
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:[NSDate dateForString:data2]];
    BOOL isSameDay = [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year];
    return isSameDay;
}

-(NSString*)showTimeOfDate:(LMHLeftBrandModel*)model{
    
    NSString * string;
    if([[NSDate dateForString:model.startTime] earlierDate:[NSDate date]] == [NSDate dateForString:model.startTime])
    {
        
        if([[NSDate dateForString:model.endTime] earlierDate:[NSDate date]] == [NSDate dateForString:model.endTime]){
            string = @"已结束";
        }else{
            ///即将结束
           NSString * time = [self nowDateDifferWithDate:model.endTime];
            string = [NSString stringWithFormat:@"距结束%@",time];
        }
    }else{
        //预售
        NSString * time = [self nowDateDifferWithDate:model.startTime];
        string = [NSString stringWithFormat:@"距开始%@",time];

    }
    
    return string;
}
//获取日期格式化器
-(NSDateFormatter *)dateFormatWith:(NSString *)formatStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];//@"YYYY-MM-dd HH:mm:ss"
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    return formatter;
}

-(NSString*)nowDateDifferWithDate:(NSString*)timeString {
    
    long  late = [[NSDate timeStrToTimestamp:timeString] longLongValue];
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:data];
//    NSTimeInterval late=[confromTimesp timeIntervalSince1970]*1;
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970]*1;
    NSLog(@"nowDateDifferWithDate = %f=====当前时间==%f====差==%f分钟",late,now,(now-late)/60);
    
    _secondsCountDown = late - now ;
    
    //计算天数、时、分、秒
    
    long days = labs(((long)_secondsCountDown)/(3600*24) );
    long hours = labs(((long)_secondsCountDown)/3600 );
    long minutes =labs( ((long)_secondsCountDown)/60 );
    
    if (days>=1) {
        return [NSString stringWithFormat:@"%ld天",days];
    }else  if (hours>=1) {
        return [NSString stringWithFormat:@"%ld时",hours];
    }else{
        return [NSString stringWithFormat:@"%ld分",minutes];

    }
    return @"";
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}
@end
