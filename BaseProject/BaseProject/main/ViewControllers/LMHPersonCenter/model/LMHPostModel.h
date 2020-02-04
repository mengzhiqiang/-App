//
//  LMHPostModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 11/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHPostModel : NSObject

/** 内容 */
@property (nonatomic, copy) NSString *context;
/** 时间 */
@property (nonatomic, copy) NSString *time;
@end

NS_ASSUME_NONNULL_END
