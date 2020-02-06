//
//  FRIActiveModel.h
//  SocialApp
//
//  Created by zhiqiang meng on 14/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FRIActiveModel : NSObject

@property (strong, nonatomic)  NSString *name;
@property (strong, nonatomic)  NSString *log;
@property (strong, nonatomic)  NSString *content;
@property (strong, nonatomic)  NSString *time;
@property (strong, nonatomic)  NSArray * images;

@property (strong, nonatomic)  NSString *pinglunCount;
@property (strong, nonatomic)  NSString *zanCount;

@end

NS_ASSUME_NONNULL_END
