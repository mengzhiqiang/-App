//
//  HRAdView.m
//  AutoAdLabelScroll
//
//  Created by 陈华荣 on 16/4/6.
//  Copyright © 2016年 陈华荣. All rights reserved.
//

#import "HRAdView.h"
#import "MyAttributedStringBuilder.h"
#define ViewWidth  self.bounds.size.width
#define ViewHeight  self.bounds.size.height

@interface HRAdView ()
/**
 *  文字广告条前面的图标
 */
@property (nonatomic, strong) UIImageView *headImageView;
/**
 *  轮流显示的两个Label
 */
@property (nonatomic, strong) UILabel *oneLabel;
@property (nonatomic, strong) UILabel *twoLabel;

/**
 *  计时器
 */

@property (nonatomic, strong) NSTimer *timer;




@end

@implementation HRAdView
{
    NSUInteger index;
    CGFloat margin;
    BOOL isBegin;
}


- (instancetype)initWithTitles:(NSArray *)titles{
    
    self = [super init];
    
    if (self) {
        margin = 0;
        self.clipsToBounds = YES;

        
       
        //对部分文字设置颜色
        for (NSString *tmpStr  in titles) {
            NSRange range;
            range = [tmpStr rangeOfString:@"，"];
            NSRange rangeA;
            rangeA = NSMakeRange(tmpStr.length - 12, 1);
            NSRange rangeB;
            rangeB =NSMakeRange(tmpStr.length - 1, 1);
            NSRange oneRange = {range.location+1,rangeA.location - range.location-1};
         
             NSRange twoRange ={rangeA.location,rangeB.location - rangeA.location+1};
            MyAttributedStringBuilder *builder = [[MyAttributedStringBuilder alloc] initWithString:tmpStr];
            
            builder.allRange.textColor = Main_title_Color ;

//            [builder range:oneRange].textColor = WPBlueColor;
//            [builder range:twoRange].textColor = WPGrayColor;

//            NSLog(@"%@",builder.commit);
            
            [self.adTitles addObject:builder.commit];
        }
        
        
        self.headImg = nil;
        self.labelFont = [UIFont systemFontOfSize:16];
//        self.color = [UIColor blackColor];
        self.time = 2.0f;
        self.textAlignment = NSTextAlignmentLeft;
        self.isHaveTouchEvent = NO;
        self.edgeInsets = UIEdgeInsetsZero;
        index = 0;
      
        if (!_headImageView) {
            _headImageView = [UIImageView new];
        }
        
        if (!_oneLabel) {
            _oneLabel = [UILabel new];
            if (self.adTitles.count > 0) {
                _oneLabel.attributedText = self.adTitles[index];
            }
            _oneLabel.font = self.labelFont;
            _oneLabel.textAlignment = self.textAlignment;
            _oneLabel.backgroundColor = [UIColor whiteColor];
//            _oneLabel.textColor = self.color;
            [self addSubview:_oneLabel];
        }
        
        if (!_twoLabel) {
            _twoLabel = [UILabel new];
            _twoLabel.backgroundColor = [UIColor whiteColor];
            _twoLabel.font = self.labelFont;
//            _twoLabel.textColor = self.color;
            _twoLabel.textAlignment = self.textAlignment;
            [self addSubview:_twoLabel];
        }
    }
    return self;
}

- (void)timeRepeat{
    if (self.adTitles.count <= 1) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    __block UILabel *currentLabel;
    __block UILabel *hidenLabel;
    __weak typeof(self) weakself = self;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *label = obj;
            NSAttributedString * string = weakself.adTitles[index];
            if ([label.attributedText isEqualToAttributedString:string]) {
                currentLabel = label;
            }else{
                hidenLabel = label;
            }
        }
    }];
    
    if (index != self.adTitles.count-1) {
        index++;
    }else{
        index = 0;
    }
    
    hidenLabel.attributedText = self.adTitles[index];
    [UIView animateWithDuration:1 animations:^{
        hidenLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
        currentLabel.frame = CGRectMake(margin, -ViewHeight, ViewWidth, ViewHeight);
    } completion:^(BOOL finished){
        currentLabel.frame = CGRectMake(margin, ViewHeight, ViewWidth, ViewHeight);
    }];
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.headImg) {
        [self addSubview:self.headImageView];
        
        self.headImageView.frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top, ViewHeight-self.edgeInsets.top-self.edgeInsets.bottom, ViewHeight-self.edgeInsets.top-self.edgeInsets.bottom);
        margin = CGRectGetMaxX(self.headImageView.frame) +10;
    }else{
        
        if (self.headImageView) {
            [self.headImageView removeFromSuperview];
            self.headImageView = nil;
        }
        margin = 10;
    }
    
    self.oneLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
    self.twoLabel.frame = CGRectMake(margin, ViewHeight, ViewWidth, ViewHeight);
}


- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(timeRepeat) userInfo:self repeats:YES];
    }
    return _timer;
}


- (void)beginScroll{
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)closeScroll{
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets{
    _edgeInsets = edgeInsets;
}


- (void)setIsHaveTouchEvent:(BOOL)isHaveTouchEvent{
    if (isHaveTouchEvent) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEvent:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }else{
        self.userInteractionEnabled = NO;

    }
}

- (void)setTime:(NSTimeInterval)time{
    _time = time;
    if (self.timer.isValid) {
        [self.timer isValid];
        self.timer = nil;
    }
}


- (void)setHeadImg:(UIImage *)headImg{
    _headImg = headImg;
    
    self.headImageView.image = headImg;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    
    self.oneLabel.textAlignment = _textAlignment;
    self.twoLabel.textAlignment = _textAlignment;
}

//- (void)setColor:(UIColor *)color{
//    _color = color;
//    self.oneLabel.textColor = _color;
//    self.twoLabel.textColor = _color;
//}

- (void)setLabelFont:(UIFont *)labelFont{
    _labelFont = labelFont;
    self.oneLabel.font = _labelFont;
    self.twoLabel.font = _labelFont;
}


- (void)clickEvent:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    
    
    [self.adTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (index % 2 == 0 && [self.oneLabel.attributedText isEqualToAttributedString:obj]) {
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }else if(index % 2 != 0 && [self.twoLabel.attributedText isEqualToAttributedString:obj]){
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }
    }];
    
}


@end
