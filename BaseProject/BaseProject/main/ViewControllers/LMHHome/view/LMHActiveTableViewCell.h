//
//  LMHActiveTableViewCell.h
//  BaseProject
//
//  Created by zhiqiang meng on 8/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHBandModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMHActiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ActiveImageView;
@property (weak, nonatomic) IBOutlet UILabel *ActiveNameLabel;

-(void)loadUIWithData:(LMHBandModel*)model ;
@end

NS_ASSUME_NONNULL_END
