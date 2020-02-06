//
//  FRICardEnterViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 2/12/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//
#import "BSGradientButton.h"
#import "FRICardEnterViewController.h"
#import "FRIFaceViewController.h"
#import "FRIEduAuthenViewController.h"
#import "WKBaseWebViewController.h"
@interface FRICardEnterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cardNameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardIdTF;
@property (weak, nonatomic) IBOutlet BSGradientButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (assign, nonatomic) BOOL  isSelect;
@property (weak, nonatomic) IBOutlet UIView *useView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation FRICardEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"实名认证";
    _goButton.backgroundColor = White_Color;
    [_goButton draCirlywithColor:Main_Color andRadius:_goButton.height/2];
    
    self.customNavBar.titleLabelColor = White_Color;
      
      // 设置自定义导航栏背景颜色
      self.customNavBar.barBackgroundColor = [UIColor clearColor];
      self.customNavBar.backgroundColor = [UIColor clearColor];
    
    _headerImageView.frame = CGRectMake(0, 0, 375*RATIO_IPHONE6, 256*RATIO_IPHONE6);

    if (iPhone5 ||iPhone6) {
        _useView.top = _headerImageView.bottom+10;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        self.view.backgroundColor = White_Color;
}
- (IBAction)selectButton:(UIButton *)sender {
    
    if (sender.tag==10) {
        _isSelect = !_isSelect;
        
        if (_isSelect) {
            [sender setImage:[UIImage imageNamed:@"btn_round_pressed"] forState:UIControlStateNormal];
        }else{
            [sender setImage:[UIImage imageNamed:@"btn_round_default"] forState:UIControlStateNormal];
        }
    }else{
        ///跳转到网页
    }
    
}

- (IBAction)nextVC:(BSGradientButton *)sender {
    
    
    if (_cardNameTF.text.length<1) {
        [MBProgressHUD showError:@"请输入真实姓名！"]; return;
    }
    if (_cardIdTF.text.length<1) {
        [MBProgressHUD showError:@"请输入身份证号码！"]; return;
    }
    
    if (!_isSelect) {
        [MBProgressHUD showError:@"我已阅读并接受《实名认证须知》"]; return;
    }
    
   FRIFaceViewController *faceVc =  [FRIFaceViewController new];
    faceVc.userName = _cardNameTF.text;
    faceVc.userIdentity = _cardIdTF.text;
    [self.navigationController pushViewController:faceVc animated:YES];
    
}

- (IBAction)goHome:(UIButton *)sender {
    ///跳guo
    FRIEduAuthenViewController* eduVC =[FRIEduAuthenViewController new];
    eduVC.name = _cardNameTF.text;
    [self.navigationController pushViewController:eduVC animated:YES];

}

-(void)getHelpCenter{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:common_reglation];
    NSDictionary*dict = @{@"type":@(5)};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:dict isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [MBProgressHUD hideActivityIndicator];
        NSArray * array = [responseObject objectForKey:@"data"] ;
        if (array.count ) {
            WKBaseWebViewController *vc = [[WKBaseWebViewController alloc] init];
            vc.headTitle = @"帮助中心";
            vc.webStr = [[array objectAtIndex:0]objectForKey:@"content"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}

@end
