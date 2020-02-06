//
//  SAUserPointsModel.h
//  SallyDiMan
//
//  Created by wfg on 2019/10/19.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SAUserPointsModel : NSObject <MJKeyValue>
/// 用户id
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *grade_id;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *withdraw;

@end
@interface SAPointsRecordModel : NSObject<MJKeyValue>
@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *point;
/// 收入或者支出 返回数据+/-
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *add_time;
@end
@interface SAUserPointsListModel : NSObject<MJKeyValue>
@property (nonatomic, strong) SAUserPointsModel *userPoints;
@property (nonatomic, strong) NSArray<SAPointsRecordModel *> *list;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pagenum;
@end

NS_ASSUME_NONNULL_END
