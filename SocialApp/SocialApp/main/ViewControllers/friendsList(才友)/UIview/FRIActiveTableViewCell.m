//
//  FRIActiveTableViewCell.m
//  SocialApp
//
//  Created by zhiqiang meng on 14/11/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIActiveTableViewCell.h"
#import "LMHImageCollectionViewCell.h"
@interface FRIActiveTableViewCell()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@end

@implementation FRIActiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(FRIActiveModel *)model{
    _model = model;
    
    _contentLabel.text = model.content;
    _contentLabel.height = [UILabel cellHight:model.content];
    [self addSubview:self.imagScrollView];
    [_imagScrollView reloadData];
}

#pragma mark - LazyLoad
- (UICollectionView *)imagScrollView
{
    if (!_imagScrollView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _imagScrollView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _imagScrollView.delegate = self;
        _imagScrollView.dataSource = self;
        _imagScrollView.frame = CGRectMake(0, 105, SCREEN_WIDTH, 115*RATIO_IPHONE6);
        _imagScrollView.showsVerticalScrollIndicator = NO;        //注册
        _imagScrollView.scrollEnabled = NO;
        [_imagScrollView registerNib:[UINib nibWithNibName:NSStringFromClass([LMHImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"LMHImageCollectionViewCell"];
        _imagScrollView.backgroundColor = White_Color;
    }
    _imagScrollView.top = _contentLabel.bottom+5;
    if (_model.zanCount.length) {
        _imagScrollView.height =  115*RATIO_IPHONE6*2 ;
    }
    return _imagScrollView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_model.zanCount.length) {
        return 5;
    }
    return 3;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LMHImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMHImageCollectionViewCell" forIndexPath:indexPath];
    cell = cell;

    cell .contentLabel.hidden = YES;
    cell.imageView.hidden = NO;
    [cell.imageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:DefluatPic]];
    cell.imageView.backgroundColor = [self randomColor];
    
    return cell;
}
- (UIColor*)randomColor {
    NSInteger aRedValue =arc4random() %255;
    NSInteger aGreenValue =arc4random() %255;
    NSInteger aBlueValue =arc4random() %255;
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        return CGSizeMake(107*RATIO_IPHONE6, 107*RATIO_IPHONE6);
    }
    return CGSizeZero;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 0) {
        layoutAttributes.size = CGSizeMake(0,0);
    }
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return CGSizeMake(0, 5); //
    }
    
    return CGSizeZero;
}

////代理方法, 控制每个段的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section==0) {
        return UIEdgeInsetsMake(5, 15, 0, 15);
    }
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return  10.0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return  10*RATIO_IPHONE6;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
        NSLog(@"====");
        NSMutableArray *bigImageArray = [NSMutableArray array];
        
//        for (int i = 0; i < _goodsPicArray.count; i++) {
//            NSDictionary* diction = _goodsPicArray[i];
//            [bigImageArray addObject:diction[@"url"]];
//        }
//
//        QWNViewController *vc = [[QWNViewController alloc]init];
//        vc.imagesArr = bigImageArray;
//        vc.index = [NSString stringWithFormat:@"%d",indexPath.row];
//        [[UIViewController getCurrentController] presentViewController:vc animated:YES completion:nil];

}

- (IBAction)clickActive:(UIButton *)sender {
    
    if (sender.tag==10) {
        NSLog(@"==pg==");
    }else  if (sender.tag==11) {
        NSLog(@"==zan==");
    }
    
}

@end
