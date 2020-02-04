//
//  JFNormalBubbleView.m
//  ZCBus
//
//  Created by wfg on 2019/8/27.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "JFNormalBubbleView.h"
#import "JFBubbleItem.h"

@interface JFNormalBubbleItem : JFBubbleItem

@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *hightlightTextColor;
@property (nonatomic, strong) UIColor *normalBgColor;
@property (nonatomic, strong) UIColor *highlightBgColor;

@end

#pragma mark -
@implementation JFNormalBubbleItem

-(instancetype)initWithReuseIdentifier:(NSString *)identifier{
    self = [super initWithReuseIdentifier:identifier];
    if (self) {
//        CGFloat normalRGB = 51/255.0;
        self.normalTextColor = Main_title_Color;
        self.hightlightTextColor = Main_Color;
        self.normalBgColor = [UIColor colorWithHexValue:0xF9F9FB];
        self.textLabel.textColor = self.normalTextColor;
//        self.layer.borderColor = self.normalTextColor.CGColor;
        self.backgroundColor = self.normalBgColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.layer.borderWidth = 0;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(self.textPadding, 0, self.frame.size.width - self.textPadding*2, self.frame.size.height);
}

//-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        self.textLabel.textColor = self.hightlightTextColor;
//        self.layer.borderColor = self.hightlightTextColor.CGColor;
//        self.backgroundColor = self.highlightBgColor;
//    }
//    else{
//        self.textLabel.textColor = self.normalTextColor;
//        self.layer.borderColor = self.normalTextColor.CGColor;
//        self.backgroundColor = self.normalBgColor;
//    }
//}

@end


#pragma mark - Class JFSelectBubbleView
#pragma mark -

@interface JFNormalBubbleView ()<JFBuddleViewDelegate, JFBuddleViewDataSource>

@end

#pragma mark -

@implementation JFNormalBubbleView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bubbleDataSource = self;
        self.dataArray = [NSArray new];
        self.allowsMultipleSelection = NO;
        self.itemSpace = 16;
    }
    return self;
}

-(void)setDataArray:(NSArray<NSString *> *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

#pragma mark - Bubble View Data Source
-(NSInteger)numberOfItemsInBubbleView:(JFBubbleView *)bubbleView{
    return self.dataArray.count;
}

-(JFBubbleItem *)bubbleView:(JFBubbleView *)bubbleView itemForIndex:(NSInteger)index{
    NSString *editReuseIdentifier = @"editBubbleItem";
    JFNormalBubbleItem *item = [bubbleView dequeueReuseItemWithIdentifier:editReuseIdentifier];
    if (item == nil) {
        item = [[JFNormalBubbleItem alloc] initWithReuseIdentifier:editReuseIdentifier];
    }
    item.textLabel.text = [self.dataArray objectAtIndex:index];
    return item;
}


@end
