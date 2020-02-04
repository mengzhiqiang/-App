//
//  LMHBandGoodsTableViewCell.m
//  BaseProject
//
//  Created by zhiqiang meng on 23/8/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHBandGoodsTableViewCell.h"
#import "LMHImageCollectionViewCell.h"
#import <ShareSDK/ShareSDK.h>
#import "UIAlertController+Simple.h"
#import "CustomActionSheetView.h"
#import "LMHShareGoodsView.h"
#import "LMHForwardingPriceView.h"
#import "QWNViewController.h"
#import "ShareSystemTools.h"
#import "WXApi.h"

@interface LMHBandGoodsTableViewCell()
{
    CustomActionSheetView * shareView;
}
@property(nonatomic,assign) NSInteger selectGuigeIndex;

@property(nonatomic,strong) LMHShareGoodsView* shareGoodView;

@property(nonatomic,strong) NSMutableArray* goodsPicArray;

@end


@implementation LMHBandGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_BGView draCirlywithColor:nil andRadius:8.0f];
//    _goodCountTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeCount:(UIButton *)sender {
    NSLog(@"==changeCount==%ld",(long)sender.tag);
    
    int  count = [_goodCountTextField.text intValue];
    if (sender.tag==10) {
        //减
        if (count<=1) {
            count = 1;
        }else{
            count--;
        }
    }else{
        count++;
    }
    _goodCountTextField.text = [NSString stringWithFormat:@"%d",count];
}

-(LMHShareGoodsView*)shareGoodView{
    WS(weakself);
    if (!_shareGoodView) {
        _shareGoodView = [[NSBundle mainBundle] loadNibNamed:@"LMHShareGoodsView" owner:self options:nil].firstObject;
        _shareGoodView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ;
        _shareGoodView.backSelect = ^(NSInteger index) {
            if (index==11) {
//                if ([WXApi isWXAppInstalled] && weakself.shareGoodView.shareImages.count==1 ) {
//                    [weakself showShareView];
//                }else{
                    [ weakself shareIOS ];
//                }
                
            }else{
                //转发价格
                LMHForwardingPriceView *view = [[NSBundle mainBundle] loadNibNamed:@"LMHForwardingPriceView" owner:weakself options:nil].firstObject;
                [[UIViewController getCurrentController].view addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo([UIViewController getCurrentController].view);
                }];
                view.backload = ^(NSString * _Nonnull price) {
                    [weakself.shareGoodView loadChangePrice:price];  //分享图片更新的价格
                };
               
            }
        };
    }
    _shareGoodView.hidden = NO;
    return _shareGoodView;
}

- (IBAction)controllerClick:(UIButton *)sender {
    NSLog(@"==controllerClick==%ld",(long)sender.tag);

    if (sender.tag==10) {
        //省赚
    }else  if (sender.tag==11){
      
        [[UIViewController getCurrentController].view addSubview:self.shareGoodView];
        if (_bandModel.brandName) {
            self.goodModel.brandName = _bandModel.brandName;
        }
        [self.shareGoodView shareimage:self.goodModel];
//        [self shareIOS ];
    }else{
        [self joinCar];
    }
     
}

-(void)showShareView{
    if (!shareView) {
        shareView =    [[CustomActionSheetView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    shareView.hidden = NO;
    shareView.backClick = ^(NSInteger buttonIndex) {
        shareView.hidden = YES;
        if (buttonIndex!=100) {
            [self shareAppWithIndex:buttonIndex];
        }
    };
    [[UIViewController getCurrentController].view addSubview:shareView];

}

-(void)shareAppWithIndex:(NSInteger)index{
    
    NSInteger shareStyle = SSDKPlatformTypeWechat;
    switch (index-10) {
        case 1:
             shareStyle = SSDKPlatformTypeQQ;
            break;
        case 2:
            shareStyle = SSDKPlatformTypeSinaWeibo;
            break;
        case 3:
            shareStyle = SSDKPlatformSubTypeWechatTimeline;
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:20];
    [dic SSDKSetupShareParamsByText:nil
                             images:_shareGoodView.shareImages
                                url:nil
                              title:nil
                               type:SSDKContentTypeImage];
    //
            [ShareSDK share:shareStyle
                 parameters:dic
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData,
                              SSDKContentEntity *contentEntity, NSError *error) {
                 switch (state) {
                     case SSDKResponseStateSuccess:
                         NSLog(@"成功");//成功
                         break;
                     case SSDKResponseStateFail:
                     {
                         NSLog(@"--%@",error.description);
                         //失败
                         break;
                     }
                     case SSDKResponseStateCancel:
                         NSLog(@"取消");
                         //取消
                         break;
    
                     default:
                         break;
                 }
             }];
 }

-(void)shareIOS{
    
    [ShareSystemTools shareWithData:_shareGoodView.shareImages];

}

-(void)setGoodModel:(LMHGoodDetailModel *)goodModel{
    _goodModel = goodModel;
    if (goodModel==nil) {
        return ;
    }
    [self goodPiclist];
    if (_goodModel.goodsPicList.count<1) {
        [self loadDataWithSearchData];
        return;
    }
//    [_headerImageView setImageWithURL:[goodModel. changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
//    _titleNameLabel.text = goodModel.brandName;
    NSDictionary*diction = goodModel.specifications.firstObject;

    _contentLabel.text = [NSString stringWithFormat:@"%@、%@-¥%@ \n%@" ,_goodModel.goodsSn,_goodModel.goodsName,diction[@"recommendedPrice"] ,_goodModel.goodsDesc];
    _contentLabel.height = [self cellHight:_contentLabel.text];
    _middleView.top = _contentLabel.bottom;
    NSString * sellPrice = [NSString stringWithFormat:@"¥%.2f",[diction[@"sellPrice"] floatValue]];
    NSString * marketPrice = [NSString stringWithFormat:@"¥%.2f",[diction[@"marketPrice"] floatValue]];

    NSString * string = [NSString stringWithFormat:@"%@  %@",sellPrice,marketPrice];
    _priceLabel.attributedText = [NSString  AttributedStringWithContent:string andTitle:sellPrice];
    [_freeCostButton setTitle:[NSString stringWithFormat:@" 省赚:¥%.f", [diction[@"recommendedPrice"] floatValue]-[diction[@"sellPrice"] floatValue]] forState:UIControlStateNormal];
    [self.shadowView addSubview:self.collectView];
    
    NSString * specificationName = [_goodModel.specifications.firstObject objectForKey:@"specificationName"];
    long  guigeCount = (_goodModel.specifications.count%[self cellWith:specificationName]==0? _goodModel.specifications.count/[self cellWith:specificationName]:_goodModel.specifications.count/[self cellWith:specificationName]+1);
    CGFloat height = (_goodModel.goodsPicList.count>6?3:2)*(95*RATIO_IPHONE6+5) + guigeCount*35+35+10;
    _collectView.top = _middleView.bottom+5;
    _collectView.height = height;
}

-(void)loadDataWithSearchData{
    _contentLabel.text = [NSString stringWithFormat:@"%@、%@-¥%@ \n%@" ,_goodModel.goodsSn,_goodModel.goodsName,_goodModel.recommendedPrice ,_goodModel.goodsDesc];
    _contentLabel.height = [self cellHight:_contentLabel.text];
    _middleView.top = _contentLabel.bottom;
    NSDictionary*diction = _goodModel.goodsSpecifications.firstObject;
    NSString * sellPrice = [NSString stringWithFormat:@"¥%.2f",_goodModel.sellPrice.floatValue];
    NSString * marketPrice = [NSString stringWithFormat:@"¥%.2f",_goodModel.marketPrice.floatValue];
    
    NSString * string = [NSString stringWithFormat:@"%@  %@",sellPrice,marketPrice];
    _priceLabel.attributedText = [NSString  AttributedStringWithContent:string andTitle:sellPrice];
    [_freeCostButton setTitle:[NSString stringWithFormat:@" 省赚:¥%.f", [_goodModel.recommendedPrice floatValue]-[_goodModel.sellPrice floatValue]] forState:UIControlStateNormal];
    [self.shadowView addSubview:self.collectView];
    
    NSString * specificationName = [_goodModel.goodsSpecifications.firstObject objectForKey:@"specificationName"];
    long  guigeCount = (_goodModel.goodsSpecifications.count%[self cellWith:specificationName]==0? _goodModel.goodsSpecifications.count/[self cellWith:specificationName]:_goodModel.goodsSpecifications.count/[self cellWith:specificationName]+1);
    CGFloat height = (_goodModel.goodsPics.count>6?3:2)*(95*RATIO_IPHONE6+5) + guigeCount*35+35+10;
    _collectView.top = _middleView.bottom+5;
    _collectView.height = height;
    
}
#pragma mark - LazyLoad
- (UICollectionView *)collectView
{
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.frame = CGRectMake(0, 155, SCREEN_WIDTH-30, 260);
        _collectView.showsVerticalScrollIndicator = NO;        //注册
        _collectView.scrollEnabled = NO;
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([LMHImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"LMHImageCollectionViewCell"];
        [_collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewID"];
        _collectView.backgroundColor = White_Color;
        
    }
    return _collectView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section==0) {
        
        NSInteger cout =  (_goodModel.goodsPicList.count?_goodModel.goodsPicList.count:_goodModel.goodsPics.count) ;
        return (cout>=9?9:cout);
    }
    return (_goodModel.specifications.count?_goodModel.specifications.count:_goodModel.goodsSpecifications.count) ;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LMHImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMHImageCollectionViewCell" forIndexPath:indexPath];
    cell = cell;
    if (indexPath.section ==0 ) {//10
        cell .contentLabel.hidden = YES;
        cell.imageView.hidden = NO;
        
//        if (_goodModel.goodsPicList.count) {
//            NSDictionary* diction = _goodModel.goodsPicList[indexPath.row];
//            [cell.imageView setImageWithURL:[diction[@"url"] changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
//        }else{
            NSDictionary* diction = _goodsPicArray[indexPath.row];
            [cell.imageView setImageWithURL:[diction[@"url"] changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
//        }
       
    }else{
        cell.contentLabel.hidden = NO;
        cell.imageView.hidden = YES;
        NSString * specificationName;
        if (_goodModel.specifications.count) {
             specificationName = [_goodModel.specifications[indexPath.row] objectForKey:@"specificationName"];

        }else{
             specificationName = [_goodModel.goodsSpecifications[indexPath.row] objectForKey:@"specificationName"];
        }

        cell.contentLabel.text = specificationName;
        [cell.contentLabel draCirlywithColor:nil andRadius:2.0f];
        
        if (_selectGuigeIndex==indexPath.row+100) {
            cell.contentLabel.backgroundColor = Main_Color;
        }else{
            cell.contentLabel.backgroundColor = [UIColor HexString:@"f5f5f5"];
        }
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}
#pragma mark  商品图片 排序
-(void)goodPiclist{
    
    if (_goodModel.goodsPicList.count) {
        _goodsPicArray = [NSMutableArray arrayWithArray:_goodModel.goodsPicList];

       }else{
           _goodsPicArray = [NSMutableArray arrayWithArray:_goodModel.goodsPics];

    }
    for (int i =0; i<_goodsPicArray.count; i++) {
              NSDictionary * dict = _goodsPicArray[i];
              int order = [dict[@"order"] intValue];
              if (order>=1) {
                  if (order==4) {
                      NSDictionary * dic = _goodsPicArray.lastObject;
                      [_goodsPicArray replaceObjectAtIndex:_goodsPicArray.count-1 withObject:dict];
                      [_goodsPicArray replaceObjectAtIndex:i withObject:dic];

                  }else{
                      NSDictionary * dic = _goodsPicArray[order-1];
                      [_goodsPicArray replaceObjectAtIndex:order-1 withObject:dict];
                      [_goodsPicArray replaceObjectAtIndex:i withObject:dic];

                  }
              }
          }
}

- (UIColor*)randomColor {
    NSInteger aRedValue =arc4random() %255;
    NSInteger aGreenValue =arc4random() %255;
    NSInteger aBlueValue =arc4random() %255;
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 1) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewID" forIndexPath:indexPath];

            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 20)];
            label.text = @"选择商品规格";
            label.font = [UIFont boldSystemFontOfSize:12];
            label.textColor = Sub_title_Color;
            [headerView addSubview:label];
            reusableview = headerView;
        }
    }
    return reusableview;
}


#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        return CGSizeMake(95*RATIO_IPHONE6, 95*RATIO_IPHONE6);
    }else{
        NSString * specificationName ;
        if (_goodModel.specifications.count) {
            specificationName = [_goodModel.specifications.firstObject objectForKey:@"specificationName"];
        }else{
            specificationName = [_goodModel.goodsSpecifications.firstObject objectForKey:@"specificationName"];
        }
        NSInteger  guigeCount = [self cellWith:specificationName];
        return CGSizeMake((SCREEN_WIDTH-30-65)/guigeCount, 30);
    }
    return CGSizeZero;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 0) {
        layoutAttributes.size = CGSizeMake(0,0);
    }else{
        layoutAttributes.size = CGSizeMake(self.shadowView.width, 30);

    }
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return CGSizeMake(0, 30); //
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
    return (section >= 1) ? 4 : 16;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        NSLog(@"====");
        NSMutableArray *bigImageArray = [NSMutableArray array];
        
        for (int i = 0; i < _goodsPicArray.count; i++) {
            NSDictionary* diction = _goodsPicArray[i];
            [bigImageArray addObject:diction[@"url"]];
        }
        
        QWNViewController *vc = [[QWNViewController alloc]init];
        vc.imagesArr = bigImageArray;
        vc.index = [NSString stringWithFormat:@"%d",indexPath.row];
        [[UIViewController getCurrentController] presentViewController:vc animated:YES completion:nil];
        
    }else{
        _selectGuigeIndex = indexPath.row+100;
        [collectionView reloadData];
    }
}

/**
 
 根据规格宽度判断是一行展示多少个
 宽度大于一半cell宽度 一行显示一个
 宽度小于一半cell宽度  大于三分之一cell宽度 一行显示两个
 否则 一行显示3个
 */
-(NSInteger)cellWith:(NSString*)string{
    
    if (string==nil || [string isEqualToString:@""]) {
        return 1;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
    CGFloat titleWith;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, 20)options:options context:nil];
    titleWith = ceilf(rect.size.width);
    
    if (titleWith>=(SCREEN_WIDTH-60)/2) {
        return  1;
    }else  if (titleWith<(SCREEN_WIDTH-60)/2 && titleWith>(SCREEN_WIDTH-60)/3) {
        return  2;
    }else {
        return 3;
    }
    
}

#pragma mark 高度设置
-(CGFloat)cellHight:(NSString*)string{
    
    if (string==nil || [string isEqualToString:@""]) {
        return 1;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
    CGFloat titleHeight;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, CGFLOAT_MAX)options:options context:nil];
    titleHeight = ceilf(rect.size.height);
    
    return  titleHeight ;
}

#pragma mark  加入购物车
- (void)joinCar{
    
    if (_selectGuigeIndex==0) {
        [MBProgressHUD showError:@"请选择规格！"];
        return;
    }
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_cart_addCart];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionaryWithCapacity:20];
    [diction setObject:_goodModel.goodsId forKey:@"goodsId"];
    [diction setObject:_goodModel.goodsName forKey:@"goodsName"];
    if (_goodModel.brandName) {
        [diction setObject:_goodModel.brandName forKey:@"brandName"];
        [diction setObject:_goodModel.brandLogo forKey:@"brandUrl"];
        [diction setObject:_goodModel.brandId forKey:@"brandId"];

    }else{
        if (_goodModel.brand_name) {
            [diction setObject:_goodModel.brand_name forKey:@"brandName"];
            [diction setObject:_goodModel.brandLogo forKey:@"brandUrl"];
            [diction setObject:_goodModel.brandId forKey:@"brandId"];
        }else{
            [diction setObject:_bandModel.brandName forKey:@"brandName"];
            [diction setObject:_bandModel.brandLogo forKey:@"brandUrl"];
            [diction setObject:_bandModel.brandId forKey:@"brandId"];
        }
    }
    
    if ((_selectGuigeIndex-100)<_goodModel.specifications.count) {
        NSDictionary *dict =  _goodModel.specifications[_selectGuigeIndex-100];
        [diction setObject:dict[@"specificationName"] forKey:@"goodsSpecifications"];
        [diction setObject:dict[@"specificationId"] forKey:@"specificationsId"];
        [diction setObject:dict[@"sellPrice"] forKey:@"price"];
    }else if((_selectGuigeIndex-100)<_goodModel.goodsSpecifications.count){
        NSDictionary *dict =  _goodModel.goodsSpecifications[_selectGuigeIndex-100];
        [diction setObject:dict[@"specificationName"] forKey:@"goodsSpecifications"];
        [diction setObject:dict[@"specificationId"] forKey:@"specificationsId"];
        [diction setObject:_goodModel.sellPrice forKey:@"price"];
    }
    
    if ( _goodModel.goodsPicList.count) {
        NSDictionary *picDic =  _goodsPicArray.firstObject;
        [diction setObject:picDic[@"url"] forKey:@"goodsUrl"];
    }else if ( _goodModel.goodsPics.count) {
        NSDictionary *picDic =  _goodsPicArray.firstObject;
        [diction setObject:picDic[@"url"] forKey:@"goodsUrl"];
    }
    [diction setObject:_goodCountTextField.text forKey:@"num"];

    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
   
        [MBProgressHUD showSuccess:@"已成功添加购物车！"];
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}

@end
