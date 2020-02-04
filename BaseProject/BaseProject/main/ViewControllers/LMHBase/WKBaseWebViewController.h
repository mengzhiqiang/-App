//
//  WKBaseWebViewController.h
//  ZCBus
//
//  Created by zhiqiang meng on 20/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKBaseWebViewController : LMHBaseViewController<WKNavigationDelegate>

@property (strong, nonatomic) NSString *webUrl;
@property (strong,nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSString *headTitle;

@property (strong, nonatomic) NSString *webStr;

@end

NS_ASSUME_NONNULL_END
