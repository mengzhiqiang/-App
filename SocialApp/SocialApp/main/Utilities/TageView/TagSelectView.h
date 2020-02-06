//
//  TagSelectView.h
//  BikeUser
//
//  Created by libj on 2019/11/7.
//  Copyright © 2019 gwp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TagSelectViewType) {
    TagSelectViewType_multiple = 0,
    TagSelectViewType_one = 1,
};

@protocol TagSelectViewDelegate <NSObject>

@optional

-(void)handleSelectTag:(NSString *) keyWord isSelect:(BOOL)isSelect;

@end

@interface TagSelectView : UIView

@property (nonatomic, weak) id <TagSelectViewDelegate>delegate;
@property (nonatomic, strong) NSArray * arr;
@property (nonatomic, strong) NSMutableArray *viewsArray;

/// 间隔
@property (nonatomic, assign) NSInteger space;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat leftAndRightMargin;
/// title 两边距离
@property (nonatomic, assign) CGFloat titleMargin;
/// 圆角大小
@property (nonatomic, assign) NSInteger cornerRadius;

@property (nonatomic, assign) TagSelectViewType selectType;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) UIImage *selectImage;

@end

NS_ASSUME_NONNULL_END
