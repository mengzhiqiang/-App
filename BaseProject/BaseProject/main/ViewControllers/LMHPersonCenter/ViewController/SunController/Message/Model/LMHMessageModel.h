//
//  LMHMessageModel.h
//  BaseProject
//
//  Created by libj on 2019/9/17.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHMessageModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *creatTime;
/**
 1 未读，2 已读
 */
@property (nonatomic, assign) NSInteger isRead;
@property (nonatomic, assign) NSInteger messageType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *ID;
@end

NS_ASSUME_NONNULL_END
