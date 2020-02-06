//
//  FRIActiveModel.h
//  SocialApp
//
//  Created by zhiqiang meng on 6/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FRIActiveListModel : NSObject

@property(nonatomic ,retain) NSString * activityName;
@property(nonatomic ,retain) NSString * activityNum;
@property(nonatomic ,retain) NSString * activityTime;
@property(nonatomic ,retain) NSString * activityId;

@property(nonatomic ,retain) NSString * commodityImg;
@property(nonatomic ,retain) NSString * detailedAddress;
@property(nonatomic ,retain) NSString * orderId;
@property(nonatomic ,retain) NSString * orderNum;
@property(nonatomic ,retain) NSString * orderStutas;
@property(nonatomic ,retain) NSString * peopleNum;
@property(nonatomic ,retain) NSString * activityAve;

@property(nonatomic ,retain) NSString * advanceHour;
@property(nonatomic ,retain) NSString * gatherAmount;


@property (nonatomic,strong) NSString *activitySponsor;       // 组团类型 1:用户 2:商家

@property(nonatomic ,retain) NSString * requireEducation;//学历要求 0:不限，1:大学专科以下，2:大学专科，3:大学本科，4:研究生硕士，5:研究生博士
@property(nonatomic ,retain) NSString * requireMarriage; // 婚恋状况 0:不限，1:单身，2:非单身
@property(nonatomic ,retain) NSString * requireSex;     // 性别 1:同性，2:不限
@property(nonatomic ,retain) NSString * requireAge;

@property(nonatomic ,retain) NSString * merchantAddress;
@property(nonatomic ,retain) NSString * merchantName;
@property(nonatomic ,retain) NSString * merchantImg;

@property(nonatomic ,retain) NSString * commodityName;
@property(nonatomic ,retain) NSString * commodityPrice;
@property(nonatomic ,retain) NSString * commodityIntroduce;
@property(nonatomic ,retain) NSString * commodityDetails;


@end

NS_ASSUME_NONNULL_END
