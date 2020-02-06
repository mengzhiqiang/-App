//
//  UIButton+Inset.h
//  ZCBusManage
//
//  Created by wfg on 2019/9/2.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Inset)
- (void)centerTitleAndImage;
- (void)centerTitleAndImageOffset:(CGFloat)offset;

- (void)leftTitleAndRightImage:(CGFloat)offset;
@end

NS_ASSUME_NONNULL_END
