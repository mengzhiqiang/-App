//
//  LMHAfterSaleApplyVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAfterSaleApplyVC.h"
#import "ZWTextView.h"
#import "LMHAfterSaleApplySuccessVC.h"
#import "JFJOrderTableViewCell.h"

@interface LMHAfterSaleApplyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *desLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (strong, nonatomic) IBOutlet UILabel *summaryLbl;

@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (strong, nonatomic) ZWTextView *reasonTextField;
@property (strong, nonatomic)  UITableView *rootTableView;
@property (weak, nonatomic) IBOutlet UIView *lowView;
@end

@implementation LMHAfterSaleApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"售后/退货";
   _reasonTextField = [[ZWTextView alloc] initWithFrame:CGRectMake(15,30,SCREEN_WIDTH-30,80) TextFont:[UIFont systemFontOfSize:13] MoveStyle:styleMove_Down];
//    textView.maxNumberOfLines = 4;
//    textView.maxLength = 200;
    
    _orderIdLbl.text = [NSString stringWithFormat:@"订单号：%@",_model.postageSn];
//    [_iv setImageWithURL:[_model.brand.goodLogo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
//    _contentLbl.text = _model.brand.goodName;
//    _desLbl.text = [NSString stringWithFormat:@"规格：%@",_model.brand.specificationName];
//    _amountLbl.text = [NSString stringWithFormat:@"¥%@",_model.brand.sellPrice];
//    _numLbl.text = [NSString stringWithFormat:@"x%@",_model.brand.num];
    
    int count  = 0;
    float price = 0;
    for (NSDictionary*dic in _model.brand.goodInfos) {
        price = price+[dic[@"sellPrice"] floatValue];
        count = count+[dic[@"num"] intValue];
    }
    _summaryLbl.text = [NSString stringWithFormat:@"共%d件商品 合计：¥%.2f",count,price];
    _summaryLbl.attributedText = [NSString PriceStringWithContent:_summaryLbl.text andTitle:[NSString stringWithFormat:@"¥ %.2f",price] color:[UIColor redColor]];
//
   _reasonTextField.placeholder = @"请填写售后原因";
//    textView.inputText = @"";
    _reasonTextField.textColor = Main_title_Color;
    _reasonTextField.backgroundColor = [UIColor whiteColor];
    [self.reasonView addSubview:_reasonTextField];
//    [_reasonTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.reasonView).insets(UIEdgeInsetsMake(30, 16, 8, 16));
//    }];
    
    NSLog(@"===%@",_model.brand.goodInfos);
    [self addTable];
}

-(void)addTable{
    
    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_top-50) style:UITableViewStyleGrouped];
       _rootTableView .frame = CGRectMake(0,  SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_top-60-iphoneXTab);
       _rootTableView.delegate=self;
       _rootTableView.dataSource=self;
       _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       _rootTableView.sectionHeaderHeight = 0 ;
       _rootTableView.sectionFooterHeight = 0;
       _rootTableView.backgroundColor= Main_BG_Color;
       self.view.backgroundColor=Main_BG_Color;
//       [ _rootTableView  registerClass:[LLRightCell class] forCellReuseIdentifier:LLRightCellid];

       [self.view addSubview:_rootTableView];
}

- (IBAction)confirmAction:(UIButton *)sender {
   
    [self submintAfterOrder];
}

#pragma mark 提交售后
-(void)submintAfterOrder{
    NSString *path = [API_HOST stringByAppendingString:client_order_submitAfterSales];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    if (_reasonTextField.text.length<10) {
        [MBProgressHUD showError:@"退款描述不能少于10个字"];
        return;
    }
    if (_reasonTextField.text.length>200) {
        [MBProgressHUD showError:@"退款描述不能多于200个字"];
        return;
    }
    
    [diction setObject:_reasonTextField.text forKey:@"cause"];
    [diction setObject:_model.identifier forKey:@"orderId"];
    [diction setObject:@"2" forKey:@"type"];
    
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"=订单==%@",responseObject );
        LMHAfterSaleApplySuccessVC *vc = [[LMHAfterSaleApplySuccessVC alloc] initWithNibName:@"LMHAfterSaleApplySuccessVC" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"订单=code==%@",Dic_data);
        [MBProgressHUD showError:Dic_data[@"msg"]];
        
    }];
    
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _model.brand.goodInfos.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"JFJOrderTableViewCell";
       JFJOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       
   if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JFJOrderTableViewCell" owner:self options:nil] objectAtIndex:2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
   }

    if (_model.brand.goodInfos.count>indexPath.row) {
        
        NSDictionary* dic = _model.brand.goodInfos[indexPath.row];
        [cell.threeImageView setImageWithURL:[dic[@"pictue"] changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
        cell.threeTitleLable.text = dic[@"goodsName"];
        cell.threeSubLabel.text = [NSString stringWithFormat:@"规格：%@",dic[@"specificationName"]];
        cell.threePriceLabel.text = [NSString stringWithFormat:@"¥%@",dic[@"sellPrice"]];
        cell.threeCountLabel.text = [NSString stringWithFormat:@"x%@",dic[@"num"]];

    }
//    if (_goodModelArray.count>indexPath.row) {
        
//        LMHGoodSpecifiaModel * specModel = _specifiModeArray[indexPath.row];
//        LMHOrderGoodModel * goodModel = _goodModelArray[indexPath.row];
//        [cell.goodsImageView setImageWithURL:[goodModel.pictue changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
//        cell.goodsDetailLabel.text = goodModel.goodsName;
//        cell.stateLabel.text = [NSString stringWithFormat:@"%@  x%@",specModel.specificationName,specModel.num];
//        cell.priceLabel.text = [NSString stringWithFormat:@"结算价格：¥ %.2f",specModel.sellPrice.floatValue];
//        cell.priceLabel.attributedText = [NSString PriceStringWithContent:cell.priceLabel.text andTitle:[NSString stringWithFormat:@"¥ %.2f",specModel.sellPrice.floatValue] color:[UIColor redColor]];
//        cell.priceLabel.left = cell.goodsDetailLabel.left;
//    }
    
    return   cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * View  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    UIView * View1  = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 39)];
    View1.backgroundColor= [UIColor whiteColor] ;
    _orderIdLbl.frame = CGRectMake(16, 10, 260, 20);
   [View1 addSubview:_orderIdLbl];
    
    [View addSubview:View1];
    return View;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 180;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * View  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    View.backgroundColor= Main_BG_Color ;
  
   [View addSubview:_lowView];

    return View;
}

@end
