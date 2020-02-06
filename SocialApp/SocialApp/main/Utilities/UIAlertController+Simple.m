//
//  UIAlertController+Simple.m
//  ZCBus
//
//  Created by wfg on 2019/8/23.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "UIAlertController+Simple.h"

@implementation UIAlertController (Simple)
+ (UIAlertController *)showWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    return alert;
}

+ (UIAlertController *)showWithMessage:(NSString *)message confirm:(void (^ _Nullable)(UIAlertAction * _Nonnull))confirm {
    return [self showWithTitle:nil message:message confirm:confirm];
}

+ (UIAlertController *)showWithTitle:(NSString *)title message:(NSString *)message confirm:(void (^ _Nullable)(UIAlertAction * _Nonnull))confirm {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:confirm];
    [alert addAction:action];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    
    [action setValue:Main_Color forKey:@"_titleTextColor"];
    [action1 setValue:Main_Color forKey:@"_titleTextColor"];

    return alert;
}


+ (UIAlertController *)showSheetTitles:(NSArray *)titles backIndex:(void(^)(UIAlertAction *UIAlertAction, NSInteger index))backIndex {
    return [self showSheetTitles:titles titleColor:Main_Color cancelColor:[UIColor colorWithHexValue:0xBABFCD] backIndex:backIndex];
}

+ (UIAlertController *)showSheetTitles:(NSArray *)titles titleColor:(UIColor *)titleColor cancelColor:(UIColor *)cancelColor backIndex:(void(^)(UIAlertAction *UIAlertAction, NSInteger index))backIndex {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i=0 ;i<titles.count;i++) {
        NSString * string = titles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (backIndex) {
                backIndex(action, i);
            }
        }];
        if (titleColor) {
            [action setValue:titleColor forKey:@"_titleTextColor"];
        }
        [actionSheet addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"取消");
    }];
    if (cancelColor) {
        [action setValue:cancelColor forKey:@"_titleTextColor"];
    }
    [actionSheet addAction:action];
    return actionSheet;
}

+ (UIAlertController *)showSheetShare:(NSArray *)titles titleColor:(UIColor *)titleColor cancelColor:(UIColor *)cancelColor backIndex:(void(^)(UIAlertAction *UIAlertAction, NSInteger index))backIndex {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
 
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT-100, SCREEN_WIDTH-30, 80)];
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake( 10,10,50, 50);
    btn.backgroundColor = [UIColor redColor];
    [view addSubview:btn];
    
    [actionSheet.view addSubview:view];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"取消");
    }];
    if (cancelColor) {
        [action setValue:cancelColor forKey:@"_titleTextColor"];
    }
    [actionSheet addAction:action];
    return actionSheet;
}


@end
