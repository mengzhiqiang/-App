//
//  LMHVideoPlayVC.h
//  BaseProject
//
//  Created by wfg on 2019/9/7.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMHVideoPlayVC : LMHBaseViewController

@property (nonatomic, assign) NSInteger videoType; // 1 直播，0 短视频

@property(nonatomic ,strong) NSString * videoID;

@property(nonatomic ,assign) BOOL  isBrocadcast;

@end

NS_ASSUME_NONNULL_END
