//
//  LYPChangeOtherPasswordCell.m
//  Owner
//
//  Created by YP on 2019/1/17.
//

#import "LLModyPayPassCell.h"

@interface LLModyPayPassCell ()

@property (nonatomic,strong)UIView *line;

@end

@implementation LLModyPayPassCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
#pragma mark--createUI
-(void)createUI{
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.line];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CGFloatBasedI375(15));
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(CGFloatBasedI375(-1));
        make.right.mas_equalTo(CGFloatBasedI375(-15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CGFloatBasedI375(15));
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(CGFloatBasedI375(-15));
        make.height.mas_equalTo(CGFloatBasedI375(1));
    }];
}
-(void)setPlaceholder:(NSString *)placeholder{
    _textField.placeholder=placeholder;
}

#pragma mark-----lazy--
-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:CGFloatBasedI375(14)];
    }
    return _textField;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor =[UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _line;
}


@end
