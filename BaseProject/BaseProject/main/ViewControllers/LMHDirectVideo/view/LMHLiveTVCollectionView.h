//
//  LMHLiveTVCollectionView.h
//  BaseProject
//
//  Created by libj on 2019/9/23.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMHLiveTVCollectionView : UICollectionViewController


@property(nonatomic ,strong) NSString  *wordKey;

-(void)getShortVideoList:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
