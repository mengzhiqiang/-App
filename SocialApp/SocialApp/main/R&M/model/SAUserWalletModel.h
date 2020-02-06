//
//  SAUserWalletModel.h
//  SallyDiMan
//
//  Created by wfg on 2019/10/19.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SAWalletRecordModel : NSObject <MJKeyValue>
@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *add_time;

@end
@interface SAUserWalletModel : NSObject
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSArray<SAWalletRecordModel *> *list;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pagenum;
@end

NS_ASSUME_NONNULL_END
