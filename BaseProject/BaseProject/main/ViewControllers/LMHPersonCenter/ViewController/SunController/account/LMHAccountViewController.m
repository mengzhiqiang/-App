//
//  LMHAccountViewController.m
//  BaseProject
//
//  Created by wfg on 2019/9/3.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAccountViewController.h"
#import "LMHAccountDetailVC.h"
@interface LMHAccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *availableLbl;
@property (weak, nonatomic) IBOutlet UILabel *freezeProfitLbl;
@property (weak, nonatomic) IBOutlet UILabel *freezeRewardLbl;

@end

@implementation LMHAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"我的账户";
    [self.customNavBar wr_setRightButtonWithTitle:@"查看明细" titleColor:Main_Color];
    WS(weakself);
    self.customNavBar.onClickRightButton = ^{
        LMHAccountDetailVC *vc = [[LMHAccountDetailVC alloc] initWithNibName:@"LMHAccountDetailVC" bundle:[NSBundle mainBundle]];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getMyAccount];
}

-(void)getMyAccount{
    
    NSString * url = [API_HOST stringByAppendingString:client_order_getMyAccount];
    
    WS(weakself);
    [HttpEngine requestPostWithURL:url params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [weakself loadData: responseObject[@"data"]];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)loadData:(NSDictionary*)diction
{
    if (diction==nil) {
        return ;
    }
    _availableLbl.text = [NSString stringWithFormat:@"%.2f", [diction[@"balance"] floatValue]];
    _freezeProfitLbl.text = [NSString stringWithFormat:@"%.2f",[diction[@"bonus"] floatValue]];
    _freezeRewardLbl.text = [NSString stringWithFormat:@"%.2f",[diction[@"freezeRebate"]floatValue]];

}

@end
