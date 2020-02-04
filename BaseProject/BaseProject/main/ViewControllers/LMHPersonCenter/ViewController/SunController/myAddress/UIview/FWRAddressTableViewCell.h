//
//  FWRAddressTableViewCell.h
//  FindWorker
//
//  Created by zhiqiang meng on 18/7/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FWRAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrssNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *repaceLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIImageView *pushTagImageView;

@property (strong, nonatomic) LMHAddressModel *addressModel;

@property (copy, nonatomic)  void (^backEditAddress)(void);

@end

NS_ASSUME_NONNULL_END
