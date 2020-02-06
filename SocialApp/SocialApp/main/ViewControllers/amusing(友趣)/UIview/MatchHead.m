//
//  MatchHead.m
//  BikeUser
//
//  Created by 高伟鹏 on 2019/8/24.
//  Copyright © 2019 gwp. All rights reserved.
//

#import "MatchHead.h"
#import "SDCycleScrollView.h"
//#import "BikeGameBanner.h"
//#import "GamesDetailViewController.h"
@interface MatchHead ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *sdcyclesView;

@end

@implementation MatchHead

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBaseAttribute];
        [self setupSubviews];
        [self setupSubviewsLayout];
    }
    return self;
}

- (void) setBaseAttribute {
    
}

- (void) setupSubviews {
    [self addSubview:self.sdcyclesView];

}

- (void) setupSubviewsLayout {

}

- (void)setIsBanner:(BOOL)isBanner {
    _isBanner = isBanner;
    self.sdcyclesView.hidden = isBanner;
    [self.sdcyclesView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(0);
    }];
}


- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    NSMutableArray *array = [NSMutableArray array];
//    for (BikeGameBanner *model in imagesArray) {
//        [array addObject:model.image];
//    }
//
    self.sdcyclesView.imageURLStringsGroup = array;
}


/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    BikeGameBanner *model = self.imagesArray[index];
//    GamesDetailViewController *vc = [GamesDetailViewController new];
//    vc.gamesId = FORMAT(@"%zd",model.cid);
//    [self.getCurrentViewController.navigationController pushViewController:vc animated:YES];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

#pragma mark 懒加载
-(SDCycleScrollView *)sdcyclesView{
    if(!_sdcyclesView){
        _sdcyclesView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, (SCREEN_WIDTH-30)*(10/16.0)) delegate:self placeholderImage:[UIImage new]];
//        _sdcyclesView.zoomType = NO;  // 是否使用缩放效果
        _sdcyclesView.showPageControl = NO;
        //        _sdcyclesView.placeholderImage = image_plachholder_default;
        _sdcyclesView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _sdcyclesView.pageControlBottomOffset = -25;
        _sdcyclesView.autoScrollTimeInterval = 3;
        _sdcyclesView.pageDotImage = UIImageName(@"main_icon_lunbo_default");
        _sdcyclesView.currentPageDotImage = UIImageName(@"lbdian");
        _sdcyclesView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _sdcyclesView.pageControlDotSize = CGSizeMake(CGFloatBasedI375(14), CGFloatBasedI375(7));  // pageControl小点的大小
//        _sdcyclesView.localizationImageNamesGroup = @[@"banner_sy", @"banner_sy", @"banner_sy", @"banner_sy"];  // 本地图片
        _sdcyclesView.layer.cornerRadius = 20;
        _sdcyclesView.clipsToBounds = YES;
        _sdcyclesView.delegate = self;
    }
    return _sdcyclesView;
}


@end



@interface MatchSectionHeaderView ()

@property (nonatomic, strong) MatchHeadItem *areaItem;
@property (nonatomic, strong) MatchHeadItem *sortItem;
@property (nonatomic, strong) MatchHeadItem *threeItem;

@end

@implementation MatchSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBaseAttribute];
        [self setupSubviews];
        [self setupSubviewsLayout];
    }
    return self;
}

- (void) setBaseAttribute {
    self.backgroundColor = White_Color;
}

- (void) setupSubviews {
    [self addSubview:self.areaItem];
    [self addSubview:self.sortItem];
    [self addSubview:self.threeItem];

}

- (void) setupSubviewsLayout {

    CGFloat  width = SCREEN_WIDTH/3 ;
    [self.areaItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.equalTo(@(width));
        make.height.equalTo(@44);
    }];
    
    [self.sortItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(width);
        make.width.equalTo(@(width));
        make.height.equalTo(@44);
    }];
    
    [self.threeItem mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.offset(0);
          make.left.offset((width*2));
          make.width.equalTo(@(width));
          make.height.equalTo(@44);
      }];
}

- (void)sortItemAction {
    if ([self.delegate respondsToSelector:@selector(selectTypeWithIndex:)]) {
        [self.delegate selectTypeWithIndex:1];
    }
}
- (void)areaItemAction:(UIButton*)sender {
    if ([self.delegate respondsToSelector:@selector(selectTypeWithIndex:)]) {
        [self.delegate selectTypeWithIndex:sender.tag-10];
    }
}
- (MatchHeadItem *)sortItem {
    if (!_sortItem) {
        _sortItem = [MatchHeadItem new];
        _sortItem.titleLabel.text = @"参与要求";
        _sortItem.button.tag = 10;
        [_sortItem.button addTarget:self action:@selector(areaItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortItem;
}
- (MatchHeadItem *)areaItem {
    if (!_areaItem) {
        _areaItem = [MatchHeadItem new];
        _areaItem.button.tag = 11;
        _areaItem.titleLabel.text = @"活动类型";
        [_areaItem.button addTarget:self action:@selector(areaItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _areaItem;
}

- (MatchHeadItem *)threeItem {
    if (!_threeItem) {
        _threeItem = [MatchHeadItem new];
        _threeItem.titleLabel.text = @"组团类型";
        _threeItem.button.tag = 12;
        [_threeItem.button addTarget:self action:@selector(areaItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _threeItem;
}

@end

@implementation MatchHeadItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBaseAttribute];
        [self setupSubviews];
        [self setupSubviewsLayout];
    }
    return self;
}

- (void) setBaseAttribute {
    
}

- (void) setupSubviews {
    [self addSubview:self.button];
    [self.button addSubview:self.titleLabel];
    [self.button addSubview:self.iconImage];
}

- (void) setupSubviewsLayout {
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.button);
    }];
}


#pragma mark 懒加载

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
    }
    return _button;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [UIImageView new];
        _iconImage.image = UIImageName(@"icon_xiala");
    }
    return _iconImage;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"参与要求";
        _titleLabel.font = FontSize(15);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
