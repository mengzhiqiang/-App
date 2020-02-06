//
//  MatchHead.h
//  BikeUser
//
//  Created by 高伟鹏 on 2019/8/24.
//  Copyright © 2019 gwp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MatchHeadDelegate <NSObject>

- (void) selectTypeWithIndex:(NSInteger)index;
@end

@interface MatchHead : UIView

@property (nonatomic, weak) id<MatchHeadDelegate> delegate;
@property (nonatomic, copy) NSArray *imagesArray;
@property (nonatomic, assign) BOOL isBanner;// 是否隐藏banner
@end



@protocol MatchSectionHeaderViewDelegate <NSObject>

- (void) selectTypeWithIndex:(NSInteger)index;
@end

@interface MatchSectionHeaderView : UIView
@property (nonatomic, weak) id<MatchSectionHeaderViewDelegate> delegate;

@end


@interface MatchHeadItem : UIView

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImage;

@end

NS_ASSUME_NONNULL_END
