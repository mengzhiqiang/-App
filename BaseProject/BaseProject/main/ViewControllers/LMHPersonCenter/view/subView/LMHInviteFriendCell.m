//
//  LMHInviteFriendCell.m
//  BaseProject
//
//  Created by wfg on 2019/9/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHInviteFriendCell.h"

@implementation LMHInviteFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)inviteAction:(UIButton *)sender {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

@end
