//
//  UIButton+Inset.m
//  ZCBusManage
//
//  Created by wfg on 2019/9/2.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "UIButton+Inset.h"

@implementation UIButton (Inset)

- (void)centerTitleAndImage {
    [self centerTitleAndImageOffset:4];
}

- (void)centerTitleAndImageOffset:(CGFloat)offset {
//    [self invalidateIntrinsicContentSize];
//    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -self.imageView.frame.size.width, -self.imageView.frame.size.height - offset, 0.0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -self.imageView.image.size.width, -self.imageView.image.size.height - offset, 0.0);

    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height - offset, 0.0, 0.0, -self.titleLabel.intrinsicContentSize.width);
}


- (void)leftTitleAndRightImage:(CGFloat)offset {

    //    [self invalidateIntrinsicContentSize];
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -self.imageView.image.size.width-offset, 0.0, self.imageView.image.size.width+offset);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, self.titleLabel.intrinsicContentSize.width+offset, 0.0, -self.titleLabel.intrinsicContentSize.width-offset);
}
@end
