//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(NSDictionary *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

- (void)managerDidRecvChooseCardResponse:(WXChooseCardResp *)response;

- (void)managerDidRecvChooseInvoiceResponse:(WXChooseInvoiceResp *)response;

- (void)managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *)response;

- (void)managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *)response;

- (void)managerDidRecvInvoiceAuthInsertResponse:(WXInvoiceAuthInsertResp *)response;

- (void)managerDidRecvNonTaxpayResponse:(WXNontaxPayResp *)response;

- (void)managerDidRecvPayInsuranceResponse:(WXPayInsuranceResp *)response;
@end


typedef void (^BackBlockResult)(NSString *result);

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, copy) BackBlockResult backResult;

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;


+ (instancetype)sharedManager;

/**
   微信支付
    order  订单号
    backResult  返回状态
 */
-(void)requestPayWithOrder:(NSString*)order num:(NSString*)num backResult:(BackBlockResult)backResult;

@end
