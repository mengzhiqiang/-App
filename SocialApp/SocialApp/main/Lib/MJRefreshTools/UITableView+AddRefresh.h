//
//  UITableView+AddRefresh.h
//  Wisdomfamily
//
//  Created by libj on 2019/6/6.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^refreshAction)(void);

@interface UITableView (AddRefresh)

/**
 添加上拉下拉控件
 */
- (void)addRefreshForPullDown:(refreshAction)PullDown PullUp:(refreshAction)PullUp;

/**
 添加下拉控件
 */
- (void)addRefreshForPullDown:(refreshAction)PullDown;

/**
 添加上拉控件
 */
- (void)addRefreshForPullUp:(refreshAction)PullUp;

- (void)endRefresh;
- (void)NoMoreData;
- (void)MoreData;

@end

NS_ASSUME_NONNULL_END
