//
//  LMHMessageHeaderView.m
//  BaseProject
//
//  Created by libj on 2019/9/17.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHMessageHeaderView.h"

@interface LMHMessageHeaderView ()

@property (nonatomic, strong) LMHMessageView *systemView;
@property (nonatomic, strong) LMHMessageView *dealView;

@end

@implementation LMHMessageHeaderView

- (void)setIsShowdealDot:(BOOL)isShowdealDot {
    _isShowdealDot = isShowdealDot;
    self.dealView.isShowDot = isShowdealDot;
}

- (void)setIsShowSystemDot:(BOOL)isShowSystemDot {
    _isShowdealDot = isShowSystemDot;
    self.systemView.isShowDot = isShowSystemDot;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


- (void) setupSubviews {
    
    self.backgroundColor = White_Color;
    
    [self addSubview:self.systemView];
    [self addSubview:self.dealView];
    
    [self.systemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(94);
    }];
    
    [self.dealView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(94);
        make.left.equalTo(self.systemView.mas_right);
    }];
}

- (void)clickACtion:(LMHMessageView *)sender {
    NSInteger index = 1;
    if (sender == self.dealView) {
        index = 2;
    }
    if (self.selectIndexBlock) {
        self.selectIndexBlock(index);
    }
}

- (LMHMessageView *)dealView {
    if (!_dealView) {
        _dealView = [LMHMessageView new];
        [_dealView addTarget:self action:@selector(clickACtion:) forControlEvents:UIControlEventTouchUpInside];
        _dealView.desLabel.text = @"交易消息";
        _dealView.iconImageView.image = [UIImage imageNamed:@"grzx_icon_jyxx_big"];
    }
    return _dealView;
}

- (LMHMessageView *)systemView {
    if (!_systemView) {
        _systemView = [LMHMessageView new];
        [_systemView addTarget:self action:@selector(clickACtion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _systemView;
}
@end


@implementation LMHMessageView

- (void)setIsShowDot:(BOOL)isShowDot {
    _isShowDot = isShowDot;
    self.redDotView.hidden = isShowDot;
}

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
    
}

- (void) setupSubviews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.desLabel];
    [self addSubview:self.redDotView];
}

- (void) setupSubviewsLayout {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(42));
        make.height.equalTo(@(40));
        make.top.offset(15);
        make.centerX.equalTo(self);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
    
    [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top).offset(-3.5);
        make.right.equalTo(self.iconImageView.mas_right).offset(3.5);
        make.width.height.mas_equalTo(7);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.image = [UIImage imageNamed:@"grzx_icon_xtxx_big"];
    }
    return _iconImageView;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.text = @"系统消息";
        _desLabel.font = PFR15Font;
        _desLabel.textColor = Main_title_Color;
    }
    return _desLabel;
}
- (UIView *)redDotView {
    if (!_redDotView) {
        _redDotView = [UIView new];
        _redDotView.backgroundColor = [UIColor HexString:@"#FF4444"];
        _redDotView.layer.cornerRadius = 3.5;
        _redDotView.hidden = YES;
    }
    return _redDotView;
}
@end
