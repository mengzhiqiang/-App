//
//  CustomActionSheetView.h
//  ZCBus
//
//  Created by zhiqiang meng on 5/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomActionSheetView : UIView
@property(nonatomic ,strong) ClickBlock backClick;

-(void)shareView ;

@end

NS_ASSUME_NONNULL_END
