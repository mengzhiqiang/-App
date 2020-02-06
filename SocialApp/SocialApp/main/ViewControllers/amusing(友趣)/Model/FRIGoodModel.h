//
//  FRIGoodModel.h
//  SocialApp
//
//  Created by zhiqiang meng on 3/2/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FRIGoodModel : NSObject

@property(nonatomic ,retain) NSString * commodityId;
@property(nonatomic ,retain) NSString * commodityImg;
@property(nonatomic ,retain) NSString * commodityName;
@property(nonatomic ,retain) NSString * commodityIntroduce;
@property(nonatomic ,retain) NSString * merchantId;
@property(nonatomic ,retain) NSString * commodityPrice;
@property(nonatomic ,retain) NSString * commodityDetails;
@property(nonatomic ,retain) NSString * putaway;
@property(nonatomic ,retain) NSString * creatTime;
@property(nonatomic ,retain) NSString * advanceHour;   //提前退订
@property(nonatomic ,retain) NSString * sort;
@property(nonatomic ,retain) NSString * maxNum;        //最大人数


@end

NS_ASSUME_NONNULL_END
