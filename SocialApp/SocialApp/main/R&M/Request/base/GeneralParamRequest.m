//
//  GeneralParamRequest.m
//  OrientFund
//
//  Created by fugui on 15/3/13.
//
//

#import "GeneralParamRequest.h"
#import "MBProgressHUD.h"


#define RsptEnDict_Essential @{ kSign : eMD5 }
#define kSign       @"sign"

#define __RETURN_MSG_KEY__          @"retmsg"
//请求失败和登出提示框
static UIAlertView* failAV = nil;
static UIAlertView* loginedOutAV = nil;

@interface GeneralParamRequest ()<UIAlertViewDelegate>
//-(NSString* )getRequestPath;
@property (nonatomic, strong) NSURLSessionDataTask *session;
@end

@implementation GeneralParamRequest
-(void)loadRequest{
    [super loadRequest];
    
//    self.SCHEME = HOSTSCEME;
    //        self.METHOD = @"POST";
//    if (!self.PATH.length) {
//        self.PATH = [self getRequestPath];
//    }

    self.HOST = API_HOST;

//    self.addToken = YES;
    //创建唯一的网络失败提示框
    if (!failAV) {
//        failAV = [[UIAlertView alloc] initWithTitle:nil message:@"网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }
    if (!loginedOutAV) {
//        loginedOutAV = [[UIAlertView alloc] initWithTitle:nil message:@"您未登录或长时间未操作，为了您的账户安全，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }
    //监控请求开始
//    @weakify(self);
//    [RACObserve(self, requestNeedActive) subscribeNext:^(id x) {
//        @strongify(self);
//        if ([x intValue] && self.showHud) {
//            [Global showHudMannuallyInView:self.hudView hudStyle:self.HUDStyle];
//        }
//    }];
    //监控请求的处理状态和处理返回
//    [self registerRequestState];
    
    //默认的值
//    self.HUDStyle = MBProgressHUDStyleMaterialDesign;
    self.failureBlock = ^(NSError *error) {
        [MBProgressHUD hideActivityIndicator];
    };
    self.errorBlock = ^(NSString *errorMsg) {
        [MBProgressHUD hideActivityIndicator];
    };
}

- (void)setRequestNeedActive:(BOOL)requestNeedActive {
    if (requestNeedActive) {
        NSString *path = [API_HOST stringByAppendingString:self.PATH];
//        if ([self isMemberOfClass:NSClassFromString(@"SMUploadImageRequest")]) {
//            [HttpEngine uploadWithImage:[self valueForKey:@"files"] url:path filename:nil name:@"files" mimeType:@"image/png" parameters:nil progress:nil success:self.successBlock error:self.errorBlock failure:self.failureBlock];
//            return;
//        }
        
        if ([self.METHOD isEqualToString:@"GET"]) {
            [HttpEngine requestGetWithURL:path params:self.requestParams isToken:self.addToken errorDomain:nil errorString:nil success:self.successBlock failure:self.failureBlock];
        } else {
            [HttpEngine requestPostWithURL:path params:self.requestParams isToken:self.addToken errorDomain:nil errorString:nil success:self.successBlock failure:self.failureBlock];
        }
    }
}

- (void)cancel {
    [self.session cancel];
}

- (void)setShowHud:(BOOL)showHud {
    _showHud = showHud;
    _hideHud = showHud;
    self.hudView = [[UIApplication sharedApplication].delegate window];
}
-(void)showHudInView:(UIView *)view{
    _showHud = YES;
    _hideHud = _showHud;
    _hudView = view;
}
//-(void)showHudInView:(UIView *)view hudStyle:(MBProgressHUDStyle)hudStyle{
//    _HUDStyle = hudStyle;
//    [self showHudInView:view];
//}
//请求失败提示
-(void)showFailAV{
    if (!failAV.isVisible) {
        failAV.delegate = self;
        [failAV show];
    }
}
//登出提示
-(void)showLoginedOutAV{
    if (!loginedOutAV.isVisible) {
        loginedOutAV.delegate = self;
        [loginedOutAV show];
    }
}
/*
//监控网络返回，处理加载站位图，无网络时弹框
-(void)registerRequestState{
    @weakify(self)
    [[RACObserveNew(self, state)
      filter:^BOOL(id value) {
          @strongify(self)
          return !self.sending;
      }] subscribeNext:^(id x) {
          @strongify(self)
          if (self.hideHud) {
              [MBProgressHUD hideHUDForView:self.hudView animated:YES];
          }
          switch (self.state) {
              case SuccessState:
                  if (self.successBlock) {
                      self.successBlock();
                  }
                  break;
              case ErrorState:
                  if ([self.output[__RETURN_CODE_KEY__] isEqualToString:__RETURN_CODE_KICKED_OFF__] || ([self.output[__RETURN_CODE_KEY__] isEqualToString:__RETURN_CODE_KICKED_OFF2__] && [self.output[__RETURN_MSG_KEY__] rangeOfString:@"重新登录"].length)) {
                      [self showLoginedOutAV];
                      if ([Global sharedGlobal].currentAcc) {
                          [Global sharedGlobal].currentAcc.accesstoken = @"";
                          [[Global sharedGlobal].currentAcc save];
                          [Global sharedGlobal].currentAcc = nil;
                      }
                      [RequestCookieSolve deleteCookie];
                  } else if ([self.output[__RETURN_CODE_KEY__] isEqualToString:__RETURN_CODE_NEWACCOUNT__]
                            //                        && [self.output[__RETURN_MSG_KEY__] rangeOfString:@"对应的客户编号不存在"].length
                            ){
                      //返回此错误的话当查询为空处理
                      if (self.successBlock) {
                          self.successBlock();
                      }
                  } else if ([self.output[__RETURN_CODE_KEY__] isEqualToString:@"1111"] && [self.output[__RETURN_MSG_KEY__] rangeOfString:@"HS_EQUERY_444"].length){
                      if (self.successBlock) {
                          self.successBlock();
                      }
                  }
                  else {
                      if (self.errorBlock) {
                          self.errorBlock();
                      } else {
                          [self showErrorMsg:self.output[__RETURN_MSG_KEY__]];
                      }
                  }
                  break;
              case FailState:
                  if (self.failureBlock) {
                      self.failureBlock(self.error);
                  } else {
                      [self showFailAV];
                  }
                  break;
              default:
                  break;
          }
      }];
}
*/
- (void)createSignalWithSuccessBlock:(successBlock)success error:(errorBlock)error failure:(failureBlock)failure {
    self.successBlock = success;
    self.errorBlock = error;
    self.failureBlock = failure;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView isEqual:loginedOutAV]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //跳回首页
            UITabBarController *tabbar = (UITabBarController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
            UINavigationController* nav = (UINavigationController*)[tabbar selectedViewController];
            [tabbar setSelectedIndex:0];
            
            if(nav.viewControllers.count > 1){
                [nav popToRootViewControllerAnimated:YES];
            }
            //[(EZNavigationController*)[tabbar selectedViewController] popToRootViewControllerAnimated:NO];
        });
        
    }
}

- (void)showErrorMsg:(NSString *)errorMsg {
    //防止空白的接口返回弹框
    if (!errorMsg) {
        errorMsg = @"系统异常";
    }
//    [UIAlertView showWithTitle:nil message:errorMsg cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
}

#pragma params
/**
 *  添加通用参数和sign
 *
 *  @return request的补全参数字典
 */
/*
-(NSDictionary *)requestParams{
    NSMutableDictionary* params = [[super requestParams] mutableCopy];
    NSDictionary* info = [[NSBundle mainBundle] infoDictionary];
    NSDictionary* baseParams =  @{@"appkey"     :@"JtzqYf",
                                  @"appsecret"  :@"2bBFny",
                                  @"appversion" :info[@"CFBundleShortVersionString"],
                                  @"channel"    :@"app_ios",
                                  @"market"     :@"AppStore",
                                  };
    for (NSString* key in [baseParams allKeys]) {
        [params setObject:baseParams[key] forKey:key];
    }
    //不传accesstoken的情况
    if ([Global sharedGlobal].currentAcc.accesstoken.length &&
        ![self isMemberOfClass:[FundListRequest class]] &&
        ![self isMemberOfClass:[ValidatesignatureRequest class]] &&
        self.addToken) {
        [params setObject:[Global sharedGlobal].currentAcc.accesstoken forKey:@"accesstoken"];
    }

    [params setObject:[self getParamsSign:params] forKey:@"sign"];
    return params;
}
*/
- (void)addTestServerParam:(NSMutableDictionary* )requestParams {
    //非get请求计算sign时受PATH里的参数影响,也就是所有请求计算sign时都新增一个参数，实际增加参数在action里，因为会在获取requestParams之前获取PATH（未增加参数）
    
//    if([self.METHOD isEqualToString:@"GET"]){
//        [requestParams setObject:@"jy_test" forKey:@"appproxy"];
//        [requestParams setObject:[self getParamsSign:requestParams] forKey:@"sign"];
//    } else {
//        NSString* testParam = @"?appproxy=jy_test";
//        //请求重发时append会再次执行
//        if (![self.PATH rangeOfString:testParam].length) {
//            self.PATH = [self.PATH stringByAppendingString:testParam];
//        }
        NSMutableDictionary* signParams = [requestParams mutableCopy];
        [signParams setObject:@"jy_test" forKey:@"appproxy"];
        [requestParams setObject:[self getParamsSign:signParams] forKey:@"sign"];
//    }

}

/**
 *  读取plist配置request的path
 *
 *  @return request.path
 */

//-(NSString* )getRequestPath{
//    NSDictionary* dic = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[[$ appPath] stringByAppendingPathComponent:@"RequestPath.plist"]] options:0 format:nil error:nil];
//    return [dic valueForKey:NSStringFromClass([self class])];
//}
/**
 *  sign签名方法
 */
/*
- (NSString*)getParamsSign:(NSDictionary*)myparams{
    NSMutableDictionary *params = [myparams mutableCopy];
#ifdef JYTestParam
    [params setObject:@"jy_test" forKey:@"appproxy"];
#endif
    NSMutableString *strSignOrigin = [[NSMutableString alloc]init];
    
    NSArray *keys = [params allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
        //         [[params objectForKey:categoryId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
        
        [strSignOrigin appendFormat:@"&%@=%@",categoryId,[params objectForKey:categoryId]];
    }
    if ([strSignOrigin length]>2) {
        strSignOrigin = [NSMutableString stringWithString:[strSignOrigin substringFromIndex:1]];
    }
    
    NSString *strSignResult = gfencrypt(RsptEnDict_Essential, kSign, strSignOrigin);
    strSignResult = [strSignResult uppercaseString];
    
    NSString *firstEight = [strSignResult substringToIndex:8];
    NSScanner* pScanner = [NSScanner scannerWithString: firstEight];
    
    unsigned long long iValue;
    [pScanner scanHexLongLong: &iValue];
    
    long lHexLong = 0x3FFFFFFF & iValue;
    NSString *outChars = @"";
    NSArray *chars = [self getSignIndexChars];
    for (int i = 0; i < 6; i ++) {
        long index = 0x0000003D & lHexLong;
        outChars = [outChars stringByAppendingString:chars[index]];
        lHexLong = lHexLong >> 5;
    }
    return outChars;
}
- (NSArray *)getSignIndexChars {
    NSArray *chars = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",
                       @"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",
                       @"u",@"v",@"w",@"x",@"y",@"z",
                       @"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                       @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",
                       @"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",
                       @"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    return chars;
}
//-(void)dealloc{
//    NSLog(@"Request%@die",[self class]);
//}

- (void)isRestful:(BOOL)isRestful{
    if(!isRestful){
        self.HOST = [self.HOST stringByReplacingOccurrencesOfString:@"/restful/" withString:@"/"];
    }
}
*/
@end
