//
//  DCMyCenterHeaderView.h
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/12.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomShadowView.h"
#import "LMHPersonCenterModel.h"
@interface DCMyCenterHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *myIconButton;

/* 头像点击回调 */
@property (nonatomic, copy) dispatch_block_t headClickBlock;

/** 查看会员点击 */
@property (nonatomic, copy) void(^seeVipClickBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *useNameLabel;

@property (weak, nonatomic) IBOutlet CustomShadowView *shadowVipView;
@property (weak, nonatomic) IBOutlet UIView *shadowBGView;

@property (weak, nonatomic) IBOutlet UIView *vipView;
@property (strong, nonatomic) IBOutlet UIButton *vipButton;
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *vieSumLabel;


@property (strong, nonatomic) LMHPersonCenterModel *model;

@end
