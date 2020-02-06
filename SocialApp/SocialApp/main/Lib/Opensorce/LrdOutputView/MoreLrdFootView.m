//
//  MoreLrdFootView.m
//  BikeUser
//
//  Created by 高伟鹏 on 2019/8/28.
//  Copyright © 2019 gwp. All rights reserved.
//

#import "MoreLrdFootView.h"
#import "UIView+AZGradient.h"

@implementation MoreLrdFootView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
 
}
- (void)awakeFromNib{
    [super awakeFromNib];
 
    
    [self.okButton az_setGradientBackgroundWithColors:@[[UIColor colorWithRed:0/255.0 green:190/255.0 blue:231/255.0 alpha:1.0],[UIColor colorWithRed:0/255.0 green:162/255.0 blue:231/255.0 alpha:1.0]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];

}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
       
    }
    return self;
}
@end
