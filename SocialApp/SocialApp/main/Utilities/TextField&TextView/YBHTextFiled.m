//
//  YBHTextFiled.m
//  YBHTextFiled
//
//  Created by 杨璧华 on 2017/8/2.
//  Copyright © 2017年 yunshi. All rights reserved.
//

#import "YBHTextFiled.h"

@interface YBHTextFiled ()<UITextFieldDelegate>

@end

@implementation YBHTextFiled

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self addTarget:self action:@selector(textFieldTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
//        self.delegate = self;
//    }
//    return self;
//}

// 写在这里为了兼容代码创建和xib创建
- (void)drawRect:(CGRect)rect {
    [self addTarget:self action:@selector(textFieldTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    

    self.delegate = self;
}

- (void)textFieldTextEditingChanged:(id)sender {
    

    UITextField *textField = (UITextField *)sender;
    if(_textFieldDidChangeBlock){
        _textFieldDidChangeBlock(textField);
    }
    if (self.limitLength == 0) {
        return;
    }
    
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    NSUInteger length = 0;
    NSUInteger shuzi = 0;
    NSUInteger zhongwen = 0;
    for(int i=0; i< [textField.text length];i++)

    {

        int a = [textField.text characterAtIndex:i];
        
        if( a > 0x4e00 && a < 0x9fff)//判断输入的是否是中文

        {

            length  = length + 2;
            zhongwen ++;

        }else{
            length ++;
            shuzi ++;
        }

    }

    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (length > self.limitLength*2 )
        {
            //全为汉字
            if ([self deptNameInputShouldChinese:textField.text]) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.limitLength];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:self.limitLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limitLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }else if ([self deptIdInputShouldAlphaNum:textField.text]) {//字母或数字
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.limitLength*2];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:self.limitLength*2];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limitLength*2)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }else{//字母或数字符号
                NSInteger lengthLim = shuzi+zhongwen>self.limitLength?self.limitLength:shuzi+zhongwen-1;
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:lengthLim];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:lengthLim];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, lengthLim)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }

            }
            
            
           
        }
    }

}
//字母或数字
- (BOOL) deptIdInputShouldAlphaNum:(NSString *)string

{
    
    NSString *regex =@"[a-zA-Z0-9]*";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if ([pred evaluateWithObject:string]) {
        
        return YES;
        
    }
    
    return NO;
    
}
//字符串长度(汉字2字节)
-(NSUInteger)textLength: (NSString *) text{
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
    
}
#pragma mark 输入中文

- (BOOL) deptNameInputShouldChinese:(NSString *)string

{
    
    NSString *regex = @"[\u4e00-\u9fa5]+";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if ([pred evaluateWithObject:string]) {
        
        return YES;
        
    }
    
    return NO;
    
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.textFieldShouldBeginEditingBlock) {
        return self.textFieldShouldBeginEditingBlock(textField);
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.textFieldDidBeginEditingBlock) {
        self.textFieldDidBeginEditingBlock(textField);
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.textFieldShouldEndEditingBlock) {
        return self.textFieldShouldEndEditingBlock(textField);
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textFieldDidEndEditingBlock) {
        self.textFieldDidEndEditingBlock(textField);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textFieldShouldReturnBlock) {
        return self.textFieldShouldReturnBlock(textField);
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textFieldShouldChangeCharactersInRangeReplacementStringBlock) {
        return self.textFieldShouldChangeCharactersInRangeReplacementStringBlock(textField, range, string);
    }
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0); // if implemented, called in place of textFieldDidEndEditing:
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
//
//- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//}


@end
