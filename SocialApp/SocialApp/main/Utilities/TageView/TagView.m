//
//  TagView.m
//  waimai
//
//  Created by jochi on 2018/7/26.
//  Copyright © 2018年 jochi. All rights reserved.
//

#import "TagView.h"
//#import "UIView+JMRadius.h"
@implementation TagView

-(void)setArr:(NSArray *)arr{
    _arr = arr;
    CGFloat marginX = 5;
    CGFloat marginY = 10;
    CGFloat height = CGFloatBasedI375(24);
    if (!self.space) {
        self.space = marginX;
    }
    if (!self.marginY) {
        self.marginY = marginX;
    }
    if (!self.fontSize) {
        self.fontSize = 13;
    }
    if (self.height) {
        height = self.height;
    }
    
    if (!self.titleMargin) {
        self.titleMargin = 11;
    }
    if (!self.cornerRadius) {
        self.cornerRadius = 15;
    }
    
    if (!self.defaultTitleColor) {
        self.defaultTitleColor = Main_title_Color;
    }
    
    if (!self.defaultBgColor) {
        self.defaultBgColor = HKColor(@"#F2F6F6");
    }
    
    if (!self.selectTitleColor) {
        self.selectTitleColor = [UIColor HexString:@"#00A2E7"];
    }
    
    if (!self.selectBgColor) {
        self.selectBgColor = [HKColor(@"#00A2E7") colorWithAlphaComponent:0.08];
    }
   [self layoutIfNeeded];
    if (self.viewWidth == 0) {
        self.viewWidth = SCREEN_WIDTH;
    }
//    CGFloat viewWidth = self.frame.size.width;
    UIButton * markBtn;
    for (int i = 0; i < _arr.count; i++) {
        CGFloat width =  [self calculateString:_arr[i] Width:self.fontSize] + self.titleMargin*2;
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.titleLabel.numberOfLines = 0;
        [tagBtn setTitle:_arr[i] forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        [tagBtn setTitleColor:[UIColor HexString:@"#666666"] forState:UIControlStateNormal];
        [tagBtn setImage:self.defaultImage forState:0];
        [tagBtn setImage:self.selectImage forState:UIControlStateSelected];
        tagBtn.backgroundColor = HKColor(@"#F9F9FB");
        [tagBtn addTarget:self action:@selector(clickTo:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewsArray addObject:tagBtn];
        [self addSubview:markBtn];
        [self addSubview:tagBtn];
        
        tagBtn.tag = 2019+i;
        if (!markBtn) {
            [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(self.marginY);
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
        }else{
#warning 2019.11.29 markBtn.frame.origin.x + markBtn.frame.size.width + marginX + width + marginX > SCREEN_WIDTH-self.leftAndRightMargin*2
            if (markBtn.frame.origin.x + markBtn.frame.size.width + marginX + width + marginX > self.viewWidth-self.leftAndRightMargin*2) {
                [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.equalTo(markBtn.mas_bottom).offset(self.marginY);
                    make.size.mas_equalTo(CGSizeMake(width, height));
                }];
            }else{
                [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(markBtn.mas_right).offset(self.space);
                    make.top.equalTo(markBtn.mas_top);
                    make.size.mas_equalTo(CGSizeMake(width, height));
                }];
            }
        }
        markBtn = tagBtn;
        
        [self setDefaultLayer:tagBtn];
        
        [self layoutIfNeeded];
    }
    [markBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-marginY).priorityHigh();
    }];
    [self layoutIfNeeded];
    self.selectBtn = [UIButton new];
}

-(void)clickTo:(UIButton *)sender{
    
    if (self.selectType == selectType_one) {
        
        if (self.selectBtn != sender) {
            sender.selected = !sender.selected;
            [self setSelectLayer:sender];
            [self setDefaultLayer:self.selectBtn];
            self.selectBtn = sender;
        }else {
            sender.selected = !sender.selected;
            if(sender.selected){
                [self setSelectLayer:sender];
            }else{
                [self setDefaultLayer:sender];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(handleSelectTag:isSelect:)]) {
            [self.delegate handleSelectTag:sender.titleLabel.text isSelect:sender.selected];
        }
        if ([self.delegate respondsToSelector:@selector(handleSelectTagRow:)]) {
            [self.delegate handleSelectTagRow:sender.tag-2019];
        }
    }else {
        sender.selected = !sender.selected;
        if(sender.selected){
            [self setSelectLayer:sender];
        }else{

            [self setDefaultLayer:sender];
        }
        if ([self.delegate respondsToSelector:@selector(handleSelectTag:isSelect:)]) {
            [self.delegate handleSelectTag:sender.titleLabel.text isSelect:sender.selected];
        }
        if ([self.delegate respondsToSelector:@selector(handleSelectTagRow:)]) {
            [self.delegate handleSelectTagRow:sender.tag-2019];
        }
    }
    
}


- (void) setDefaultLayer:(UIButton *)sender {
    sender.layer.borderColor = HKColor(@"#F2F6F6").CGColor;
    sender.layer.borderWidth = .5;
    sender.backgroundColor = self.defaultBgColor;
    [sender setTitleColor:self.defaultTitleColor forState:UIControlStateNormal];
    sender.layer.cornerRadius = self.cornerRadius;
    sender.clipsToBounds = YES;
}

- (void) setSelectLayer:(UIButton *)sender {
    sender.layer.borderColor = HKColor(@"#00A2E7").CGColor;
    sender.layer.borderWidth = .5;
    sender.backgroundColor = self.selectBgColor;
    [sender setTitleColor:self.selectTitleColor forState:UIControlStateNormal];
    sender.layer.cornerRadius = self.cornerRadius;
    sender.clipsToBounds = YES;
}

-(CGFloat)calculateString:(NSString *)str Width:(NSInteger)font{
    CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

- (NSMutableArray *)viewsArray {
    if (!_viewsArray) {
        _viewsArray = [NSMutableArray array];
    }
    return _viewsArray;
}
@end
