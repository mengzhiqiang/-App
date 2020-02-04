//
//  LMHvipModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 19/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHvipModel : NSObject

@property(nonatomic, strong)NSString *  level;
@property(nonatomic, strong)NSString *  levelName;

@property(nonatomic, strong)NSString *  itselfRebate;   //当前销售返利
@property(nonatomic, strong)NSString *  sellMoney;      //当前销售额
@property(nonatomic, strong)NSString *  levelaRebate;    //一级消费返利
@property(nonatomic, strong)NSString *  levelbRebate;    //二级消费返利

@property(nonatomic, strong)NSString *  itselfRebateUp;   //下一级销售返利
@property(nonatomic, strong)NSString *  sellMoneyUp;       //下一级销售额
@property(nonatomic, strong)NSString *  levelaRebateUp;
@property(nonatomic, strong)NSString *  levelbRebateUp;

@end

NS_ASSUME_NONNULL_END
