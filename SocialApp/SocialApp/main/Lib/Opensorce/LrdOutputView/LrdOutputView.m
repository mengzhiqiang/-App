//
//  LrdOutputView.m
//  LrdOutputView
//
//  Created by 键盘上的舞者 on 4/14/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import "LrdOutputView.h"
#import "LrdOutPutViewCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CellLineEdgeInsets UIEdgeInsetsMake(0, 0, 0, 0)
#define LeftToView 10.f
#define TopToView 10.f

@interface LrdOutputView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) LrdOutputViewDirection direction;
/**
 *  是否处于选择状态
 */
@property (nonatomic,assign) BOOL isSelted;
@end

@implementation LrdOutputView

- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                        direction:(LrdOutputViewDirection)direction {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        //背景色为clearColor
//        self.backgroundColor = [UIColor purpleColor];
        self.origin = origin;
        self.height = height;
        self.width = width;
        self.direction = direction;
        self.dataArray = dataArray;
        if (height <= 0) {
            height = 44;
        }
        if (direction == kLrdOutputViewDirectionLeft) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, 88) style:UITableViewStylePlain];
        }else {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, -width, 88) style:UITableViewStylePlain];
        }
        
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =[UIColor whiteColor];
        _tableView.bounces = NO;
//        _tableView.layer.cornerRadius = 2;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
    
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
        self.isSelted = NO;
    }
    return self;
}


-(void)setTableViewHeight:(NSInteger)tableViewHeight
{
    _tableViewHeight = tableViewHeight;
//    self.tableView.height = tableViewHeight;
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
    LrdCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
  
    cell.LrdCellModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self.selectIndex == indexPath.row) {
        cell.contentLabel.textColor = HKColor(@"#00A2E7");
        cell.pictureImageView.image = UIImageName(@"btn_choose");
        cell.pictureImageView.hidden = NO;
    }else {
        cell.pictureImageView.hidden = YES;
        cell.contentLabel.textColor = rgba(51, 51, 51, 1);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LrdOutPutViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.textColor = HKColor(@"#00A2E7");
    cell.pictureImageView.image = UIImageName(@"btn_choose");
    cell.pictureImageView.hidden = NO;
    
    //通知代理处理点击事件
    if ([self.delegate respondsToSelector:@selector(didSelectedAtIndexPath:)]) {
        [self.delegate didSelectedAtIndexPath:indexPath];
    }
    
    [self dismiss];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:CellLineEdgeInsets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:CellLineEdgeInsets];
    }
}

//画出尖尖
- (void)drawRect:(CGRect)rect {
    //拿到当前视图准备好的画板
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //利用path进行绘制三角形
//    CGContextBeginPath(context);//标记
//
//    if (self.direction == kLrdOutputViewDirectionLeft) {
//        CGFloat startX = self.origin.x + 80;
//        CGFloat startY = self.origin.y;
//        CGContextMoveToPoint(context, startX, startY);//设置起点
//
//        CGContextAddLineToPoint(context, startX + 5, startY - 5);
//
//        CGContextAddLineToPoint(context, startX + 10, startY);
//    }else {
//        CGFloat startX = self.origin.x - 20;
//        CGFloat startY = self.origin.y;
//        CGContextMoveToPoint(context, startX, startY);//设置起点
//
//        CGContextAddLineToPoint(context, startX + 5, startY - 5);
//
//        CGContextAddLineToPoint(context, startX + 10, startY);
//    }
//
//    CGContextClosePath(context);//路径结束标志，不写默认封闭
//
//    [self.tableView.backgroundColor setFill]; //设置填充色
//
//
//    [self.tableView.backgroundColor setStroke];
//
//    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    

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

@end


#pragma mark - LrdCellModel

@implementation LrdCellModel

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    LrdCellModel *model = [[LrdCellModel alloc] init];
    model.title = title;
    model.imageName = imageName;
    return model;
}

@end
