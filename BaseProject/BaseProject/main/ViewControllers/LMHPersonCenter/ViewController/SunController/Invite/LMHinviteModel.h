//
//  LMHinviteModel.h
//  BaseProject
//
//  Created by zhiqiang meng on 9/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHinviteModel : NSObject

@property(nonatomic, strong)NSString *  code;
@property(nonatomic, strong)NSString *  registerCodeId;
@property(nonatomic, strong)NSString *  state;
@property(nonatomic, strong)NSString *  usedPhone;
@property(nonatomic, strong)NSString *  usedTime;


@end

NS_ASSUME_NONNULL_END
