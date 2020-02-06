//
//  LMHTabBarViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 28/6/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//ces 

#import "LMHTabBarViewController.h"
#import "FRIHomeListViewController.h"
#import "FRIAmusingViewController.h"
#import "FRIMettingViewController.h"
#import "FRIMineViewController.h"
#import "BaseNavigationViewController.h"
@interface LMHTabBarViewController ()<UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation LMHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //添加所有的子控制器
    [self addAllChildVcs];
    self.tabBar.backgroundColor = [UIColor whiteColor];

}
//添加所有的子控制器
-(void)addAllChildVcs{
    [self addOneChildVc:[[FRIHomeListViewController alloc] init] andTitle:@"才友" andImageName:@"tab_btn_caiyou_default" andSelectedImageName:@"tab_btn_caiyou_pressed"];
    [self addOneChildVc:[[FRIAmusingViewController alloc] init] andTitle:@"友趣" andImageName:@"tab_btn_youqu_default" andSelectedImageName:@"tab_btn_youqu_pressed"];
    [self addOneChildVc:[[FRIMettingViewController alloc] init] andTitle:@"友遇" andImageName:@"tab_btn_youyu_default" andSelectedImageName:@"tab_btn_youyu_pressed"];
    [self addOneChildVc:[[FRIMineViewController alloc]init] andTitle:@"我的" andImageName:@"tab_btn_my_default" andSelectedImageName:@"tab_btn_my_pressed"];
    
    [self  changeLineOfTabbarColor ];
}


- (void)changeLineOfTabbarColor {
    CGRect rect = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.5);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#f5f5f5"].CGColor);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:image];
    [self.tabBar setBackgroundImage:[UIImage new]];
    
}
-(void)addOneChildVc:(UIViewController *)childVc andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectedImageName:(NSString *)selectedImageName{
    
    //设置标题:相当于同时设置了tabBarItem.title和navigationItem.title
    childVc.title = title;
    //设置图标
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置tabBarItem的普通文字颜色
    
    NSMutableDictionary *textAttrs = [[NSMutableDictionary alloc] init];
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = Main_Color;
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    //设置选中后的图标
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    childVc.title = title;
    // 添加为tabbar控制器的子控制器
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [UITabBarAppearance new];
        // 设置未被选中的颜色
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor grayColor]};
        // 设置被选中时的颜色
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName: Main_Color};
        childVc.tabBarItem.standardAppearance = appearance;
        self.tabBar.tintColor = Main_Color;

    } else {
        [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: Main_Color} forState:UIControlStateSelected];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITabBarControllerDelegate
//根据BOOL值来判断是否处于可继续点击状态
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
    return YES;
}

@end
