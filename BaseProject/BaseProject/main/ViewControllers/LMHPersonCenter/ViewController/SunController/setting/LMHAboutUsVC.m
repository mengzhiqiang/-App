//
//  LMHAboutUsVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/3.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHAboutUsVC.h"

@interface LMHAboutUsVC ()
@property (weak, nonatomic) IBOutlet UILabel *versionLbl;

@end

@implementation LMHAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"设置";
    NSDictionary* info = [[NSBundle mainBundle] infoDictionary];
    self.versionLbl.text = [NSString stringWithFormat:@"V%@", info[@"CFBundleShortVersionString"]];
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
