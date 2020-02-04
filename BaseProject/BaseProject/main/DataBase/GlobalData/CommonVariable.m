//
//  NETworking.m
//  ALPHA
//
//  Created by teelab2 on 14-5-15.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//


#import "CommonVariable.h"
#import "HttpRequestToken.h"
static CommonVariable *commVari = nil;
@implementation CommonVariable
/**************************************************************
 ** 功能:     获取单例
 ** 参数:     无
 ** 返回:     commonvariable对象
 **************************************************************/
+ (id)shareCommonVariable{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //注意：这里建议使用self,而不是直接使用类名（考虑继承）
        commVari = [[self alloc] init];
    });
    return commVari;
}

-(void)setPersonModel:(LMHPersonCenterModel *)personModel{
    _personModel = personModel;
}

+(void)saveWithModle:(UserInfo*)info{
    
    NSDictionary *dic = [info mj_keyValues];
    [self saveUserInfoDataWithResponseObject:dic];
}
/**
保存个人信息
*/
+ (void)saveUserInfoDataWithResponseObject:(NSDictionary *)userInfo
{
    if (userInfo[@"token"]) {
        [HttpRequestToken saveToken:userInfo[@"token"]];
    }

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:FWRUserInformation];
    
    if (userInfo) {
        //归档保存数据
        // 方法1：NSKeyedArchiver
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        BOOL isKeyed = [NSKeyedArchiver archiveRootObject:data toFile:filePath];
        if (isKeyed) {
            NSLog(@"个人信息保存成功");
        }
    }
}

//获取个人信息
+ (UserInfo *)getUserInfo
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:FWRUserInformation];
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (model) {
        NSDictionary *dict = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:model];
        if (dict) {
            UserInfo *user_Model = [UserInfo mj_objectWithKeyValues:dict];
            return user_Model;
        }
    }
  
    return nil;
}

/**
 删除个人信息
 */
+ (void)removeUserInfoData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kSmartDeviceLoginTokenKey];
    

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:FWRUserInformation];
        //归档保存数据
        // 方法1：NSKeyedArchiver
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];

}

@end
