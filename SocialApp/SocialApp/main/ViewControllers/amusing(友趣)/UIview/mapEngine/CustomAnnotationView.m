//
//  CustomAnnotationView.m
//  FindWorker
//
//  Created by zhiqiang meng on 5/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#define kCalloutWidth       70.0
#define kCalloutHeight      40

#import "CustomAnnotationView.h"

@interface CustomAnnotationView ()


@end

@implementation CustomAnnotationView

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
//    return ;
    NSLog(@"=====");
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            UIButton* _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _selectButton.frame = CGRectMake(0, 0, kCalloutWidth, 20);
            [_selectButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
            //            _selectButton.backgroundColor = [UIColor redColor];
            [self.calloutView addSubview:_selectButton];
        }
        
        [self addSubview:self.calloutView];

    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}
-(void)clickButton{
    NSLog(@"=======434");
    if (_backSelect) {
        _backSelect();
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside /*&& self.selected*/)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kCalloutWidth, kCalloutHeight);
//        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
