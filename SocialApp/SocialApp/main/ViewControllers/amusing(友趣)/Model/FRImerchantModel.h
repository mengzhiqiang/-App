//
//  FRImerchantModel.h
//  SocialApp
//
//  Created by zhiqiang meng on 6/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FRImerchantModel : NSObject


@property(nonatomic ,retain) NSString * evaluate;

@property(nonatomic ,retain) NSString * detailedAddress;
@property(nonatomic ,assign) CGFloat  latitude;
@property(nonatomic ,assign) CGFloat  longitude;
@property(nonatomic ,retain) NSString * merchantAddress;

@property(nonatomic ,retain) NSString * merchantName;
@property(nonatomic ,copy) NSString * collect;
@property(nonatomic ,retain) NSString * shopIntroduce;

@property(nonatomic ,copy) NSString * merchantId;
@property(nonatomic ,retain) NSString * merchantImg;
@property(nonatomic ,retain) NSString * shopPhone;
@property(nonatomic ,retain) NSString * shopTime;


@end

NS_ASSUME_NONNULL_END
