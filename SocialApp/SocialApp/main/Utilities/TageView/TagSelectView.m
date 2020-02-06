//
//  TagSelectView.m
//  BikeUser
//
//  Created by libj on 2019/11/7.
//  Copyright © 2019 gwp. All rights reserved.
//

#import "TagSelectView.h"

@implementation TagSelectView

-(void)setArr:(NSArray *)arr{
    _arr = arr;
    CGFloat marginX = 5;
    CGFloat marginY = 10;
    CGFloat height = CGFloatBasedI375(24);
    if (!self.space) {
        self.space = marginX;
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
    
    UIView * markBtn;
    for (int i = 0; i < _arr.count; i++) {
        CGFloat width =  [self calculateString:_arr[i] Width:self.fontSize] + self.titleMargin*2;
        
        UIView *tagVew = [UIView new];
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        tagBtn.backgroundColor = Main_BG_Color;
        tagBtn.layer.cornerRadius = 10;
        tagBtn.clipsToBounds = YES;
        
        [tagBtn addTarget:self action:@selector(clickTo:) forControlEvents:UIControlEventTouchUpInside];
        
        [tagVew addSubview:tagBtn];
        
        UILabel *label = [UILabel labelWithText:_arr[i] textColor:Main_title_Color fontSize:self.fontSize];
        [tagVew addSubview:label];
        
        tagBtn.tag = 2019+i;
        [self.viewsArray addObject:tagBtn];
        [self addSubview:markBtn];
        [self addSubview:tagVew];
        if (!markBtn) {
            [tagVew mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(marginY);
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
        }else{
            if (markBtn.frame.origin.x + markBtn.frame.size.width + marginX + width + marginX > SCREEN_WIDTH-self.leftAndRightMargin*2) {
                [tagVew mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.equalTo(markBtn.mas_bottom).offset(marginY);
                    make.size.mas_equalTo(CGSizeMake(width, height));
                }];
            }else{
                [tagVew mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(markBtn.mas_right).offset(self.space);
                    make.top.equalTo(markBtn.mas_top);
                    make.size.mas_equalTo(CGSizeMake(width, height));
                }];
            }
        }
        markBtn = tagVew;
        
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.equalTo(tagVew);
            make.size.equalTo(@(CGSizeMake(20, 20)));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tagBtn.mas_right).offset(5);
            make.centerY.equalTo(tagVew);
        }];
        
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
    
    if (self.selectType == TagSelectViewType_one) {
        
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
            [self.delegate handleSelectTag:self.arr[sender.tag-2019] isSelect:sender.selected];
        }
    }else {
        sender.selected = !sender.selected;
        if(sender.selected){
            [self setSelectLayer:sender];
        }else{

            [self setDefaultLayer:sender];
        }
        if ([self.delegate respondsToSelector:@selector(handleSelectTag:isSelect:)]) {
            [self.delegate handleSelectTag:self.arr[sender.tag-2019] isSelect:sender.selected];
        }
    }
    
}


- (void) setDefaultLayer:(UIButton *)sender {
    [sender setImage:UIImageName(@"") forState:0];
}

- (void) setSelectLayer:(UIButton *)sender {
    [sender setImage:UIImageName(@"icon_check_small") forState:0];
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
