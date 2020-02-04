//
//  BaseNavigationViewController.m
//  DajingTravel
//
//  Created by 杨波 on 2018/10/8.
//  Copyright © 2018年 ebenny. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

+ (void)initialize
{
    
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    //设置整个项目所有nav的主题样式
    NSDictionary *navbarAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor whiteColor] ,NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarAttributes];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor HexString :@"fc4349"]];
    [navBar setTitleTextAttributes:navbarAttributes];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //    基本配置
    self.navigationBar.backgroundColor = White_Color;
    UINavigationBar *navigationBar = self.navigationBar;

        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
            self.edgesForExtendedLayout=UIRectEdgeNone;
            self.navigationBar.translucent = NO;
        }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 事件 --
- (void)popViewController{
    [MBProgressHUD hideActivityIndicator];
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        //设置导航栏按钮
        UIImage *leftImage = [UIImage imageNamed:@"nav_btn_back_black"];
        leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
        viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

    }
    [super pushViewController:viewController animated:animated];
    //解决没有导航栏的页面跳转导航栏白色闪现问题
    [self setNavigationBarHidden:NO animated:YES];
}

- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}


@end
