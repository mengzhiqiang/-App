//
//  LMHCustomImageDraw.m
//  BaseProject
//
//  Created by zhiqiang meng on 16/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHCustomImageDraw.h"

@implementation LMHCustomImageDraw

/**
  主图
 */
//+(UIImage*)DrawMainImageWithModel:(LMHGoodDetailModel*)model andimages:(NSArray*)images addPrice:(NSString*)addPrice{
//    
////    NSString* content  = [NSString stringWithFormat:@"尺码 S M L \n款式 中长款纯色羽绒服(毛领可拆卸)【80%白鸭绒/白色/市场价 750.00】 \n款号 0001001"];
//    NSString * content = [NSString stringWithFormat:@"%@" ,model.goodsDesc];
//    CGFloat ContentHeight = [NSString  getHeightByWidth:520 title:content font:[UIFont boldSystemFontOfSize:18]];
//    UIGraphicsBeginImageContext(CGSizeMake(540, 116+ContentHeight+733));
//
//    NSDictionary * priceDic = model.specifications.firstObject ;
//    /**
//     *文字绘制
//     */
//    NSString* add = [[NSUserDefaults standardUserDefaults] objectForKey:kGoodShareAddPirceKey];
//    if (addPrice) {
//        add = addPrice;
//    }
//    NSString* mark =[NSString stringWithFormat:@"%@、%@、%@" ,model.goodsSn,model.brandName, model.goodsName];;
//    NSString* price = @"特价";
//    
//    NSString* price_sell;NSString* price_hua;
//    if (model.recommendedPrice) {
//        price_sell = [NSString stringWithFormat:@"¥%ld",[model.recommendedPrice integerValue] + add.integerValue];
//        price_hua  = [NSString stringWithFormat:@"¥%ld", [model.marketPrice integerValue] ];
//    }else{
//        price_sell = [NSString stringWithFormat:@"¥%ld",[priceDic[@"recommendedPrice"]integerValue] + add.integerValue];
//        price_hua  = [NSString stringWithFormat:@"¥%ld",[priceDic[@"marketPrice"] integerValue] ];
//    }
//   
//    NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName : Main_Color  };
//    //位置显示
//    [mark drawInRect:CGRectMake(16, 20, 500, 25) withAttributes:attr];
//    
//    NSDictionary *attrPrice = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName : [UIColor redColor]  };
//    NSDictionary *attrPriceSell = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:32], NSForegroundColorAttributeName : [UIColor redColor]  };
//    NSDictionary *attrPriceHua = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName : [UIColor grayColor]  };
//    
//    CGFloat with = [NSString  getWidthWithTitle:price_sell font:[UIFont boldSystemFontOfSize:32]];
//    CGFloat with_hua = [NSString  getWidthWithTitle:price_hua font:[UIFont boldSystemFontOfSize:15]];
//    
//    [price drawInRect:CGRectMake(16, 75, 40, 22) withAttributes:attrPrice];
//    [price_sell drawInRect:CGRectMake(16+40, 61, with, 36) withAttributes:attrPriceSell];
//    [price_hua drawInRect:CGRectMake(16+50+with, 75, with_hua, 22) withAttributes:attrPriceHua];
//    
//    NSDictionary *attrContent = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor grayColor]  };
//    [content drawInRect:CGRectMake(16, 116, 520, ContentHeight) withAttributes:attrContent];
//    
//    
//    /**
//     *图片绘制
//     */
//    CGFloat imageTop = 116+26+ContentHeight ;
//    [images[0] drawInRect:CGRectMake(10, imageTop, 520, 520)];
//    
//    [images[1] drawInRect:CGRectMake(10, imageTop+530, 167, 167)];
//    [images[2] drawInRect:CGRectMake(187, imageTop+530, 167, 167)];
//    [images[3] drawInRect:CGRectMake(364, imageTop+530, 167, 167)];
//    
//    CGImageRef NewMergeImg = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
//                                                          CGRectMake(0, 0, 540, 116+ContentHeight+733));
//    
//    UIGraphicsEndImageContext();
//    UIImage * image ;
//    if (NewMergeImg == nil) {
//        NSLog( @"解析错误");
//    }
//    else {
//        image = [UIImage imageWithCGImage:NewMergeImg] ;
////        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);  //保存
//    }
//
//    NSData * data = UIImageJPEGRepresentation(image,1.0);
//    UIImage * imagePng = [UIImage imageWithData:data];
//    return imagePng;
//}
//
///**
// 尺码图
// */
//+(UIImage*)DrawSizeImageWithModel:(LMHGoodDetailModel*)model andimages:(NSArray*)images addPrice:(NSString*)addPrice{
//    
//    NSString * content = [NSString stringWithFormat:@"%@" ,model.goodsDesc];
//    CGFloat ContentHeight = [NSString  getHeightByWidth:340 title:content font:[UIFont boldSystemFontOfSize:12]];
//    UIGraphicsBeginImageContext(CGSizeMake(717, 540));
//    NSDictionary * priceDic = model.specifications.firstObject ;
//    /**
//     *文字绘制
//     */
//    NSString* add = [[NSUserDefaults standardUserDefaults] objectForKey:kGoodShareAddPirceKey];
//    if (addPrice) {
//        add = addPrice ;
//    }
//    NSString* mark =[NSString stringWithFormat:@"%@、%@、%@" ,model.goodsSn,model.brandName, model.goodsName];;
//    NSString* price = @"特价";
//    NSString* price_sell;NSString* price_hua;
//    if (model.recommendedPrice) {
//        price_sell = [NSString stringWithFormat:@"¥%ld",[model.recommendedPrice integerValue] + add.integerValue];
//        price_hua  = [NSString stringWithFormat:@"¥%ld", [model.marketPrice integerValue] ];
//    }else{
//        price_sell = [NSString stringWithFormat:@"¥%ld",[priceDic[@"recommendedPrice"]integerValue] + add.integerValue];
//        price_hua  = [NSString stringWithFormat:@"¥%ld",[priceDic[@"marketPrice"] integerValue] ];
//    }
//    
//    NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName : Main_Color  };
//    //位置显示
//    [mark drawInRect:CGRectMake(10, 369, 340, 20) withAttributes:attr];
//    
//    NSDictionary *attrContent = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName : [UIColor grayColor]  };
//    [content drawInRect:CGRectMake(10, 398, 340, ContentHeight) withAttributes:attrContent];
//    
//    
//    NSDictionary *attrPrice = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:10], NSForegroundColorAttributeName : [UIColor redColor]  };
//    NSDictionary *attrPriceSell = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:22], NSForegroundColorAttributeName : [UIColor redColor]  };
//    NSDictionary *attrPriceHua = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:10], NSForegroundColorAttributeName : [UIColor grayColor]  };
//    
//    CGFloat with = [NSString  getWidthWithTitle:price_sell font:[UIFont boldSystemFontOfSize:22]];
//    CGFloat with_hua = [NSString  getWidthWithTitle:price_hua font:[UIFont boldSystemFontOfSize:10]];
//    
//    [price drawInRect:CGRectMake((344-with)/2-26, 487, 40, 22) withAttributes:attrPrice];
//    [price_sell drawInRect:CGRectMake((344-with)/2, 477, with, 36) withAttributes:attrPriceSell];
//    [price_hua drawInRect:CGRectMake((334+with)/2+10, 487, with_hua, 22) withAttributes:attrPriceHua];
//    
//    
//    /**
//     *图片绘制
//     */
//    CGFloat imageTop = 116+26+ContentHeight ;
//    [images[0] drawInRect:CGRectMake(10, 10, 344, 344)];
//    [images[3] drawInRect:CGRectMake(364, 10, 344, 344)];
//    [images[1] drawInRect:CGRectMake(364, 364, 167, 167)];
//    [images[2] drawInRect:CGRectMake(541, 364, 167, 167)];
//    
//    
//    CGImageRef NewMergeImg = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
//                                                          CGRectMake(0, 0, 717, 540));
//    
//    UIGraphicsEndImageContext();
//    UIImage * image ;
//    if (NewMergeImg == nil) {
//        NSLog( @"解析错误");
//    }
//    else {
//        image = [UIImage imageWithCGImage:NewMergeImg] ;
////        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);  //保存
//    }
//    
//    NSData * data = UIImageJPEGRepresentation(image,1.0);
//      UIImage * imagePng = [UIImage imageWithData:data];
//      return imagePng;}
//
///**
// 单图
// */
//+(UIImage*)DrawSigleImageWithModel:(LMHGoodDetailModel*)model andimages:(NSArray*)images addPrice:(NSString*)addPrice{
//    
//    NSString * content = [NSString stringWithFormat:@"%@" ,model.goodsDesc];
//    CGFloat ContentHeight = [NSString  getHeightByWidth:520 title:content font:[UIFont boldSystemFontOfSize:18]];
//    UIGraphicsBeginImageContext(CGSizeMake(540, 10+ContentHeight+632));
//    
//    NSDictionary * priceDic = model.specifications.firstObject ;
//    /**
//     *文字绘制
//     */
//    NSString* add = [[NSUserDefaults standardUserDefaults] objectForKey:kGoodShareAddPirceKey];
//    if (addPrice) {
//        add = addPrice;
//    }
//    
//    NSString* mark =[NSString stringWithFormat:@"%@、%@、%@" ,model.goodsSn,model.brandName, model.goodsName];;
//    NSString* price = @"特价";
//    NSString* price_sell;NSString* price_hua;
//    if (model.recommendedPrice) {
//        price_sell = [NSString stringWithFormat:@"¥%ld",[model.recommendedPrice integerValue] ];
//        price_hua  = [NSString stringWithFormat:@"¥%ld", [model.marketPrice integerValue] + add.integerValue];
//    }else{
//        price_sell = [NSString stringWithFormat:@"¥%ld",[priceDic[@"recommendedPrice"]integerValue] + add.integerValue];
//        price_hua  = [NSString stringWithFormat:@"¥%ld",[priceDic[@"marketPrice"] integerValue] ];
//    }
//    
//    NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName : Main_Color  };
//    //位置显示
//    [mark drawInRect:CGRectMake(16, 545, 500, 25) withAttributes:attr];
//    
//    NSDictionary *attrPrice = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName : [UIColor redColor]  };
//    NSDictionary *attrPriceSell = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:32], NSForegroundColorAttributeName : [UIColor redColor]  };
//    NSDictionary *attrPriceHua = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName : [UIColor grayColor]  };
//    
//    CGFloat with = [NSString  getWidthWithTitle:price_sell font:[UIFont boldSystemFontOfSize:32]];
//    CGFloat with_hua = [NSString  getWidthWithTitle:price_hua font:[UIFont boldSystemFontOfSize:15]];
//    
//    [price drawInRect:CGRectMake(16, 50+545, 40, 22) withAttributes:attrPrice];
//    [price_sell drawInRect:CGRectMake(16+40, 36+545, with, 36) withAttributes:attrPriceSell];
//    [price_hua drawInRect:CGRectMake(16+50+with, 50+545, with_hua, 22) withAttributes:attrPriceHua];
//    
//    NSDictionary *attrContent = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor grayColor]  };
//    [content drawInRect:CGRectMake(16, 632, 520, ContentHeight) withAttributes:attrContent];
//    
//    
//    /**
//     *图片绘制
//     */
//    [images[0] drawInRect:CGRectMake(10, 10, 520, 520)];
//    
//    
//    CGImageRef NewMergeImg = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
//                                                          CGRectMake(0, 0, 540, 10+ContentHeight+632));
//    
//    UIGraphicsEndImageContext();
//    UIImage * image ;
//    if (NewMergeImg == nil) {
//        NSLog( @"解析错误");
//    }
//    else {
//        image = [UIImage imageWithCGImage:NewMergeImg] ;
////        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);  //保存
//    }
//    
//    NSData * data = UIImageJPEGRepresentation(image,1.0);
//      UIImage * imagePng = [UIImage imageWithData:data];
//      return imagePng;
//    
//}
//
///**
// 四张图
// */
//+(NSArray*)DrawFoureImageWithModel:(LMHGoodDetailModel*)model andimages:(NSArray*)images addPrice:(NSString*)addPrice{
//    
//    NSString * content = [NSString stringWithFormat:@"商品编码：%@" ,model.goodsSn];
//    CGFloat ContentHeight = [NSString  getHeightByWidth:520 title:content font:[UIFont boldSystemFontOfSize:18]];
//    NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName : Main_Color  };
//
//    UIGraphicsBeginImageContext(CGSizeMake(540, 576));
//    [content drawInRect:CGRectMake(16, 545, 500, 20) withAttributes:attr];
//    /**
//     *图片绘制
//     */
//    [images[0] drawInRect:CGRectMake(10, 10, 520, 520)];
//    CGImageRef NewMergeImg = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
//                                                          CGRectMake(0, 0, 540, 10+ContentHeight+632));
//    UIGraphicsEndImageContext();
//    UIImage * image1 ;
//    if (NewMergeImg == nil) {
//        NSLog( @"解析错误");
//    }
//    else {
//        image1 = [UIImage imageWithCGImage:NewMergeImg] ;
//    }
//    
//    //================222===================
//    UIGraphicsBeginImageContext(CGSizeMake(540, 576));
//    [content drawInRect:CGRectMake(16, 545, 500, 20) withAttributes:attr];
//    /**
//     *图片绘制
//     */
//    [images[1] drawInRect:CGRectMake(10, 10, 520, 520)];
//    CGImageRef NewMergeImg2 = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
//                                                          CGRectMake(0, 0, 540, 10+ContentHeight+632));
//    UIGraphicsEndImageContext();
//    UIImage * image2 ;
//    if (NewMergeImg2 == nil) {
//        NSLog( @"解析错误");
//    }
//    else {
//        image2 = [UIImage imageWithCGImage:NewMergeImg2] ;
//    }
//    
//    //================3333===================
//    UIGraphicsBeginImageContext(CGSizeMake(540, 576));
//    [content drawInRect:CGRectMake(16, 545, 500, 20) withAttributes:attr];
//    /**
//     *图片绘制
//     */
//    [images[2] drawInRect:CGRectMake(10, 10, 520, 520)];
//    CGImageRef NewMergeImg3 = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
//                                                           CGRectMake(0, 0, 540, 10+ContentHeight+632));
//    UIGraphicsEndImageContext();
//    UIImage * image3 ;
//    if (NewMergeImg3 == nil) {
//        NSLog( @"解析错误");
//    }
//    else {
//        image3 = [UIImage imageWithCGImage:NewMergeImg3] ;
//    }
//    
//    //================333===================
//    UIGraphicsBeginImageContext(CGSizeMake(540, 576));
//    [content drawInRect:CGRectMake(16, 545, 500, 20) withAttributes:attr];
//    /**
//     *图片绘制
//     */
//    [images[3] drawInRect:CGRectMake(10, 10, 520, 520)];
//    CGImageRef NewMergeImg4 = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
//                                                           CGRectMake(0, 0, 540, 10+ContentHeight+632));
//    UIGraphicsEndImageContext();
//    UIImage * image4 ;
//    if (NewMergeImg4 == nil) {
//        NSLog( @"解析错误");
//    }
//    else {
//        image4 = [UIImage imageWithCGImage:NewMergeImg4] ;
//    }
//    
//    
//    
//    
//    return @[image1,image2,image3,image4];
//}
//
//
//
//
//-(NSMutableAttributedString*)content:(NSString*)string price:(NSString*)price{
//    
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
//    NSRange allRange = [string rangeOfString:string];
//    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:allRange];
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(3,price.length)];   // 字体大小
//    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:NSMakeRange(3+price.length,string.length-3+price.length)];
//
//    return attrStr;
//    
//    
//}

//CGFloat titleWith;
//NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//// 获取label的最大宽度高
//CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, 20)options:options context:nil];
//titleWith = ceilf(rect.size.width);


@end
