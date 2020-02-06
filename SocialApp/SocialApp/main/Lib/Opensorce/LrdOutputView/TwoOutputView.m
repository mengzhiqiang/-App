//
//  LrdOutputView.m
//  LrdOutputView
//
//  Created by 键盘上的舞者 on 4/14/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import "TwoOutputView.h"
#import "LrdOutPutViewCell.h"
#import "MoreLrdFootView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CellLineEdgeInsets UIEdgeInsetsMake(0, 10, 0, 10)
#define LeftToView 10.f
#define TopToView 10.f

@interface TwoOutputView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) TwoLrdOutputViewDirection direction;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSMutableArray *selectArray;
@end

@implementation TwoOutputView
-(void)setTableViewHeight:(NSInteger)tableViewHeight {
    _tableViewHeight = tableViewHeight;
}
- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                        direction:(TwoLrdOutputViewDirection)direction {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        //背景色为clearColor
        self.backgroundColor = [UIColor clearColor];
        self.origin = origin;
        self.height = height;
        self.width = width;
        self.direction = direction;
        self.dataArray = dataArray;
        if (height <= 0) {
            height = 44;
        }
    
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TwoLrdCellModel *model = (TwoLrdCellModel *)obj;
            if (model.isSelect) {
                [self.selectArray addObject:model.title];
            }
        }];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, 238) style:UITableViewStylePlain];

        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =[UIColor whiteColor];
        _tableView.bounces = NO;
        //        _tableView.layer.cornerRadius = 2;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.bottom,SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:backView];
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:@"LrdOutPutViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        [self addSubview:self.tableView];
        
        //cell线条
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:CellLineEdgeInsets];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:CellLineEdgeInsets];
        }
    }
    return self;
}

#pragma mark 确定
- (void)okButtonAction {
    
    __block NSString *area = @"";
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TwoLrdCellModel *model = (TwoLrdCellModel *)obj;
        if (model.isSelect && idx!=0) {
            area = [area stringByAppendingFormat:@"%@,",model.title];
        }
    }];
    if (area.length) {
        area = [area substringWithRange:NSMakeRange(0, area.length-1)];
    }
    
    if ([self.delegate respondsToSelector:@selector(areaSelectWithString:)]) {
        [self.delegate areaSelectWithString:area];
    }
    [self dismiss];
}

#pragma mark 重置
- (void)resetButtonAction {
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TwoLrdCellModel *temp = (TwoLrdCellModel *)obj;
        temp.isSelect = NO;
    }];
    TwoLrdCellModel *temp = [self.dataArray objectAtIndex:0];
    temp.isSelect = YES;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LrdOutPutViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //取出模型
    TwoLrdCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.twoModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //通知代理处理点击事件
    TwoLrdCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if(indexPath.row == 0 && model.isSelect == NO) {
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TwoLrdCellModel *temp = (TwoLrdCellModel *)obj;
            temp.isSelect = NO;
        }];
    }else if (indexPath.row !=0) {
        TwoLrdCellModel *temp = [self.dataArray objectAtIndex:0];
        temp.isSelect = NO;
    }
    model.isSelect = !model.isSelect;
    if (model.isSelect) {
        [self.selectArray addObject:model.title];
    }else {
        [self.selectArray removeObject:model.title];
    }
    if (self.selectArray.count == 0) {
        [self resetButtonAction];
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:CellLineEdgeInsets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:CellLineEdgeInsets];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MoreLrdFootView *view = [[[NSBundle mainBundle]loadNibNamed:@"MoreLrdFootView" owner:self options:nil]lastObject];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 62);
    view.backgroundColor = [UIColor whiteColor];
    
    [view.okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
     [view.resetButton addTarget:self action:@selector(resetButtonAction) forControlEvents:UIControlEventTouchUpInside];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 62;
}
//画出尖尖
- (void)drawRect:(CGRect)rect {

}

- (void)pop {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    //动画效果弹出
    self.alpha = 0;
    CGRect frame = self.tableView.frame;
    self.tableView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        self.tableView.frame = frame;
    }];
}

- (void)dismiss {
    //动画效果淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.tableView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if (self.dismissOperation) {
                self.dismissOperation();
            }
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     //获取所有的触摸位置
       
       UITouch *touch = [touches anyObject];
       //触摸在self上
       CGPoint point = [touch locationInView:self];
       
       if (CGRectContainsPoint(self.tableView.frame, point) == NO) {
           [self dismiss];
       }
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end


#pragma mark - LrdCellModel

@implementation TwoLrdCellModel

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    TwoLrdCellModel *model = [[TwoLrdCellModel alloc] init];
    model.title = title;
    model.imageName = imageName;
    return model;

}
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"_id"];
    }
    if ([key isEqualToString:@"name"]) {
        [self setValue:value forKey:@"title"];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
