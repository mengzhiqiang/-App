//
//  LMHShareGoodsView.m
//  BaseProject
//
//  Created by zhiqiang meng on 16/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHShareGoodsView.h"
#import "LMHCustomImageDraw.h"
@interface LMHShareGoodsView()

@property (strong, nonatomic)  UIImageView *mainImage;
@property (strong, nonatomic)  UIImageView *sigleImage;
@property (strong, nonatomic)  UIImageView *sizeImage;

@property (strong, nonatomic)  NSArray *sourceImages;

@property (strong, nonatomic)  UIImage *mainImg;
@property (strong, nonatomic)  UIImage *sizeImg;
@property (strong, nonatomic)  UIImage *sigleImg;
@property (strong, nonatomic)  NSArray *foureImages;
@property (strong, nonatomic)  LMHGoodDetailModel *goodModel;


@property (assign, nonatomic)  NSInteger selectIndex;

@end

@implementation LMHShareGoodsView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
}

-(UIImageView*)mainImage{
    if (!_mainImage) {
        _mainImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _mainImage.backgroundColor =[UIColor whiteColor];
        _mainImage.tag=100;
    }
    _mainImage.hidden = NO;
    return _mainImage;
}
-(UIImageView*)sizeImage{
    if (!_sizeImage) {
        _sizeImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _sizeImage.backgroundColor =[UIColor whiteColor];
        _sizeImage.tag=100;
    }
    _sizeImage.hidden = NO;
    return _sizeImage;
}
-(UIImageView*)sigleImage{
    if (!_sigleImage) {
        _sigleImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _sigleImage.backgroundColor =[UIColor whiteColor];
        _sigleImage.tag=100;
    }
    _sigleImage.hidden = NO;
    return _sigleImage;
}

- (IBAction)selectImageStyle:(UIButton *)sender {
    
    if (_shareImages==nil) {
        return ;
    }
    
    for (UIButton *btn in self.selectImagesButtons) {
        [btn setTitleColor:Main_title_Color forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        btn.backgroundColor = Main_BG_Color;
    }
    [sender setTitleColor:Main_Color forState:UIControlStateNormal];
    sender.layer.borderColor = Main_Color.CGColor;
    sender.layer.borderWidth = 1;
    sender.backgroundColor = [UIColor clearColor];
    
    for (UIImageView*iv in _goodsImageView.subviews) {
        if (iv.tag==100) {
            iv.hidden = YES;
        }else{
            iv.hidden = YES;
            [iv removeAllSubviews];
        }
    }
    switch (sender.tag) {
        case 20:
            self.mainImage.hidden = NO;
            _shareImages = @[self.mainImage.image];
            break;
        case 21:
            _sigleImage.hidden = NO;
            _shareImages = @[self.sigleImage.image];

            break;
        case 22:
            _shareImages = _foureImages;
            
            float with = 74;
            float marg = (_goodsImageView.width-30-with*4)/3;
            
            for (int i=0; i<4; i++) {
                UIImageView * imageV =[[UIImageView alloc]initWithImage:_foureImages[i]];
                imageV.frame = CGRectMake(15+(with+marg)*i, 36 , with, with);
                imageV.backgroundColor = White_Color;
                [_goodsImageView addSubview:imageV];
            }
            break;
        case 23:
        {
            _sizeImage.hidden = NO;
            _shareImages = @[self.sizeImage.image];
        }
            break;
            
        default:
            break;
    }
    
    _selectIndex = sender.tag;
    
}


- (IBAction)controlButton:(UIButton *)sender {
    
    if (_shareImages==nil) {
          return ;
      }
    
    if (sender.tag==12) {
        self.hidden = YES;
    }else{
        if (_backSelect) {
            _backSelect(sender.tag);
        }
    }
    
}
- (IBAction)hiddenView:(UIButton *)sender {
    self.hidden = YES;

}

-(void)shareimage:(LMHGoodDetailModel*)model{

    _goodModel = model;
    [self loadimageWithModel:model];
}

#pragma mark  商品图片 排序
-(NSMutableArray*)goodPiclist{
    NSMutableArray *goodsPicArray;
    if (_goodModel.goodsPicList.count) {
       goodsPicArray = [NSMutableArray arrayWithArray:_goodModel.goodsPicList];

       }else{
         goodsPicArray = [NSMutableArray arrayWithArray:_goodModel.goodsPics];

    }
    for (int i =0; i<goodsPicArray.count; i++) {
              NSDictionary * dict = goodsPicArray[i];
              int order = [dict[@"order"] intValue];
              if (order>=1) {
                  if (order==4) {
                      NSDictionary * dic = goodsPicArray.lastObject;
                      [goodsPicArray replaceObjectAtIndex:goodsPicArray.count-1 withObject:dict];
                      [goodsPicArray replaceObjectAtIndex:i withObject:dic];

                  }else{
                      NSDictionary * dic = goodsPicArray[order-1];
                      [goodsPicArray replaceObjectAtIndex:order-1 withObject:dict];
                      [goodsPicArray replaceObjectAtIndex:i withObject:dic];

                  }
              }
          }
    return goodsPicArray;
}

/**
 下载网络图片合成

 */
- (void)loadimageWithModel:(LMHGoodDetailModel*)model
{
    [MBProgressHUD showActivityIndicator];
    // 1.队列组、全局并发队列 的初始化
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSArray * goods = [self goodPiclist] ;
//    if (model.goodsPicList.count) {
//      goods  = model.goodsPicList;
//    }else if (model.goodsPics.count){
//        goods  = model.goodsPics;
//    }
    
    if (goods.count>=4) {
        NSDictionary* diction = goods[0];
        NSDictionary* diction1 = goods[1];
        NSDictionary* diction2 = goods[2];
        NSDictionary* diction3 = goods.lastObject;

        // 2.在block内部不能修改外部的局部变量，这里必须要加前缀 __block
        // 注意这里的异步执行方法多了一个group（队列）
        __block UIImage *image1 = nil;
        dispatch_group_async(group, queue, ^{
            NSURL *url1 = [NSURL URLWithString:diction[@"url"]];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            image1 = [UIImage imageWithData:data1];
        });
        
        // 3.下载图片2
        __block UIImage *image2 = nil;
        dispatch_group_async(group, queue, ^{
            NSURL *url2 = [NSURL URLWithString:diction1[@"url"]];
            NSData *data2 = [NSData dataWithContentsOfURL:url2];
            image2 = [UIImage imageWithData:data2];
        });
        
        // 3.下载图片3
        __block UIImage *image3 = nil;
        dispatch_group_async(group, queue, ^{
            NSURL *url3 = [NSURL URLWithString:diction2[@"url"]];
            NSData *data3 = [NSData dataWithContentsOfURL:url3];
            image3 = [UIImage imageWithData:data3];
        });
        // 3.下载图片4
        __block UIImage *image4 = nil;
        dispatch_group_async(group, queue, ^{
            NSURL *url4 = [NSURL URLWithString:diction3[@"url"]];
            NSData *data4 = [NSData dataWithContentsOfURL:url4];
            image4 = [UIImage imageWithData:data4];
        });
        
        // 4.合并图片 (保证执行完组里面的所有任务之后，再执行notify函数里面的block)
        dispatch_group_notify(group, queue, ^{
            _sourceImages= [NSArray arrayWithObjects:image1, image2,image3,image4, nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideActivityIndicator];
                [self loadChangePrice:nil];
                
            });
          
            
        });
    }
  
}

/**
更改价格重新合成
 */
-(void)loadChangePrice:(NSString*)price{
    
    for (UIImageView*iv in _goodsImageView.subviews) {
        if (iv.tag==100) {
            iv.hidden = YES;
        }else{
            iv.hidden = YES;
            [iv removeAllSubviews];
        }
    }
    
    UIImage* image = [LMHCustomImageDraw  DrawMainImageWithModel:_goodModel andimages:_sourceImages addPrice:price];
    float heght = 130;
    float wight = (130*image.size.width)/image.size.height;
    self.mainImage.frame = CGRectMake((self.goodsImageView.width- wight)/2, 10,wight, heght);
    self.mainImage.image = image;
    self.mainImage.backgroundColor = White_Color;
    [self.goodsImageView addSubview:self.mainImage];
    
    UIImage* imageSize = [LMHCustomImageDraw  DrawSizeImageWithModel:_goodModel andimages:_sourceImages addPrice:price];
    heght = 130;
    wight = (130*imageSize.size.width)/imageSize.size.height;
    self.sizeImage.frame = CGRectMake((self.goodsImageView.width- wight)/2, 10,wight, heght);
    self.sizeImage.image = imageSize;
    self.sizeImage.backgroundColor = White_Color;
    _sizeImage.hidden= YES;
    [self.goodsImageView addSubview:_sizeImage];
    
    UIImage* imageSingle = [LMHCustomImageDraw  DrawSigleImageWithModel:_goodModel andimages:_sourceImages addPrice:price];
    heght = 130;
    wight = (130*imageSingle.size.width)/imageSingle.size.height;
    self.sigleImage.frame = CGRectMake((self.goodsImageView.width- wight)/2, 10,wight, heght);
    self.sigleImage.image = imageSingle;
    self.sigleImage.backgroundColor = White_Color;
    _sigleImage.hidden= YES;
    [self.goodsImageView addSubview:_sigleImage];
    
    self.foureImages = [LMHCustomImageDraw  DrawFoureImageWithModel:_goodModel andimages:_sourceImages addPrice:price];

    _shareImages = @[self.mainImage.image];

}


@end
