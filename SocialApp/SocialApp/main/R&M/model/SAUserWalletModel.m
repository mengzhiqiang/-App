//
//  SAUserWalletModel.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/19.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "SAUserWalletModel.h"
@implementation SAWalletRecordModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"recordId":@"id"};
}
@end
@implementation SAUserWalletModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":[SAWalletRecordModel class]};
}
@end
