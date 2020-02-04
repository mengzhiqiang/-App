//
//  LMHLiveTVCell1.m
//  BaseProject
//
//  Created by libj on 2019/9/23.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHLiveTVCell1.h"
#import "LMHVideoModel.h"
#import "NSDate+Extension.h"
@interface LMHLiveTVCell1 ()
@property (nonatomic, strong) UIView *backView;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *titleLbl;
@property (strong, nonatomic) UIImageView *desIV;
@property (strong, nonatomic) UILabel *nameLbl;
@property (strong, nonatomic) UILabel *stateLbl;
@property (strong, nonatomic) UILabel *countLbl;

@end
@implementation LMHLiveTVCell1


- (void)setModel:(LMHVideoModel *)model {
    _model = model;
    [self.desIV setImageWithURL:[model.cover changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
    [self.icon setImageWithURL:[model.logo changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
    self.nameLbl.text = model.liveName;
    self.titleLbl.text = model.brandName;
    self.stateLbl.text = [NSString stringWithFormat:@"    %@    ",[self getStateString:model.status]];
    int x = arc4random() % 1000;
    if (!self.countLbl.text.length) {
        if (model.status == 0) {
            [NSDate stringConversionNSDateStr:model.playTimeStart formatter:@"YYYY-MM-dd HH:mm"];
            self.countLbl.text = [NSDate stringConversionNSDateStr:model.playTimeStart formatter:@"YYYY-MM-dd HH:mm"];
            self.countLbl.hidden = NO;

        }else {
            self.countLbl.text = [NSString stringWithFormat:@"%d人观看",x];
            self.countLbl.hidden = YES;
        }
    }
    
}

//直播状态0-待播放 1-播放中 2-已结束-1-已作废
- (NSString *)getStateString:(NSInteger)state {
 
    switch (state) {
        case 0:
            return @"预告";
            break;
        case 1:
            return @"直播中";
            break;
        case 2:
            return @"待播放";
            break;
        case -1:
            return @"待播放";
            break;
        default:
            break;
    }
    return @"";
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
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.icon];
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.desIV];
    [self.backView addSubview:self.nameLbl];
    [self.backView addSubview:self.stateLbl];
    [self.backView addSubview:self.countLbl];
}

- (void) setupSubviewsLayout {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.bottom.offset(0);
        make.right.offset(-0);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.width.height.mas_equalTo(34);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(7);
        make.centerY.equalTo(self.icon);
    }];
    
    [self.desIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(15);
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(-64);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.desIV.mas_bottom).offset(10);
    }];
    
    [self.stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateLbl);
        make.left.equalTo(self.stateLbl.mas_right).offset(6);
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = White_Color;
        _backView.layer.cornerRadius = 8;
        _backView.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.2].CGColor;
        _backView.layer.shadowOffset = CGSizeMake(0,1);
        _backView.layer.shadowOpacity = 1;
        _backView.layer.shadowRadius = 4;
    }
    return _backView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.layer.cornerRadius = 17;
        _icon.backgroundColor = [UIColor redColor];
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UIImageView *)desIV {
    if (!_desIV) {
        _desIV = [UIImageView new];
        _desIV.backgroundColor = [UIColor whiteColor];
        _desIV.contentMode = UIViewContentModeScaleAspectFill;
        _desIV.clipsToBounds = YES;
    }
    return _desIV;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.text = @"title";
        _titleLbl.font = [UIFont systemFontOfSize:16];
        _titleLbl.textColor = Main_title_Color;
    }
    return _titleLbl;
}

- (UILabel *)nameLbl {
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        _nameLbl.text = @"_nameLbl";
        _nameLbl.font = [UIFont systemFontOfSize:16];
        _nameLbl.textColor = Main_title_Color;
    }
    return _nameLbl;
}

- (UILabel *)stateLbl {
    if (!_stateLbl) {
        _stateLbl = [UILabel new];
        _stateLbl.text = @"_stateLbl";
        _stateLbl.font = [UIFont systemFontOfSize:10];
        _stateLbl.backgroundColor = [UIColor HexString:@"#FFD6B2"];
        _stateLbl.textColor = [UIColor HexString:@"#FF7700"];
        _stateLbl.layer.cornerRadius = 8;
        _stateLbl.clipsToBounds = YES;
    }
    return _stateLbl;
}
- (UILabel *)countLbl {
    if (!_countLbl) {
        _countLbl = [UILabel new];
        _countLbl.text = @"";
        _countLbl.font = [UIFont systemFontOfSize:10];
        _countLbl.textColor = Main_title_Color;
    }
    return _countLbl;
}
@end

