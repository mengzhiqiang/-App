//
//  LMHLeftBrandModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 17/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHLeftBrandModel : NSObject

@property(nonatomic , strong)NSString * brandId;
@property(nonatomic , strong)NSString * scheduleId;


@property(nonatomic , strong)NSString * brandLogo;
@property(nonatomic , strong)NSString * brandName;
@property(nonatomic , strong)NSString * endTime;
@property(nonatomic , strong)NSString * startTime;
@property(nonatomic , assign)BOOL  isShelves;

@end

NS_ASSUME_NONNULL_END
