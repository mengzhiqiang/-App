//
//  LMHVideoCollectionView.h
//  BaseProject
//
//  Created by wfg on 2019/9/7.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHVideoCollectionView : UICollectionView

@property(nonatomic ,strong) NSString  *wordKey;

-(void)getShortVideoList:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
