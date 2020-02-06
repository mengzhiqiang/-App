//
//  CustomAnnotationView.h
//  FindWorker
//
//  Created by zhiqiang meng on 5/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) CustomCalloutView *calloutView;

@property (nonatomic, copy)  void (^backSelect)(void);

@end

NS_ASSUME_NONNULL_END
