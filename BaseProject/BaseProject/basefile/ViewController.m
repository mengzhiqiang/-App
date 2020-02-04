//
//  ViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 19/6/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "ViewController.h"
#import "HotelCalendarViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HotelCalendarViewController *vc = [[HotelCalendarViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [vc setSelectCheckDateBlock:^(NSString *startDateStr, NSString *endDateStr, NSString *daysStr) {
        //        weakSelf.startDateLabel.text = startDateStr;
        //        weakSelf.endDateLabel.text = endDateStr;
//        weakSelf.sleepDateLabel.text = [NSString stringWithFormat:@"%@  ————  %@",startDateStr,endDateStr];
//        weakSelf.sleepCountLabel.text = [NSString stringWithFormat:@"入住 %@ 晚",daysStr];
        NSLog(@"===%@===%@===%@",startDateStr,endDateStr,daysStr);
    }];
    
    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"===%@===",vc);

}

@end
