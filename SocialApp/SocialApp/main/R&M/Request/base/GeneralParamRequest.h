//
//  GeneralParamRequest.h
//  OrientFund
//
//  Created by fugui on 15/3/13.
//
//

#import "Request.h"
#pragma mark - 返回码
//键
#define __RETURN_MSG_KEY__              @"retmsg"
#define __RETURN_CODE_KEY__             @"retcode"
#define __RETURN_DATA_KEY__             @"retdata"
//值
#define __RETURN_CODE_SUCCESS__                 @"0000"
#define __RETURN_CODE_PURCHASESUCCESS__         @"KOS"

#define __RETURN_CODE_KICKED_OFF__      @"0004"//被踢出
#define __RETURN_CODE_KICKED_OFF2__     @"1111"//功能限制，需重新登录
#define __RETURN_CODE_NEWACCOUNT__      @"2222"//新开户查询资产提示
#define __RETURN_CODE_ERRPSW__          @"TPE"//密码错误
#define __RETURN_CODE_LOCK__            @"ETS-9B119"//账号锁定
#define __RETURN_CODE_PROXY__           @"5BP0001"//账号锁定

#define __KEY_ERR_CODE__                @"0006"
#pragma mark - 获取key
#define __SYS_KEY_KEY__                 @"syskey"


typedef void (^successBlock)(NSDictionary *dic);
typedef void (^errorBlock)(NSString *errorMsg);
typedef void (^failureBlock)(NSError *error);
@interface GeneralParamRequest : Request
/**
 *  是否有accesstoken参数  default YES
 */
@property (nonatomic) BOOL addToken;

/**
 *  请求时是否显示加载图，在requestNeedActive之前设置 默认window
 */
@property (nonatomic) BOOL showHud;
@property (nonatomic) BOOL hideHud;
@property (nonatomic, strong) UIView* hudView;
-(void)showHudInView:(UIView* )view;
//-(void)showHudInView:(UIView *)view hudStyle:(MBProgressHUDStyle)hudStyle;

@property (nonatomic, strong) successBlock successBlock;
@property (nonatomic, strong) errorBlock errorBlock;
@property (nonatomic, strong) failureBlock failureBlock;
-(void)showFailAV;
-(void)showLoginedOutAV;

//结果处理
//-(void)registerRequestState;
//默认实现了error&failure block，会弹出错误信息，如果不需要，传一个block进来，空的即可
- (void)createSignalWithSuccessBlock:(successBlock)success error:(errorBlock)error failure:(failureBlock)failure;

- (NSString*)getParamsSign:(NSDictionary*)myparams;

- (void)isRestful:(BOOL)isRestful;
- (void)showErrorMsg:(NSString *)errorMsg;

//@property (nonatomic, assign) MBProgressHUDStyle HUDStyle;
- (void)cancel;
@end
