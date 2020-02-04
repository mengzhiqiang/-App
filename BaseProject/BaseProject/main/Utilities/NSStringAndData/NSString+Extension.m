//
//  NSString+Extension.m
//  SmartDevice
//
//  Created by mengzhiqiang on 17/3/13.
//  Copyright © 2017年 TeeLab. All rights reserved.
//

#import "NSString+Extension.h"

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
@end
