//
//  LLEnterpriseDetailViewCell.m
//  LLTalentGang
//
//  Created by lijun L on 2019/7/2.
//  Copyright © 2019年 lijun L. All rights reserved.
//

#import "LLRightCell.h"

@implementation LLRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = White_Color;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        [self setLayout];
        
    }
    return self;
}

-(void)setLayout{
    WS(weakself);
    
    [self.titlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(CGFloatBasedI375(15));
        make.width.offset(CGFloatBasedI375(130));
        make.height.offset(CGFloatBasedI375(14));
        make.centerY.equalTo(weakself.mas_centerY);
        
    }];
    [self.showimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(CGFloatBasedI375(-15));
        make.width.height.offset(CGFloatBasedI375(40));
        make.centerY.equalTo(weakself.mas_centerY);
    }];

    [self.rightlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(CGFloatBasedI375(-35));
        make.height.offset(CGFloatBasedI375(14));
        make.width.offset(CGFloatBasedI375(200));
        make.centerY.equalTo(weakself.mas_centerY);
    }];
    [self.delable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(CGFloatBasedI375(-15));
        make.height.offset(CGFloatBasedI375(14));
        make.left.equalTo(weakself.titlelable.mas_right).offset(CGFloatBasedI375(10));
        make.centerY.equalTo(weakself.mas_centerY);
    }];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(CGFloatBasedI375(-15));
        make.height.offset(CGFloatBasedI375(30));
        make.left.equalTo(weakself.titlelable.mas_right).offset(CGFloatBasedI375(10));
        make.centerY.equalTo(weakself.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(CGFloatBasedI375(15));
        make.right.offset(CGFloatBasedI375(-15));
        make.height.offset(CGFloatBasedI375(1));
        make.bottom.offset(CGFloatBasedI375(0));
        
    }];
}

- (UIImageView *)showimage{
    if(!_showimage){
        _showimage = [[UIImageView alloc]init];
        _showimage.image =[UIImage imageNamed:DefluatPic];
        _showimage.hidden = YES;
//        _showimage.layer.masksToBounds = YES;
//        _showimage.layer.cornerRadius = CGFloatBasedI375(40/2);
        [self addSubview:self.showimage];
    }
    return _showimage;
}
-(UILabel *)titlelable{
    if(!_titlelable){
        _titlelable = [[UILabel alloc]init];
        _titlelable.font = [UIFont systemFontOfSize:15 ];
        _titlelable.textAlignment = NSTextAlignmentLeft;
        _titlelable.text = @"";
        _titlelable.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:self.titlelable];
        
    }
    return _titlelable;
}
-(UILabel *)rightlable{
    if(!_rightlable){
        _rightlable = [[UILabel alloc]init];
        _rightlable.font = [UIFont systemFontOfSize:15];
        _rightlable.textAlignment = NSTextAlignmentRight;
        _rightlable.text = @"13800138000";
        _rightlable.hidden= YES;
        _rightlable.textColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:self.rightlable];
        
    }
    return _rightlable;
}
-(UILabel *)delable{
    if(!_delable){
        _delable = [[UILabel alloc]init];
        _delable.font = [UIFont systemFontOfSize:13];
        _delable.textAlignment = NSTextAlignmentRight;
        _delable.text = @"13800138000";
        _delable.hidden= YES;
        _delable.textColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:self.delable];
        
    }
    return _delable;
}
- (UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self addSubview:_lineView];
    }
    return _lineView;
}
-(UITextField *)textview{
    if(!_textview){
     _textview =[[ UITextField alloc]init];
        _textview.textAlignment = NSTextAlignmentRight;
        _textview.font = [UIFont fontWithName:@"arial" size:15];
        if (IOS_VERSION>=13.0) {
            _textview.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_textview.text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"cccccc"]}];
        }else{
            [_textview setValue:[UIColor colorWithHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
        }

        [self addSubview:_textview];
        
    }
    return _textview;
}

-(ZWTextView*)contentTextView{
    
    if (!_contentTextView) {
        _contentTextView = [[ZWTextView alloc] initWithFrame:CGRectMake(15,40,SCREEN_WIDTH-30,80) TextFont:[UIFont systemFontOfSize:15] MoveStyle:styleMove_Down];
          _contentTextView.maxNumberOfLines = 4;
           _contentTextView.maxLength = 200;
           _contentTextView.placeholder = @"请输入门店介绍，至少输入10个字符，最多可输入 200个字符。 ";
           _contentTextView.inputText = @"";
           _contentTextView.textColor = [UIColor blackColor];
           [_contentTextView draCirlywithColor:nil andRadius:1.0f];
    }
   
    return _contentTextView;
}
@end
