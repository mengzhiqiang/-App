//
//  TagView.h
//  waimai
//
//  Created by jochi on 2018/7/26.
//  Copyright © 2018年 jochi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectType) {
    selectType_multiple = 0,
    selectType_one = 1,
};

@protocol TagViewDelegate <NSObject>

@optional

-(void)handleSelectTag:(NSString *) keyWord isSelect:(BOOL)isSelect;
-(void)handleSelectTagRow:(NSInteger) row;

@end
@interface TagView : UIView
@property (nonatomic, weak) id <TagViewDelegate>delegate;
@property (nonatomic, strong) NSArray * arr;
@property (nonatomic, strong) NSMutableArray *viewsArray;

/// 间隔
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) NSInteger space;
@property (nonatomic, assign) NSInteger marginY;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat leftAndRightMargin;
/// title 两边距离  
@property (nonatomic, assign) CGFloat titleMargin;
/// 圆角大小
@property (nonatomic, assign) NSInteger cornerRadius;

@property (nonatomic, assign) SelectType selectType;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) UIImage *selectImage;
/// 默认title 颜色
@property (nonatomic, strong) UIColor *defaultTitleColor;
/// 选中title 颜色
@property (nonatomic, strong) UIColor *selectTitleColor;
/// 默认背景颜色
@property (nonatomic, strong) UIColor *defaultBgColor;
/// 选中背景颜色
@property (nonatomic, strong) UIColor *selectBgColor;


@end
