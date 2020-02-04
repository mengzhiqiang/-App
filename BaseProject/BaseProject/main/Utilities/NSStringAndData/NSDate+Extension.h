//
//  NSDate+Extension.h
//  CompareTimeDemo
//
//  Created by admin on 16/6/1.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  获取当前时间戳
 *
 *  @return 返回时间戳字符串
 */
+ (NSString *)getCurrentTime;
/**
 *  获取当前时间
 *
 *  @return 返回 yyyy-MM-dd HH:mm:ss 格式时间字符串
 */
+ (NSString *)getCurrentDataTime;
/**
 *  当前时间与记录时间对比
 *
 *  @param dataString 记录时间
 *
 *  @return 返回是否超时
 */
+ (BOOL)compareDataTime:(NSString *)dataString;


/*
  时间长度（单位秒）
  转换格式为分：秒 mm:ss
 
 */
+(NSString*)changeTimeOfTimeInterval:(NSString*)timeInterval;

+ (NSDictionary *)resetNewUserInfoWithOldObject:(NSDictionary*)oldObject;

/*
 时间戳转日期格式
 */
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
/**
//将时间字符串转换为时间戳
 */
+ (NSString *)timeStrToTimestamp:(NSString *)timeStr;
    

/**
 品牌 排期 倒计时
 */
+ (NSMutableAttributedString*)distanceTime:(NSString *)dataString;


+(NSMutableAttributedString*)BgColor:(NSString*)content andTitle:(NSString*)title;

/**
 <#Description#>
 
 @param dateStr <#dateStr description#>
 @param format <#format description#>
 @return <#return value description#>
 */
+(NSString *)stringConversionNSDateStr:(NSString *)dateStr formatter:(NSString *)format;
@end
