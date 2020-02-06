//
//  FRIStoreFeedViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 3/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "FRIStoreFeedViewController.h"
#import "BSGradientButton.h"
#import "ZWTextView.h"
@interface FRIStoreFeedViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contextTV;
@property (weak, nonatomic) IBOutlet BSGradientButton *comintButton;
@property (assign, nonatomic) NSInteger style;
@property (strong, nonatomic) ZWTextView * detailTextView;

@property (weak, nonatomic) IBOutlet UIView *rootView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectButtons;

@end

@implementation FRIStoreFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = Main_BG_Color;
    self.customNavBar.title  = @"意见反馈";
    _style = 2 ;
    self.detailTextView = [[ZWTextView alloc] initWithFrame:CGRectMake(15,5,SCREEN_WIDTH-30,155) TextFont:[UIFont systemFontOfSize:14] MoveStyle:styleMove_Down];

        self.detailTextView.maxNumberOfLines = 10;
        self.detailTextView.placeholder = @"请填写反馈内容..";
        self.detailTextView.inputText = @"";
        self.detailTextView.textViewHeightChange = ^(CGFloat height) {
    //        weakself.footView.frame = CGRectMake(weakself.footView.frame.origin.x, weakself.footView.frame.origin.y, weakself.footView.frame.size.width, CGFloatBasedI375(130)+height);
    //        weakself.imageBox.frame = CGRectMake(weakself.imageBox.frame.origin.x, CGRectGetMaxY(weakself.textView.frame) + CGFloatBasedI375(5) , weakself.imageBox.frame.size.width, weakself.imageBox.frame.size.height);
        };
        [self.contextTV addSubview:_detailTextView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
     //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
     tapGestureRecognizer.cancelsTouchesInView = NO;
     //将触摸事件添加到当前view
     [self.view addGestureRecognizer:tapGestureRecognizer];
}

////隐藏键盘
- (void)hideKeyBoard
{
    [_detailTextView resignFirstResponder];
    
}

- (IBAction)touchIndex:(UIButton *)sender {
        
    for (UIButton *btn in _selectButtons) {
        btn.selected = NO;
    }
    sender.selected =  !sender.selected ;

    
    _style = sender.tag;
    if (_style==2) {
        _contextTV.hidden = NO;
        _comintButton.top= 452 ;
    }else{
        _contextTV.hidden = YES;
        _comintButton.top= 200 ;

    }
    
    
}
- (IBAction)comitFeed:(id)sender {
    
    if (_style == 2 ) {
        
        if (_detailTextView.text.length<1) {
            [MBProgressHUD showError:@"请输入反馈原因!"]; return;
        }
    }
    [self loadEvaluateData];
}

#pragma mark 评分
-(void)loadEvaluateData{
    NSString * api = [API_HOST stringByAppendingString:youFun_evaluate];
    NSDictionary*diciton = @{@"merchantId": _storeID , @"page":@"1" ,@"limit":@"100"};
    
    WS(weakself);
    [HttpEngine requestGetWithURL:api params:diciton isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {

        [MBProgressHUD showSuccess:@"反馈成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
//        [weakself.collectionView.mj_footer endRefreshing];
//        [weakself.collectionView.mj_header endRefreshing];
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
