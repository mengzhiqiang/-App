//
//  UICollectionView+AddRefresh.m
//  Wisdomfamily
//
//  Created by libj on 2019/6/6.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "UICollectionView+AddRefresh.h"
@implementation UICollectionView (AddRefresh)


- (void) addRefreshForPullDown:(refreshAction)PullDown PullUp:(refreshAction)PullUp{
    [self addRefreshForPullDown:PullDown];
    [self addRefreshForPullUp:PullUp];
}

- (void)addRefreshForPullDown:(refreshAction)PullDown{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        PullDown();
    }];
    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    // 隐藏状态
//    header.stateLabel.hidden = YES;
    //    header.arrowView.image = [UIImage imageNamed:@"refresh_down2"];
    //    header.stateLabel.textColor = [UIColor hex:@"#9D9D9D"];
    self.mj_header = header;
}

- (void)addRefreshForPullUp:(refreshAction)PullUp{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        PullUp();
    }];
    
    NSString *str =  @"暂无更多" ;
    
    [footer setTitle:str forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = FontSize(15); 
    footer.stateLabel.textColor = Sub_title_Color;
    self.mj_footer = footer;
}

- (void)endRefresh{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)NoMoreData{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)MoreData{
    [self.mj_footer resetNoMoreData];
}


@end
