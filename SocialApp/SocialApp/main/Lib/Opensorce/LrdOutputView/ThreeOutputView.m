//
//  LrdOutputView.m
//  LrdOutputView
//
//  Created by 键盘上的舞者 on 4/14/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import "ThreeOutputView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CellLineEdgeInsets UIEdgeInsetsMake(0, 10, 0, 10)
#define LeftToView 10.f
#define TopToView 10.f

@interface ThreeOutputView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) ThreeLrdOutputViewDirection direction;

@end

@implementation ThreeOutputView

- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                        direction:(ThreeLrdOutputViewDirection)direction {
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
        if (direction == ThreekLrdOutputViewDirectionLeft) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, 119) style:UITableViewStylePlain];
        }else {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, -width,119) style:UITableViewStylePlain];
        }
        
//        _tableView.separatorColor = [UIColor clearColor];
        
        _tableView.backgroundColor = Main_BG_Color;
        
        _tableView.bounces = YES;
        _tableView.layer.cornerRadius = 2;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //注册cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
   
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = [UIColor clearColor];
    //取出模型
    ThreeLrdCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    if (model.isPay == YES) {
        
        cell.textLabel.text = model.title;
        cell.textLabel.textColor = Main_title_Color;
       
        
    }
    else if (model.isDraft == YES){
          cell.textLabel.text =[NSString stringWithFormat:@"单价：%@，数量：%@",model.price,model.total];
        cell.textLabel.textColor = Sub_title_Color;

    }
    
    else{
        if (model.amount.length == 0) {
            cell.textLabel.text = @"取消优惠劵";
        }
        else{
            cell.textLabel.text =[NSString stringWithFormat:@"￥%@，%@（%@满减劵）",model.amount,model.title,model.product_name];
            
        }
        cell.textLabel.textColor = rgba(254, 142, 6, 1);


    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    cell.textLabel.numberOfLines = 0;
   
 
//有图片才赋值
    if (model.imageName) {
        cell.imageView.image = [UIImage imageNamed:model.imageName];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor blackColor];
//    cell.contentView.backgroundColor = [UIColor purpleColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self dismissByIndexPath:indexPath];
    
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
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    
    if (self.direction == ThreekLrdOutputViewDirectionLeft) {
        CGFloat startX = self.origin.x + 20;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
        
        CGContextAddLineToPoint(context, startX + 10, startY);
    }else {
        CGFloat startX = self.origin.x - 20;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
        
        CGContextAddLineToPoint(context, startX + 10, startY);
    }
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [self.tableView.backgroundColor setFill]; //设置填充色
    
    
    [self.tableView.backgroundColor setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    

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
-(void)dismissByIndexPath:(NSIndexPath*)indexpath{
    //动画效果淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.tableView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            //通知代理处理点击事件
            if ([self.delegate respondsToSelector:@selector(TwodidSelectedAtIndexPath:dataArr:)]) {
                [self.delegate TwodidSelectedAtIndexPath:indexpath dataArr:self.dataArray];
            }
            if (self.dismissOperation) {
                self.dismissOperation();
            }
        }
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

@implementation ThreeLrdCellModel

//- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
//    TwoLrdCellModel *model = [[TwoLrdCellModel alloc] init];
//    model.title = title;
//    model.imageName = imageName;
//    return model;
//}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self._id = value;
    }
    if ([key isEqualToString:@"name"]) {
        self.title = value;
    }
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
