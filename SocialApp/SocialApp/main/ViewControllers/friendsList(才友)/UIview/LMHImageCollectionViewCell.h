//
//  LMHImageCollectionViewCell.h
//  BaseProject
//
//  Created by zhiqiang meng on 21/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
