//
//  UILabel+Addition.h
//  SocialApp
//
//  Created by zhiqiang meng on 15/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

//#import <AppKit/AppKit.h>


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Addition)

#pragma mark 根据label定的数据
-(CGFloat)contentHight ;

#pragma mark 定死的数据
+(CGFloat)cellHight:(NSString*)string;

@end

NS_ASSUME_NONNULL_END
