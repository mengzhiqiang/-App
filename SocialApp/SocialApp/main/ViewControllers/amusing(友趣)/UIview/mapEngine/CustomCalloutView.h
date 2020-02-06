//
//  CustomCalloutView.h
//  FindWorker
//
//  Created by zhiqiang meng on 5/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomCalloutView : UIView

@property (nonatomic, strong) UIImage *image;   //图
@property (nonatomic, copy) NSString *title;   //名
@property (nonatomic, copy) NSString *subtitle; //地址
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
