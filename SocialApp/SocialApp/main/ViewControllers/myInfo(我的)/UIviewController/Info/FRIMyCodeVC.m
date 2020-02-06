//
//  FRIMyCodeVC.m
//  SocialApp
//
//  Created by wfg on 2019/12/31.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIMyCodeVC.h"

@interface FRIMyCodeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;
@property (weak, nonatomic) IBOutlet UIImageView *sexIv;
@property (weak, nonatomic) IBOutlet UIImageView *codeIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *ageLbl;

@end

@implementation FRIMyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"我的二维码";
    //    iocn_nan iocn_nv
    self.sexIv.tintColor = [UIColor whiteColor];
    self.sexIv.image = [[UIImage imageNamed:@"iocn_nv"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];;
    [self.headerIv sd_setImageWithUrlString:self.model.userImg];
    [self.codeIv sd_setImageWithUrlString:self.model.userQrCode];
    self.nameLbl.text = self.model.userNickname;
    self.ageLbl.text = self.model.userAge;
    
    [self setupImage];
}

-(void)setupImage{
    //创建名为"CIQRCodeGenerator"的CIFilter
     CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
     //将filter所有属性设置为默认值
     [filter setDefaults];
     
     //将所需尽心转为UTF8的数据，并设置给filter
     NSData *data = [[NSString stringWithFormat:@"%@&%@",@"",@""] dataUsingEncoding:NSUTF8StringEncoding];
     [filter setValue:data forKey:@"inputMessage"];
     
     //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
     /*
      * L: 7%
      * M: 15%
      * Q: 25%
      * H: 30%
      */
     [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
     
     //拿到二维码图片，此时的图片不是很清晰，需要二次加工
     CIImage *outPutImage = [filter outputImage];
    
   UIImage* image =  [self getHDImgWithCIImage:outPutImage size:CGSizeMake(100, 100)];
    
    self.codeIv.image = image;
}

/**
 调整二维码清晰度

 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @return 清晰的二维码图片
 */
- (UIImage *)getHDImgWithCIImage:(CIImage *)img size:(CGSize)size {
    
    CGRect extent = CGRectIntegral(img.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    //1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:img fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //清晰的二维码图片
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    return outputImage;
}


@end
