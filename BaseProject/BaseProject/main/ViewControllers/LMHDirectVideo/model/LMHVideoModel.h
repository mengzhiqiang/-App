//
//  LMHVideoModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 22/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHVideoModel : NSObject

@property(nonatomic ,strong) NSString * videoName;
@property(nonatomic ,strong) NSString * logo;
@property(nonatomic ,strong) NSString * brandName;
@property(nonatomic ,strong) NSString * brandId;
@property(nonatomic ,strong) NSString * playUrl;
@property(nonatomic ,strong) NSString * goodsPrice;
@property(nonatomic ,strong) NSString * scheduleId;


@property(nonatomic ,strong) NSString * playTimeStart;
@property(nonatomic ,strong) NSString * playTimeEnd;

/**
 跳转类型
 */
@property(nonatomic ,strong) NSString * entranceType;
@property(nonatomic ,strong) NSString * entranceContent;

@property(nonatomic ,strong) NSString * identifier;


@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *liveId;
//直播状态0-待播放 1-播放中 2-已结束-1-已作废
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *liveName;
@end

NS_ASSUME_NONNULL_END
