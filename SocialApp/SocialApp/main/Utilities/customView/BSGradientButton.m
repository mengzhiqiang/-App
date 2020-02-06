//
//  BSGradientButton.m
//  BikeStore
//
//  Created by wfg on 2019/11/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "BSGradientButton.h"

@implementation BSGradientButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGradient];
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    BSGradientButton *btn = [super buttonWithType:buttonType];
    [btn addGradient];
    return btn;
}

- (void)addGradient {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.layer.cornerRadius = 25;
    self.layer.masksToBounds = YES;
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH-80, 50);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexValue:0x1A9DC7].CGColor,(__bridge id)[UIColor colorWithHexValue:0xA1F3E4].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@0,@1];
    [self.layer insertSublayer:gradientLayer atIndex:0];
}
@end
