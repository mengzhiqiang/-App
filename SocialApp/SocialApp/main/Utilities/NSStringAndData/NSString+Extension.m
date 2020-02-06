//
//  NSString+Extension.m
//  SmartDevice
//
//  Created by mengzhiqiang on 17/3/13.
//  Copyright © 2017年 TeeLab. All rights reserved.
//

#import "NSString+Extension.h"
#import <MAMapKit/MAMapKit.h>


@implementation NSString (Extension)

+ (NSString *)getImageUrlWithCover:(NSDictionary*)cover{
    
    if (iPhone5|| isPAD_or_IPONE4) {
        return  [cover objectForKey:@"small"];
    }
    else if (iPhone6) {
        return  [cover objectForKey:@"medium"];
    }
    else if (iPhone6plus) {
        return  [cover objectForKey:@"large"];
    }
    else{
        return  [cover objectForKey:@"large"];
    }
}
/**
 *   格式转换 链接带汉子处理
 *
 *  @return 图片链接
 */
- (NSURL *)changeURL{
    
    NSString *string = [ URL(self)  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:string];
    
}

/**
 *   格式转换 手机号加***
 *
 *  @return 字符串
 */
- (NSString *)changePhone{
    NSString*bStr = [self substringWithRange:NSMakeRange(3,4)];
    return [ self stringByReplacingOccurrencesOfString:bStr withString:@"****"];
}

+(NSString*)distance:(NSDictionary*)dic1 point:(NSDictionary*)dic2{
    //1.将两个经纬度点转成投影点
     MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([dic1[@"latitude"] floatValue],[dic1[@"longitude"] floatValue]));
      MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([dic2[@"latitude"] floatValue],[dic2[@"longitude"] floatValue]));
      //2.计算距离
      CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    
    if (distance<500) {
        return  [NSString stringWithFormat:@"%.fm",distance];
    }
    return  [NSString stringWithFormat:@"%.2fkm",(float)distance/1000];
}
@end
