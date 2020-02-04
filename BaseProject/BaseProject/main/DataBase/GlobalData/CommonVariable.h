//
//  NETworking.m
//  ALPHA
//
//  Created by teelab2 on 14-5-15.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "LMHPersonCenterModel.h"
@interface CommonVariable : NSObject


/**************************************************************
 ** 功能:     获取单例
 ** 参数:     无
 ** 返回:     commonvariable对象
 **************************************************************/
@property(strong, nonatomic) LMHPersonCenterModel * personModel ;

+ (id)shareCommonVariable;

+(void)saveWithModle:(UserInfo*)info;
/**
 保存个人信息
 */
+ (void)saveUserInfoDataWithResponseObject:(NSDictionary *)userInfo;

/**
 获取个人信息
 */
+(UserInfo *)getUserInfo;

/**
 保存个人信息
 */
+ (void)removeUserInfoData;

@end
