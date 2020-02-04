//
//  CustomLowShadowView.h
//  BaseProject
//
//  Created by zhiqiang meng on 30/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomShadowView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CustomLowShadowView : UIView


/** 点击回调 */
@property (nonatomic, copy) dispatch_block_t buyingClickBlock;

/** 底部阴影 */
@property (nonatomic, strong) CustomShadowView * shadowView;
/**  */
@property (nonatomic, strong) UILabel * titleLabel;
/**  */
@property (nonatomic, strong) UIButton * submitButton;

@end

NS_ASSUME_NONNULL_END
