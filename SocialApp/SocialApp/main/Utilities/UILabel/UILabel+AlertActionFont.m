//
//  UILabel+AlertActionFont.m
//  Wisdomfamily
//
//  Created by libj on 2019/5/17.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "UILabel+AlertActionFont.h"

@implementation UILabel (AlertActionFont)

- (void)setAppearanceFont:(UIFont *)appearanceFont
{
    if(appearanceFont)
    {
        [self setFont:appearanceFont];
    }
}

- (UIFont *)appearanceFont
{
    return self.font;
}
@end
