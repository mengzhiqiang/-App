//
//  LMHForwardingPriceView.m
//  BaseProject
//
//  Created by wfg on 2019/9/3.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHForwardingPriceView.h"

@interface LMHForwardingPriceView ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *priceBtns;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (assign, nonatomic) NSInteger selectIndex;

@end
@implementation LMHForwardingPriceView


- (IBAction)priceAction:(UIButton *)sender {
    for (UIButton *btn in self.priceBtns) {
        [btn setTitleColor:Main_title_Color forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        btn.backgroundColor = Main_BG_Color;
    }
    [sender setTitleColor:Main_Color forState:UIControlStateNormal];
    sender.layer.borderColor = Main_Color.CGColor;
    sender.layer.borderWidth = 1;
    sender.backgroundColor = [UIColor clearColor];
    _selectIndex = sender.tag;
}

- (IBAction)confirmAction:(UIButton *)sender {
    NSString *price = _textField.text;
    if (_selectIndex!=0) {
        if (_selectIndex==10) {
            price = @"0";
        } else if (_selectIndex==11) {
            price = @"10";
        } else if (_selectIndex==12) {
            price = @"20";
        }
    }
    if ([price floatValue]<1) {
        price = @"0";
    }
  
    if (_backload) {
        _backload(price);
    }else{
        if (_backchange) {
            _backchange();
        }
        [[NSUserDefaults standardUserDefaults] setObject:price forKey:kGoodShareAddPirceKey];
          [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self removeFromSuperview];
    
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)changeTextf:(UITextField *)sender {
    NSLog(@"===%@",sender.text);
    for (UIButton *btn in self.priceBtns) {
        [btn setTitleColor:Main_title_Color forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        btn.backgroundColor = Main_BG_Color;
    }
    
    _selectIndex==0;
}


@end
