//
//  DCCenterItemCell.h
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/12.
//Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHPersonCenterModel.h"
@interface DCCenterItemCell : UITableViewCell

@property(copy,nonatomic) void (^backIndex)(int index);

@property(copy,nonatomic) NSArray *orderArray ;

@property(assign,nonatomic) NSInteger  style ;

-(void)loadNewUIWithStyle:(NSInteger)style andData:(LMHPersonCenterModel*)model ;
@end
