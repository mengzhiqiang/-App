//
//  Global.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/18.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "Global.h"

static Global* global;
@implementation Global
+ (instancetype)sharedGlobal {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        global = [[Global alloc] init];
    });
    return global;
}

//- (UserModel *)curUser {
//   return [UserModel sharedUserInfo];
//}
@end
