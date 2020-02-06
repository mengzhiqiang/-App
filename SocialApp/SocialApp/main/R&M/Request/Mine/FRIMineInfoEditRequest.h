//
//  FRIMineInfoEditRequest.h
//  SocialApp
//
//  Created by wfg on 2020/1/8.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "GeneralParamRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRIMineInfoEditRequest : GeneralParamRequest
@property (nonatomic, strong) NSString *marriageStatus;
@property (nonatomic, strong) NSString *userImg;
@property (nonatomic, strong) NSString *userNickname;
    
@end

NS_ASSUME_NONNULL_END
