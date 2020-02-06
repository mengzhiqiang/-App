//
//  UIImageView+Extension.h
//  PieLifeApp
//
//  Created by libj on 2019/8/8.
//  Copyright © 2019 Libj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "objc/runtime.h"
NS_ASSUME_NONNULL_BEGIN
static char loadOperationKey;

typedef void(^WebImageProgressBlock)(CGFloat persent);
typedef void(^WebImageCompletedBlock)(UIImage *image, NSError *error);
typedef void(^WebImageCanceledBlock)(void);

@interface UIImageView (Extension)

/**
 加载图片 使用默认占位图
 
 @param urlStr 图片地址
 */
- (void)sd_setImageWithUrlString:(NSString *)urlStr;

- (void)sd_setImageWithUrlString:(NSString *)urlStr placeholderImageName:(NSString * _Nullable )placeholderImageName;
/**
 加载图片
 
 @param urlStr 图片地址
 @param placeholderImage 占位图
 */
- (void)sd_setImageWithUrlString:(NSString *)urlStr placeholderImage:(UIImage * _Nullable )placeholderImage;

- (void)setSexIconImaageWithsex:(NSInteger)sex;

- (void)setImageWithURL:(NSURL *)imageURL;
- (void)setImageWithURL:(NSURL *)imageURL completedBlock:(WebImageCompletedBlock)completedBlock;
- (void)setImageWithURL:(NSURL *)imageURL progressBlock:(WebImageProgressBlock)progressBlock completedBlock:(WebImageCompletedBlock)completedBlock;
- (void)setWebPImageWithURL:(NSURL *)imageURL progressBlock:(WebImageProgressBlock)progressBlock completedBlock:(WebImageCompletedBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
