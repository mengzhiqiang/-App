//
//  LMHInviteFriendCell.h
//  BaseProject
//
//  Created by wfg on 2019/9/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHInviteFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *codeLbl;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@property (nonatomic, strong) void(^selectBlock)(void);
@end
NS_ASSUME_NONNULL_END
