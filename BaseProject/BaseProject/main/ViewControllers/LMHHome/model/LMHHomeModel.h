//
//  LMHHomeModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 30/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHHomeModel : NSObject

/**  */
@property (nonatomic, strong) NSString *bannerId;

/**  */
@property (nonatomic, strong) NSString *homeId;

/** 跳转类型 */
@property (nonatomic, strong) NSString *linkType;

/** 跳转数据 */
@property (nonatomic, strong) NSString *link;
/** 品牌id */
@property (nonatomic, strong) NSString *scheduleId;

/** 真实路径 */
@property (nonatomic, strong) NSString *path;

/**  */
@property (nonatomic, strong) NSString *size;

/** 访问 */
@property (nonatomic, strong) NSString *url;

/**  */
@property (nonatomic, strong) NSString *height;

@end



NS_ASSUME_NONNULL_END
