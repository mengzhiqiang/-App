//
//  CustomShadowView.m
//  ZCBus
//
//  Created by zhiqiang meng on 1/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "CustomShadowView.h"

@interface CustomShadowView()

@end

@implementation CustomShadowView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 2);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 2.0;
    self.layer.cornerRadius = 9.0;
    self.clipsToBounds = NO;
}



@end
