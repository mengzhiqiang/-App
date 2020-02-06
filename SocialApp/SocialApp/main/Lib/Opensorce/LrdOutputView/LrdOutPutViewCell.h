//
//  LrdOutPutViewCell.h
//  ZJDL
//
//  Created by lonkyle on 17/1/7.
//  Copyright © 2017年 lonkyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoOutputView.h"
#import "LrdOutputView.h"
@interface LrdOutPutViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (nonatomic,strong) TwoLrdCellModel  *twoModel;

@property (nonatomic,strong) LrdCellModel *LrdCellModel;


@end
