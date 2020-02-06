//
//  SOCAccountTools.h
//  SocialApp
//
//  Created by zhiqiang meng on 13/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SOCAccountTools : NSObject

+ (id)shareSOCAccountTool;

-(void)SocRegisterWithUsername:(NSString*)aName password:(NSString*)aPassword completion:(void (^)(NSString *result))aCompletionBlock;

-(void)SocLoginWithUsername:(NSString*)aName password:(NSString*)aPassword completion:(void (^)(NSString *result))aCompletionBlock;

- (void)SocjoinGroup:(NSString *)aGroupID
   accessoryStyle:(NSInteger)style completion:(void (^)(NSString *result))aCompletionBlock;

@end

NS_ASSUME_NONNULL_END
