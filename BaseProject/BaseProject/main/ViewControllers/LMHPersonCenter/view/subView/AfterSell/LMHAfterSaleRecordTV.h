//
//  LMHAfterSaleRecordTV.h
//  BaseProject
//
//  Created by wfg on 2019/9/5.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMHAfterSaleRecordTV : UITableView

@property(nonatomic, strong)NSMutableArray <LMHOrderListModel*> * orderArray;

@property(nonatomic, assign)BOOL  IsRequest;
@property (nonatomic, assign) NSInteger page;

@property(nonatomic, copy)void (^relaodDataWithIndex) (NSInteger index);


@end

@interface LMHEmptyNoticeView : UIView

@end

NS_ASSUME_NONNULL_END

