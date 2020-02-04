//
//  DCShopCarModel.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 30/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCShopCarModel : NSObject

/** 购物车ID  */
@property (nonatomic, copy ,readonly) NSString *identifier;
/** 商品ID  */
@property (nonatomic, copy ) NSString *goodsId;
/** 图片URL */
@property (nonatomic, copy ) NSString *goodsUrl;
/** 商品标题 */
@property (nonatomic, copy ) NSString *goodsName;

/** 商品价格 */
@property (nonatomic, copy ) NSString *price;
/** 市场价格 */
//@property (nonatomic, copy ) NSString *market_price;

/** 数量 */
@property (nonatomic, copy ) NSString *num;

/** 是否选中 */
@property (nonatomic, assign ) BOOL isSelect;
/** 剩余库存 */
@property (nonatomic, copy ) NSString *stock;
/** 销量 */
@property (nonatomic, copy ) NSString *sales;

/** 属性 */
@property (nonatomic, copy ) NSString *goodsSpecifications;

/** 属性id */
@property (nonatomic, copy ) NSString *goodsSpecificationsId;
/** 商品小标题 */
@property (nonatomic, copy ) NSString *info;



@end

NS_ASSUME_NONNULL_END