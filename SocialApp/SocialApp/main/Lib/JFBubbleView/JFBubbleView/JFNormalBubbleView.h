//
//  JFNormalBubbleView.h
//  ZCBus
//
//  Created by wfg on 2019/8/27.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "JFBubbleView.h"
#import "JFBubbleItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface JFNormalBubbleView : JFBubbleView
/*!
 * @note setDataArray 方法会触发 `reloadData` 方法
 * @note 如果是 addObject 或是 removeObject，均需手动 `reloadData`
 */
@property (nonatomic, strong) NSArray<NSString *> *dataArray;
@end

NS_ASSUME_NONNULL_END
