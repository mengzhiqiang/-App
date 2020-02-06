//
//  LLXieyiview.m
//  LLMiaiProject
//
//  Created by lijun L on 2019/3/9.
//  Copyright © 2019年 lijun L. All rights reserved.
//

#import "LLXieyiview.h"
#import "Masonry.h"
@interface LLXieyiview ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *backView;/** <#class#> **/
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIWebView *webView;/** <#class#> **/
@property (nonatomic,strong) UILabel *noticeLabel;/** <#class#> **/
@end
@implementation LLXieyiview

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setLayout];
//        self.backgroundColor = wh;
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_HOST,@"/h5/user.html"]]]];

    }
    return self;
}

-(void)setLayout{

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.right.offset(-13);
        make.height.offset(420);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.top.offset(10);
        make.height.offset(25);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.top.equalTo(self.noticeLabel.mas_bottom).offset(10);
        make.bottom.offset(-40);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.bottom.offset(0);
        make.height.offset(40);
    }];
}
-(UIView *)backView{
    if(!_backView){
        _backView  = [[UIView alloc]init];
                _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius =5;
        [self addSubview: self.backView];
        _backView.backgroundColor = [UIColor whiteColor];

    }
    return _backView;
}

-(UILabel *)noticeLabel{
    if(!_noticeLabel){
        _noticeLabel = [[UILabel alloc]init];
        _noticeLabel.font = [UIFont systemFontOfSize:13];
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.text = @"用户隐私协议须知";
        _noticeLabel.textColor = [UIColor blackColor];
        [self.backView addSubview:self.noticeLabel];
        
    }
    return _noticeLabel;
}
-(UIWebView*)webView{
    if (!_webView) {
        
        // 高端的自定义配置创建WKWebView
        _webView = [[UIWebView alloc] init];
        [self.backView addSubview: self.webView];

    }
    return _webView;
}
-(UIButton *)sureBtn{
    if(!_sureBtn){
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"同意以上协议(已阅读)" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont fontWithName:@"arial" size:13];;
        [_sureBtn setEnabled:30];
        [_sureBtn addTarget:self action:@selector(pickerEnsureBtnTarget) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview: self.sureBtn];
    }
    return _sureBtn;
}
-(void)pickerEnsureBtnTarget{
    [self hideActionSheetView];
}
/********************  Animation  *******************/

- (void)showActionSheetView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self layoutIfNeeded];
    
    CGRect tempFrame = self.backView.frame;
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25f animations:^{
            self.backView.frame = tempFrame;
        }];
    }];
}

- (void)hideActionSheetView {
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.25f animations:^{
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }];
}
@end
