//
//  SAUserPointsModel.m
//  SallyDiMan
//
//  Created by wfg on 2019/10/19.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "SAUserPointsModel.h"
@implementation SAUserPointsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userId":@"id"};
}
@end
@implementation SAPointsRecordModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"recordId":@"id"};
}
@end
@implementation SAUserPointsListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userPoints":@"list",
             @"list":@"res"
    };
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":[SAPointsRecordModel class]};
}
@end
