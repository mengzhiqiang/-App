//
//  LMHShareGoodsView.h
//  BaseProject
//
//  Created by zhiqiang meng on 16/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHGoodDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMHShareGoodsView : UIView
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIView *goodsImageView;
@property (weak, nonatomic) IBOutlet UIButton *mainImageView;
@property (weak, nonatomic) IBOutlet UIButton *singleImageView;
@property (weak, nonatomic) IBOutlet UIButton *fourImageView;
@property (weak, nonatomic) IBOutlet UIButton *sizeImageView;
@property (weak, nonatomic) IBOutlet UIButton *addPriceButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *hiddenButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectImagesButtons;

@property (copy, nonatomic)  void (^backSelect) (NSInteger index);
@property (strong, nonatomic)  NSArray <UIImage*>*shareImages;

-(void)shareimage:(LMHGoodDetailModel*)model;

/**
 更改价格重新合成
 */
-(void)loadChangePrice:(NSString*)price;
@end

NS_ASSUME_NONNULL_END
