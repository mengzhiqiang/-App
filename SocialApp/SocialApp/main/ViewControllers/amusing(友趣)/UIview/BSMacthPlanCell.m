//
//  BSMacthPlanCell.m
//  BikeStore
//
//  Created by libj on 2019/11/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "BSMacthPlanCell.h"
#import "UILabel+Extension.h"
@interface BSMacthPlanCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation BSMacthPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.rightImage];
    [self.contentView addSubview:self.titleLabel];
}

- (void) setupSubviewsLayout {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.equalTo(@0.5);
        make.bottom.offset(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@(CGFloatBasedI375(80)));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
        make.right.offset(-15);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@30);
    }];
    
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(@(CGSizeMake(13, 13)));
    }];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

- (void)setTextStr:(NSString *)textStr {
    _textStr = textStr;
    self.textField.text = textStr;
}

- (void)setTextFieldType:(TextFieldType)textFieldType {
    _textFieldType = textFieldType;
    if (textFieldType == textFieldType_default) {
        self.rightImage.hidden = YES;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
        }];
        self.textField.userInteractionEnabled = YES;
    }else if (textFieldType == textFieldType_select) {
        self.rightImage.hidden = YES;
        self.textField.userInteractionEnabled = NO;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
        }];
    }else if (textFieldType == textFieldType_select_icon) {
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-27);
        }];
        self.rightImage.hidden = NO;
        self.textField.userInteractionEnabled = NO;
    }
}

- (void)textfiledChange {
    
    if ([self.delegate respondsToSelector:@selector(BSMacthPlanCell:textString:)]) {
        [self.delegate BSMacthPlanCell:self textString:self.textField.text];
    }
}

#pragma mark 懒加载
-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = Main_BG_Color;
    }
    return _lineView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:@"报名类型" textColor:Main_title_Color fontSize:15];
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.placeholder = @"请输入";
        _textField.font = FontSize(15);
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.keyboardType =  UIKeyboardTypeDecimalPad;
        [_textField addTarget:self action:@selector(textfiledChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIImageView *)rightImage {
    if (!_rightImage) {
        _rightImage = [UIImageView new];
        _rightImage.image = UIImageName(@"btn_more_gray");
    }
    return _rightImage;
}

@end
