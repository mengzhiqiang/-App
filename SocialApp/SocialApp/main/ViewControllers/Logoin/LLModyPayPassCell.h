//
//  LLModyPayPassCell.h
//  LLTalentGang
//
//  Created by lijun L on 2019/4/29.
//  Copyright © 2019年 lijun L. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLModyPayPassCell : UITableViewCell
@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)NSString *placeholder;
@property (assign, nonatomic) NSInteger index;
@end

NS_ASSUME_NONNULL_END
