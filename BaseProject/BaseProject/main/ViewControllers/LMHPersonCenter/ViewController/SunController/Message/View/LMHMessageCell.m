//
//  LMHMessageCell.m
//  BaseProject
//
//  Created by libj on 2019/9/17.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHMessageCell.h"
#import "LMHMessageModel.h"
#import "NSDate+Extension.h"

@interface LMHMessageCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *redDotView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *linView;

@end

@implementation LMHMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LMHMessageModel *)model {
    
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    NSString *imageNmae = model.messageType == 1 ? @"grzx_icon_jyxx": @"grzx_icon_jyxx_big";
    self.iconImageView.image = [UIImage imageNamed:imageNmae];
    self.redDotView.hidden = model.isRead == 2 ? YES : NO;
    self.timeLabel.text = [NSDate stringConversionNSDateStr:model.creatTime formatter:@"MM-dd HH:mm"];
    
}

#pragma mark - Cell生命周期
/** 0 init 带参数初始化  */
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self setBaseAttribute];
        [self setupSubviews];
        [self setupSubviewsLayout];
    }
    return self;
}

- (void) setBaseAttribute {
    
}

- (void) setupSubviews {
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.redDotView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.linView];
}

- (void) setupSubviewsLayout {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top).offset(-3.5);
        make.right.equalTo(self.iconImageView.mas_right).offset(3.5);
        make.width.height.mas_equalTo(7);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.top.equalTo(self.iconImageView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.offset(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.offset(-14);
    }];
    [self.linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.left.offset(15);
        make.bottom.offset(0);
        make.height.mas_equalTo(1);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.image = [UIImage imageNamed:@"grzx_icon_jyxx"];
    }
    return _iconImageView;
}

- (UIView *)redDotView {
    if (!_redDotView) {
        _redDotView = [UIView new];
        _redDotView.backgroundColor = [UIColor HexString:@"#FF4444"];
        _redDotView.layer.cornerRadius = 3.5;
    }
    return _redDotView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"订单消息";
        _titleLabel.font = PFR15Font;
        _titleLabel.textColor = Main_title_Color;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.text = @"07/25 10:00";
        _timeLabel.font = PFR12Font;
        _timeLabel.textColor = Sub_title_Color;
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.text = @"您好！您的订单（13840184）未支付已取消，若您还需要此订单商品，请重新采购下单！";
        _contentLabel.font = PFR12Font;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = Sub_title_Color;
    }
    return _contentLabel;
}
- (UIView *)linView {
    if (!_linView) {
        _linView = [UIView new];
        _linView.backgroundColor = Main_BG_Color;
    }
    return _linView;
}
@end
