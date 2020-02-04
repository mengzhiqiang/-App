//
//  WKBaseWebViewController.m
//  ZCBus
//
//  Created by zhiqiang meng on 20/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "WKBaseWebViewController.h"
#import "CheckNetwordStatus.h"

@interface WKBaseWebViewController ()
{
    
    UIView    *  rootView;
    UIImageView *bg_imageView;
}
@property (strong,nonatomic) UIButton *colseBtn;
@end

@implementation WKBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customNavBar.title = _headTitle;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top-50)];
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;
    // 2.创建请求
    NSMutableURLRequest *request;
    // 3.加载网页
    if (self.webStr) {
//实现scalesPageToFit 网页根据屏幕大小缩放
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top) configuration:wkWebConfig];
        
        [self.webView loadHTMLString:_webStr baseURL:nil];
        self.webView.contentScaleFactor = 1;
    } else {
        if (![CheckNetwordStatus sharedInstance].isNetword) {
            request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_webUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        }
        else {
            request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
        }
        if (IOS_VERSION>=11) {
            NSURLRequest  * req = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
            [_webView loadRequest:req];
            
        }else{
            [_webView loadRequest:request];
            
        }
    }
    self.webView.navigationDelegate = self ;
    [self.view addSubview:_webView];
    [MBProgressHUD showActivityIndicator];
    
}


-(void)closeVC{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 1 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}
/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"====加载开始！===");
    //状态栏添加加载图标
    rootView.hidden=YES;
}
/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"====网页内容时返回！123==%@=",webView.title);
    
}

/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"====网页内容时返回！didFinishNavigation==%@=",webView.title);
    [MBProgressHUD hideActivityIndicator];
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"====加载失败！2==%@=。====%@",error,webView.URL);
    [MBProgressHUD hideActivityIndicator];
    [self addNoDataImageView];
}

-(void)addNoDataImageView{
    //
    if (!rootView) {
        
        rootView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top)];
        [self.view addSubview:rootView];
        rootView.backgroundColor = [UIColor whiteColor];
        
        bg_imageView=[[UIImageView alloc]init];
        bg_imageView.frame = CGRectMake((SCREEN_WIDTH-250*RATIO)/2, 48, 250*RATIO, 250*RATIO);
        bg_imageView.image =[UIImage imageNamed:@"img_step3"];
        [rootView addSubview:bg_imageView];
        
        UILabel  *noDateLabel=[[UILabel alloc]init];
        noDateLabel.frame = CGRectMake(50,80, SCREEN_WIDTH-100, 20);
        noDateLabel.text = @"喔噢！您的网络好像有问题...";
        noDateLabel.font =[UIFont boldSystemFontOfSize:15];
        noDateLabel.textColor = [UIColor HexString:@"7d8699"];
        noDateLabel.textAlignment =NSTextAlignmentCenter;
        [rootView addSubview:noDateLabel];
        
        UIButton *btn =[ UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(25, noDateLabel.bottom+20, SCREEN_WIDTH-50, 44);
        [btn setTitle:@"刷新试试" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [btn addTarget:self action:@selector(reloadAgianURL:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:Main_Color forState:UIControlStateNormal];
        [btn draCirlywithColor:Main_Color andRadius:btn.height/2];
        [rootView addSubview:btn];
        
        //        rootView.height = btn.bottom +20;
        
    }
    rootView.hidden=NO;
}
-(void)reloadAgianURL:(UIButton *)sender{
    
    //    [self.webView reload];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
    
    rootView.hidden=YES;
}
/// message: 收到的脚本信息.
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
}

//重写父类方法
- (void)backBtnClicked {
    
    if (_webView.canGoBack) {
        [self.webView goBack];
        //        self.leftShutDownButton.hidden = NO;
    }else {
        //        self.leftShutDownButton.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end