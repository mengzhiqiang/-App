//
//  MLMProgressView.m
//  MLMProgressView
//
//  Created by my on 16/8/4.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "MLMProgressView.h"

@implementation MLMProgressView

//芝麻信用
- (UIView *)sesameCreditType {
    CGFloat startAngle = 150;
    CGFloat endAngle = 390;
    
   
    
    
    //刻度
    _calibra = [[MLMCalibrationView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) startAngle:startAngle endAngle:endAngle];
    _calibra.textType = MLMCalibrationViewTextRotate;
    _calibra.smallScaleNum = 5;
    _calibra.majorScaleNum = 10;
    _calibra.majorScaleLength = 14;
    _calibra.smallScaleLength = 8;
    _calibra.smallScaleColor = [UIColor colorWithWhite:1 alpha:.6];
//    _calibra.bgColor = [UIColor colorWithWhite:1 alpha:.3];
    _calibra.customArray =  @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    _calibra.edgeSpace = 15;
    _calibra.center = self.center;
    [_calibra drawCalibration];
    [self addSubview:_calibra];
    
    
    //进度
    _circle = [[MLMCircleView alloc] initWithFrame:CGRectMake(0, 0, _calibra.freeWidth-10, _calibra.freeWidth -10) startAngle:startAngle endAngle:endAngle];
    _circle.center = self.center;
    _circle.bottomWidth = 2;
    _circle.progressWidth = 2;
    _circle.fillColor = [UIColor colorWithWhite:1 alpha:.6];
    _circle.bgColor = [UIColor colorWithWhite:1 alpha:.3];
    _circle.dotDiameter = 42;
    _circle.edgespace = 10;
    _circle.dotImage = [UIImage imageNamed:@"tt"];
//    _circle.dotDiameter = 10;
    [_circle drawProgress];
    [self addSubview:_circle];
    
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _calibra.freeWidth, _calibra.freeWidth)];
//    label.center = self.center;
//    label.textColor = [UIColor colorWithWhite:1 alpha:.8];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:13];
//    label.text = @"芝麻信用";
//    [self addSubview:label];
    return self;
}

//速度表盘
- (UIView *)speedDialType {
    CGFloat startAngle = 180;
    CGFloat endAngle = 360;
    //刻度
    _calibra = [[MLMCalibrationView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) startAngle:startAngle endAngle:endAngle];
    _calibra.textType = MLMCalibrationViewTextRotate;
    _calibra.maxValue = 1000000;
    _calibra.smallScaleNum = 10;
    _calibra.majorScaleNum = 10;
    _calibra.majorScaleLength = 16;
    _calibra.smallScaleLength = 10;
    _calibra.edgeSpace = 5;
    _calibra.bgColor = [UIColor colorWithWhite:1 alpha:.3];
    _calibra.center = self.center;
    [_calibra drawCalibration];
    [self addSubview:_calibra];
    
    //进度
    _circle = [[MLMCircleView alloc] initWithFrame:CGRectMake(0, 0, _calibra.freeWidth, _calibra.freeWidth) startAngle:startAngle endAngle:endAngle];
    _circle.center = self.center;
    _circle.bottomWidth = 5;
    _circle.progressWidth = 40;
    _circle.fillColor = [UIColor colorWithWhite:1 alpha:.3];
    _circle.bgColor = [UIColor yellowColor];
    _circle.dotDiameter = 8;
    _circle.edgespace = - _calibra.scaleFont.lineHeight;
    _circle.dotImage = nil;
    _circle.capRound = NO;
    [_circle bottomNearProgress:YES];
    [_circle drawProgress];
    [self addSubview:_circle];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _circle.freeWidth, _circle.freeWidth)];
    label.center = self.center;
    label.textColor = [UIColor colorWithWhite:1 alpha:.8];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"速度表盘";
    [self addSubview:label];
    return self;
}


@end
