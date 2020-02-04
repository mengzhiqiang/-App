//
//  LMHMessageCell.h
//  BaseProject
//
//  Created by libj on 2019/9/17.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LMHMessageModel;
@interface LMHMessageCell : UITableViewCell

@property (nonatomic, strong) LMHMessageModel *model;

@end

NS_ASSUME_NONNULL_END
