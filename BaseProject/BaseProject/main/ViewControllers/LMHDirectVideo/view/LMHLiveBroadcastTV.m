//
//  LMHLiveBroadcastTV.m
//  BaseProject
//
//  Created by wfg on 2019/9/7.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHLiveBroadcastTV.h"
#import "LMHLiveBroadcastCell.h"
#import <AVKit/AVKit.h>
#import "UIViewController+Extension.h"
#import "SJVideoPlayer.h"
#import "LMHVideoPlayVC.h"
#import "LMHGoodsDetailVC.h"

@interface LMHLiveBroadcastTV ()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation LMHLiveBroadcastTV

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self registerNib:[UINib nibWithNibName:@"LMHLiveBroadcastCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 273;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMHLiveBroadcastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        LMHGoodsDetailVC *vc = [[LMHGoodsDetailVC alloc] initWithNibName:@"LMHGoodsDetailVC" bundle:[NSBundle mainBundle]];
        [[UIViewController getCurrentController].navigationController pushViewController:vc animated:YES];
        return;
    }
    LMHVideoPlayVC *vc = [LMHVideoPlayVC new];
    [[UIViewController getCurrentController].navigationController pushViewController:vc animated:YES];

}



@end
