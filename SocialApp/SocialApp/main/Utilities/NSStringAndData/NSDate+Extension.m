//
//  NSDate+Extension.m
//  CompareTimeDemo
//
//  Created by admin on 16/6/1.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSString *)getCurrentDataTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)getCurrentTime {
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    return timeString;
    
}

+ (BOOL)compareDataTime:(NSString *)dataString {
    //首先创建格式化对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //然后创建日期对象
    
    NSDate *date1 = [dateFormatter dateFromString:dataString];
    
    NSDate *date = [NSDate date];
    
    //计算时间间隔（单位是秒）
    
    NSTimeInterval time = [date timeIntervalSinceDate:date1];
    
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
    
    int hours = ((int)time)%(3600*24)/3600;
    
    int minutes = ((int)time)%(3600*24)%3600/60;
    
    int seconds = ((int)time)%(3600*24)%3600%60;
    
    NSString *dateContent = [[NSString alloc] initWithFormat:@"距离刷新时间相差%i天%i小时%i分%i秒",days,hours,minutes,seconds];
    NSLog(@"dateContent ====%@",dateContent);
    
    //刷新时间
    if (hours >= 6.0) {
        return YES;
    }
    
    return NO;
}

+(NSString*)changeTimeOfTimeInterval:(NSString*)timeInterval{

    NSInteger totalSeconds = timeInterval.integerValue;
    
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    NSString *secString;
    if (seconds < 10) {
        secString = [NSString stringWithFormat:@"%d%d",0,seconds];
    }else {
        secString = [NSString stringWithFormat:@"%d",seconds];
    }
    NSString *minString;
    if (minutes < 10) {
        minString = [NSString stringWithFormat:@"%d%d",0,minutes];
    }else {
        minString = [NSString stringWithFormat:@"%d",minutes];
    }
    NSString *total = [NSString stringWithFormat:@"%@:%@",minString,secString];
    
    return total;
}

+ (NSDictionary *)resetNewUserInfoWithOldObject:(NSDictionary*)oldObject
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    for (NSString *key in [oldObject allKeys]) {
        if ([[[oldObject objectForKey:key] class] isSubclassOfClass:[NSNull class]] ) {
            
        }
        else  if ([[[oldObject objectForKey:key] class] isSubclassOfClass:[NSDictionary class]] ) {
            NSDictionary *accountDic= [self resetNewUserInfoWithOldObject:[oldObject objectForKey:key]];
            if ([accountDic allKeys]>0) {
                [userInfo setObject:accountDic forKey:key];
            }
        }
        
        else{
            [userInfo setObject:[oldObject objectForKey:key] forKey:key];
        }
    }
    return userInfo ;
}

+(NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

//将时间字符串转换为时间戳
+ (NSString *)timeStrToTimestamp:(NSString *)timeStr {
    
//    NSDate *date = [self timeStrToDate:timeStr];
    NSDate *date = [[self dateFormatWith:@"YYYY-MM-dd HH:mm:ss"] dateFromString:timeStr];

    NSTimeInterval stamp = [date timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%.0f", stamp];
}
//将时间字符串转换为时间
+ (NSDate *)timeStrToDate:(NSString *)timeStr {
    
    NSDate *date = [[self dateFormatWith:@"YYYY-MM-dd HH:mm:ss"] dateFromString:timeStr];
    
    //解决8小时时差问题
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    
    return localeDate;
}
//获取日期格式化器
+(NSDateFormatter *)dateFormatWith:(NSString *)formatStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];//@"YYYY-MM-dd HH:mm:ss"
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    return formatter;
}

/**
  品牌 排期 倒计时
 */
+ (NSMutableAttributedString*)distanceTime:(NSString *)dataString {
    //首先创建格式化对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *date1 = [dateFormatter dateFromString:dataString];
    NSDate *date = [NSDate date];
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [date1 timeIntervalSinceDate:date];
    //计算天数、时、分、秒
    
//    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%3600;
    int minutes = ((int)time)%(3600*24)%3600/60;
    int seconds = ((int)time)%(3600*24)%3600%60;
    
    NSString *dateContent = [[NSString alloc] initWithFormat:@"距离活动结束 %02d 时 %02d 分 %02d 秒",hours,minutes,seconds];
    NSLog(@"dateContent ====%@",dateContent);
    
    NSMutableAttributedString * string = [self  BgColor:dateContent andTitle:[NSString stringWithFormat:@"%02d",hours]];

    return string ;
}

+(NSMutableAttributedString*)BgColor:(NSString*)content andTitle:(NSString*)title
{
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",content]];
    int count = 7;
    [newPrice addAttribute:NSBackgroundColorAttributeName value:Main_Color range:NSMakeRange(count,title.length)];  //背景颜色
    [newPrice addAttribute:NSForegroundColorAttributeName value:White_Color range:NSMakeRange(count,title.length)];   // 字体颜色
    
    [newPrice addAttribute:NSBackgroundColorAttributeName value:Main_Color range:NSMakeRange(count+title.length+3,2)];  //背景颜色
    [newPrice addAttribute:NSForegroundColorAttributeName value:White_Color range:NSMakeRange(count+title.length+3,2)];   // 字体颜色
    
    [newPrice addAttribute:NSBackgroundColorAttributeName value:Main_Color range:NSMakeRange(count+title.length+2+3+3,2)];  //背景颜色
    [newPrice addAttribute:NSForegroundColorAttributeName value:White_Color range:NSMakeRange(count+title.length+2+3+3,2)];   // 字体颜色
    
    return newPrice ;
}

+(NSString *)stringConversionNSDateStr:(NSString *)dateStr formatter:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (!format.length) {
        format = @"YYYY-MM-dd HH:mm:ss";
    }
    NSString *temp = @"YYYY-MM-dd HH:mm:ss";
    [dateFormatter setDateFormat:temp];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:format];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

@end
