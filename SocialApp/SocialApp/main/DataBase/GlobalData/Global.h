//
//  Global.h
//  SallyDiMan
//
//  Created by wfg on 2019/10/18.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface Global : NSObject
@property (nonatomic, strong) UserInfo *curUser;
+ (instancetype)sharedGlobal;
@end

NS_ASSUME_NONNULL_END
