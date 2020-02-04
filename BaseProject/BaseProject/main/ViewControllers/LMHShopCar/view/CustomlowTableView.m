//
//  CustomlowTableView.m
//  BaseProject
//
//  Created by zhiqiang meng on 30/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "CustomlowTableView.h"
#import "LLRightCell.h"
@interface CustomlowTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *rootTableView;
@end

@implementation CustomlowTableView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
    }
    return self;
}
-(void)setUpUI{
    
    UIView* view = [[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = YES;
    //将触摸事件添加到当前view
    [view addGestureRecognizer:tapGestureRecognizer];
    
    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _rootTableView .frame = CGRectMake(0,  SCREEN_HEIGHT-54*3-49, SCREEN_WIDTH, 54*3+49);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rootTableView.sectionHeaderHeight = 0;
    _rootTableView.sectionFooterHeight = 0;
    _rootTableView.scrollEnabled = NO;
    _rootTableView.backgroundColor= Main_BG_Color;
    self.backgroundColor=Main_BG_Color;
    [ _rootTableView  registerClass:[LLRightCell class] forCellReuseIdentifier:@"LLRightCellid"];
    
    [self addSubview:_rootTableView];
    _rootTableView.userInteractionEnabled = YES;
}
-(void)hiddenView{
    self.hidden = YES;
}

-(void)setCostDiction:(NSDictionary *)costDiction{
    _costDiction = costDiction;
    [_rootTableView reloadData];
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LLRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLRightCellid"];
    cell.textview.hidden = YES;
    cell.showimage.hidden = YES;
    cell.rightlable.hidden = NO;
    cell.rightlable.textColor = Main_Color ;
    cell.titlelable.text = @[@"应付总额",@"余额抵扣",@"仍需支付"][indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            cell.rightlable.text = [NSString stringWithFormat:@"¥%.2f", [_costDiction[@"sum"] floatValue] ];
        }
            break;
        case 1:
        {
            cell.rightlable.text = [NSString stringWithFormat:@"¥%.2f",[_costDiction[@"balance"] floatValue]];
        }
            break;
        case 2:
        {
            cell.rightlable.text = [NSString stringWithFormat:@"¥%.2f",[_costDiction[@"pay"]floatValue]];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  49 ;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    view.backgroundColor = White_Color;
    
    UIButton * channleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    channleButton.frame = CGRectMake(15, 7, 65, 34);
    [channleButton  setTitle:@"取消" forState:UIControlStateNormal];
    [channleButton  setTitleColor:Main_Color forState:UIControlStateNormal];
    [channleButton addTarget:self action:@selector(channleOrder) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:channleButton];
    [channleButton draCirlywithColor:[UIColor colorWithRed:255.0f/255.0 green:125.0/255.0 blue:26.0/255.0 alpha:0.6] andRadius:5.0f];
    
    UIButton * PayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    PayButton.frame = CGRectMake(15+65+10, 7, SCREEN_WIDTH-(15+65+10+15), 34);
    [PayButton  setTitle:@"支付" forState:UIControlStateNormal];
    [PayButton  setTitleColor:White_Color forState:UIControlStateNormal];
    [PayButton addTarget:self action:@selector(PayOrder) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:PayButton];
    PayButton.backgroundColor = Main_Color;
    [PayButton draCirlywithColor:nil andRadius:5.0f];
    
    return view;
}

-(void)channleOrder{
    if (_backPay) {
        self.hidden = YES;
        _backPay(@"2");
    }}


-(void)PayOrder{
    
    if (_backPay) {
        self.hidden = YES;
        _backPay(@"1");
    }
}


@end
