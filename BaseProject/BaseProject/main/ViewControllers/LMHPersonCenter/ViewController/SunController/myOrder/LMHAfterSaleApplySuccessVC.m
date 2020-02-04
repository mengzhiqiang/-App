//
//  LMHAfterSaleApplySuccessVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAfterSaleApplySuccessVC.h"
#import "LMHAfterSaleVC.h"
#import "LMHAfterSaleDetailVC.h"
@interface LMHAfterSaleApplySuccessVC ()

@end

@implementation LMHAfterSaleApplySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"申请成功";
}

- (IBAction)recordAction:(UIButton *)sender {
    LMHAfterSaleDetailVC *vc = [LMHAfterSaleDetailVC new];
    vc.orderID = self.model.identifier;
    
    [self.navigationController pushViewController:vc animated:YES];
    NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
    self.navigationController.viewControllers = @[arr.firstObject, arr.lastObject];
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
