    //
//  LMHMessageHeaderView.h
//  BaseProject
//
//  Created by libj on 2019/9/17.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHMessageHeaderView : UIView

@property (nonatomic, copy) void(^selectIndexBlock)(NSInteger index);
@property (nonatomic, assign) BOOL isShowSystemDot;
@property (nonatomic, assign) BOOL isShowdealDot;
@end


@interface LMHMessageView : UIButton

@property (nonatomic, assign) BOOL isShowDot;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIView *redDotView;


@end

NS_ASSUME_NONNULL_END
