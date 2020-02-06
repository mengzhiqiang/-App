//
//  SOCAccountTools.m
//  SocialApp
//
//  Created by zhiqiang meng on 13/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "SOCAccountTools.h"
#import "EMGlobalVariables.h"
#import "HttpRequestToken.h"

static SOCAccountTools *AccountTools = nil;

@implementation SOCAccountTools


/**************************************************************
 ** 功能:     获取单例
 ** 参数:     无
 ** 返回:     commonvariable对象
 **************************************************************/
+ (id)shareSOCAccountTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //注意：这里建议使用self,而不是直接使用类名（考虑继承）
        AccountTools = [[self alloc] init];
    });
    return AccountTools;
}


-(void)nitializedSDK{
    if (!gIsInitializedSDK) {
           gIsInitializedSDK = YES;
           EMOptions *options = [[EMDemoOptions sharedOptions] toOptions];
           [[EMClient sharedClient] initializeSDKWithOptions:options];
       }
}
-(void)SocRegisterWithUsername:(NSString*)aName password:(NSString*)aPassword completion:(void (^)(NSString *result))aCompletionBlock{
    
    [self nitializedSDK] ;
    aPassword = @"123456";

    [MBProgressHUD showError:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    [[EMClient sharedClient] registerWithUsername:aName password:aPassword completion:^(NSString *aUsername, EMError *aError) {
        
        if (!aError) {
            if (aCompletionBlock) {
                aCompletionBlock(@"success");
            }
            return ;
        }
        NSString *errorDes = @"注册失败，请重试";
        switch (aError.code) {
            case EMErrorServerNotReachable:
                errorDes = @"无法连接服务器";
                break;
            case EMErrorNetworkUnavailable:
                errorDes = @"网络未连接";
                break;
            case EMErrorUserAlreadyExist:
                errorDes = @"用户ID已存在";
                break;
            case EMErrorExceedServiceLimit:
                errorDes = @"请求过于频繁，请稍后再试";
                break;
            default:
                break;
        }
        [EMAlertController showErrorAlert:errorDes];
        if (aCompletionBlock) {
            aCompletionBlock(@"fail");
        }
    }];
}
-(void)SocLoginWithUsername:(NSString*)aName password:(NSString*)aPassword completion:(void (^)(NSString *result))aCompletionBlock{
    
    [self nitializedSDK];
//    aPassword = @"123456";
    [[EMClient sharedClient] loginWithUsername:aName password:aPassword completion:^(NSString *aUsername, EMError *aError) {
        
        if (!aError) {
                  //设置是否自动登录
                  [[EMClient sharedClient].options setIsAutoLogin:YES];
                  
                  EMDemoOptions *options = [EMDemoOptions sharedOptions];
                  options.isAutoLogin = YES;
                  options.loggedInUsername = aName;
                  options.loggedInPassword = aPassword;
                  [options archive];
                  //发送自动登录状态通知
//                  [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNT_LOGIN_CHANGED object:[NSNumber numberWithBool:YES]];
            
//                [HttpRequestToken saveToken:aName];

            if (aCompletionBlock) {
                aCompletionBlock(@"success");
            }
                  return ;
            }
              
              NSString *errorDes = @"登录失败，请重试";
              switch (aError.code) {
                  case EMErrorUserNotFound:
                      errorDes = @"用户ID不存在";
                      break;
                  case EMErrorNetworkUnavailable:
                      errorDes = @"网络未连接";
                      break;
                  case EMErrorServerNotReachable:
                      errorDes = @"无法连接服务器";
                      break;
                  case EMErrorUserAuthenticationFailed:
                      errorDes = aError.errorDescription;
                      break;
                  case EMErrorUserLoginTooManyDevices:
                      errorDes = @"登录设备数已达上限";
                      break;
                  default:
                      break;
              }
              [EMAlertController showErrorAlert:errorDes];
        
        if (aCompletionBlock) {
            aCompletionBlock(@"fail");
        }
        
    }];
        
    
}


- (void)addFriendWithID:(NSString*)FriendID
{
    
}

- (void)SocjoinGroup:(NSString *)aGroupID
   accessoryStyle:(NSInteger)style completion:(void (^)(NSString *result))aCompletionBlock
{
    
    UIViewController * viewVC = [UIViewController getCurrentController];
    if (style == EMGroupStylePublicOpenJoin) {
        [viewVC showHudInView:viewVC.view hint:@"加入群组..."];
        [[EMClient sharedClient].groupManager joinPublicGroup:aGroupID completion:^(EMGroup *aGroup1, EMError *aError) {
            [viewVC hideHud];
            if (aError) {
                [EMAlertController showErrorAlert:@"加入群组失败"];
                
            } else {
                [MBProgressHUD showError:@"加入群组成功！"];
            }
            if (aCompletionBlock) {
                aCompletionBlock(aError.errorDescription);
            }
            
        }];
    } else if (style == EMGroupStylePublicJoinNeedApproval) {
        [viewVC showHudInView:viewVC.view hint:@"发送入群申请..."];
        [[EMClient sharedClient].groupManager requestToJoinPublicGroup:aGroupID message:nil completion:^(EMGroup *aGroup1, EMError *aError) {
            [viewVC hideHud];
            if (aError) {
                [EMAlertController showErrorAlert:@"发送申请失败"];
            } else {
                [MBProgressHUD showError:@"申请群组成功！"];

            }
            if (aCompletionBlock) {
                aCompletionBlock(aError.errorDescription);
            }
        }];
    }
}


@end
