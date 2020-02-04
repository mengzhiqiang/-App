//
//  LMHGoodDetailModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 3/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHGoodDetailModel : NSObject

@property(nonatomic , strong)NSString * addUserId;
@property(nonatomic , strong)NSString * adminId;
@property(nonatomic , strong)NSString * brandId;
@property(nonatomic , strong)NSString * createTime;
@property(nonatomic , strong)NSString * endTime;
@property(nonatomic , strong)NSString * goodsDesc;
@property(nonatomic , strong)NSString * goodsId;
@property(nonatomic , strong)NSString * goodsName;
@property(nonatomic , strong)NSArray * goodsPicList;

@property(nonatomic , assign)BOOL  isShelves;

/**
 用户输入的商品编码
 */
@property(nonatomic , strong)NSString * goodsNote;
@property(nonatomic , strong)NSString * goodsSn;

@property(nonatomic , strong)NSString * isDelete;

@property(nonatomic , strong)NSString * order;
@property(nonatomic , strong)NSArray * specifications;

@property(nonatomic , strong)NSString * brand_name;
@property(nonatomic , strong)NSString * brandName;

@property(nonatomic , strong)NSString * brandLogo;

@property(nonatomic , strong)NSString * marketPrice;
@property(nonatomic , strong)NSString * purchasePrice;
@property(nonatomic , strong)NSString * recommendedPrice;
@property(nonatomic , strong)NSString * sellPrice;
/**
 搜索 活动数据
 */
@property(nonatomic , strong)NSArray * goodsSpecifications;
@property(nonatomic , strong)NSArray * goodsPics;


@end

NS_ASSUME_NONNULL_END
