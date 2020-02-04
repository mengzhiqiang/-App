//
//  LMHFeedBackVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/3.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHFeedBackVC.h"
#import "ZWTextView.h"
@interface LMHFeedBackVC ()
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) ZWTextView *textView ;

@end

@implementation LMHFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"意见反馈";
    // Do any additional setup after loading the view from its nib.
    _textView = [[ZWTextView alloc] initWithFrame:CGRectMake(15,17,SCREEN_WIDTH-30,80) TextFont:[UIFont systemFontOfSize:15] MoveStyle:styleMove_Down];
    
//    textView.maxNumberOfLines = 4;
    _textView.maxLength = 200;
    _textView.placeholder = @"请填写10个字以上的问题描述";
    _textView.inputText = @"";
    _textView.textColor = Main_title_Color;
    _textView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(80);
    }];
    WS(weakself);
    _textView.textViewHeightChange = ^(CGFloat height) {
        weakself.countLbl.text = [NSString stringWithFormat:@"%ld/200", weakself.textView.text.length];
    };
}

- (IBAction)confirmAction:(UIButton *)sender {
    
    if (_textView.text.length<10) {
        [MBProgressHUD showError:@"请填写10个字以上的问题描"]; return;
    }
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_opinion_addOpinion];
    
    NSDictionary *dic = @{@"describe":_textView.text ,@"userId":[CommonVariable getUserInfo].userId};
    [HttpEngine requestPostWithURL:path params:dic isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        if ([responseObject objectForKey:@"data"]) {
          
        }
        [MBProgressHUD showSuccess:@"反馈成功！"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
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
