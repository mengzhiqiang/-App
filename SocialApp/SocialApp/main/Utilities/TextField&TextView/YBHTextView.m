//
//  YBHTextView.m
//  YBHTextView
//
//  Created by YBH on 2017/8/3.
//  Copyright © 2017年 yunshi. All rights reserved.
//

#import "YBHTextView.h"


@interface YBHTextView()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;
// 字数
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation YBHTextView

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//
//        self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [self addSubview:self.placeholderLabel];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:5]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:7]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
//
//        self.delegate = self;
//    }
//    return self;
//}

// 写在这里为了兼容代码创建和xib创建
- (void)drawRect:(CGRect)rect {
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.placeholderLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    if (self.fontSize == 0) {
        self.fontSize = 15;
    }
    self.font = [UIFont systemFontOfSize:self.fontSize];
    self.delegate = self;
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//
//    self.numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:self.numberLabel];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.numberLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:rect.size.width - 10]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.numberLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:rect.size.height - 10]];
//}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textViewDidChangeBlock) {
        self.textViewDidChangeBlock(textView);
    }
    
    NSString *toBeString = textView.text;
    
    if (toBeString.length > 0) { // 显示隐藏占位符
        self.placeholderLabel.hidden = YES;
    }else {
        self.placeholderLabel.hidden = NO;
    }
    
    if (self.limitLength > 0) { // 限制长度
        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > self.limitLength)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.limitLength];
                if (rangeIndex.length == 1)
                {
                    textView.text = [toBeString substringToIndex:self.limitLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limitLength)];
                    textView.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textViewShouldBeginEditingBlock) {
        return self.textViewShouldBeginEditingBlock(textView);
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.textViewShouldEndEditingBlock) {
        self.textViewShouldEndEditingBlock(textView);
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.textViewDidBeginEditingBlock) {
        self.textViewDidBeginEditingBlock(textView);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.textViewDidEndEditingBlock) {
        self.textViewDidEndEditingBlock(textView);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.textViewShouldChangeTextInRangeReplacementTextBlock) {
        return self.textViewShouldChangeTextInRangeReplacementTextBlock(textView, range, text);
    }
    return YES;
}

#pragma mark - get

- (UILabel *)placeholderLabel {
    if (_placeholderLabel) return _placeholderLabel;
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.font = [UIFont systemFontOfSize:15];
    _placeholderLabel.numberOfLines = 0;
    return _placeholderLabel;
}

- (UILabel *)numberLabel {
    if (_numberLabel) return _numberLabel;
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.textColor = [UIColor darkTextColor];
    _numberLabel.font = [UIFont systemFontOfSize:14];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.backgroundColor = [UIColor redColor];
    return _numberLabel;
}

#pragma markk - set

- (void)setPlaceholderFontSize:(NSInteger)placeholderFontSize {
    _placeholderFontSize = placeholderFontSize;
    self.placeholderLabel.font = [UIFont systemFontOfSize:placeholderFontSize];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.placeholderLabel.text = _placeholder;
}

- (void)setLimitLength:(NSInteger)limitLength {
    _limitLength = limitLength;
    
    if (_limitLength > 0) {
        self.numberLabel.text = [NSString stringWithFormat:@"0/%zd",_limitLength];
    }
    
}

@end
