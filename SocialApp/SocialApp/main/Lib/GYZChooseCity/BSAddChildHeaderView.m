//
//  BSAddChildHeaderView.m
//  BikeStore
//
//  Created by libj on 2019/11/6.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "BSAddChildHeaderView.h"
#import "UIButton+Extenxion.h"
@interface BSAddChildHeaderView ()
@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation BSAddChildHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBaseAttribute];
        [self setupSubviews];
        [self setupSubviewsLayout];
    }
    return self;
}

- (void) setBaseAttribute {
    WS(weakself);
    self.textStr = @"";
    [self.textField setTextFieldDidChangeBlock:^BOOL(UITextField *textField) {
//        STRONGSELF
        weakself.textStr = textField.text;
        if (weakself.TextFieldDidChangeBlock) {
            weakself.TextFieldDidChangeBlock(self.textField.text);
        }
        return YES;
    }];
    [self.textField setTextFieldShouldReturnBlock:^BOOL(UITextField *textField) {
        
        if (!textField.text.length){
            [MBProgressHUD showError:@"请输入搜索关键词"];return NO;
        }
        if (weakself.sendBlock) {
            weakself.sendBlock();
        }
        return YES;
    }];
}

- (void) setupSubviews {
    [self addSubview:self.textBgView];
    [self addSubview:self.cancelBtn];
    [self.textBgView addSubview:self.textField];
}

- (void) setupSubviewsLayout {
    [self.textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.height.equalTo(@30);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13.5);
        make.right.offset(-13.5);
        make.top.bottom.offset(0);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textBgView);
        make.right.offset(-15);
        make.left.equalTo(self.textBgView.mas_right).offset(15);
        make.width.equalTo(@35);
    }];
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}
#pragma mark - 取消
- (void)cancelBtnAction {
    if (self.cancelBtnBlock) {
        self.cancelBtnBlock();
    }
}
#pragma mark 懒加载
- (UIView *)textBgView {
    if (!_textBgView) {
        _textBgView = [UIView new];
        _textBgView.backgroundColor = [UIColor HexString:@"F5F5F5"];
        _textBgView.layer.cornerRadius = 15;
        _textBgView.clipsToBounds = YES;
    }
    return _textBgView;
}

- (YBHTextFiled *)textField {
    if (!_textField) {
        _textField = [YBHTextFiled new];
        _textField.placeholder = @"请输入城市名称";
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [UIImageView new];
        _iconImage.image = UIImageName(@"sousuo");
    }
    return _iconImage;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithTitle:@"取消" imageName:@"" titleColor:[UIColor blackColor] bgColor:White_Color fontSize:16];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end
