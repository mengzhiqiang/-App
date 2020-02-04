//
//  DCShopModel.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 24/4/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCShopCarModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCShopModel : NSObject

/**   店铺名称  */
@property (nonatomic, copy ) NSString *brandName;
/** 店铺id */
@property (nonatomic, copy ) NSString *brandId;
/** 店铺logo */
@property (nonatomic, copy ) NSString *brandUrl;

/** 是否选中 */
@property (nonatomic, assign ) BOOL  isSelect;

@property(nonatomic,strong) NSMutableArray <DCShopCarModel*> *data ;


@end

NS_ASSUME_NONNULL_END
