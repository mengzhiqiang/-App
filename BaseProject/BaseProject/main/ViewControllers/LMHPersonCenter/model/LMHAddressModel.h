//
//  LMHAddressModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 4/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHAddressModel : NSObject

@property (nonatomic, copy) NSString * identifier;

/* 用户名 */
@property (nonatomic, copy) NSString *name;
/* 用户电话 */
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *areaId;

/* 详细地址 */
@property (nonatomic, copy) NSString *address;
/* 默认地址 1为正常 2为默认 */
@property (nonatomic, assign) BOOL isDefault;
/* 是否代发 */
@property (nonatomic, assign) BOOL isTake;


@end

NS_ASSUME_NONNULL_END
