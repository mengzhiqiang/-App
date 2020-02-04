//
//  NSString+Extension.h
//  SmartDevice
//
//  Created by mengzhiqiang on 17/3/13.
//  Copyright © 2017年 TeeLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *   根据手机适配不同链接图片
 *
 *  @return 图片链接
 */
+ (NSString *)getImageUrlWithCover:(NSDictionary*)cover;


/**
 *   格式转换 链接带汉子处理
 *
 *  @return 图片链接
 */
- (NSURL *)changeURL;

/**
 *   格式转换 手机号加***
 *
 *  @return 字符串
 */
- (NSString *)changePhone;

@end
