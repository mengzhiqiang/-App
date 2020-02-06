//
//  UIViewController+Extension.m
//  AFJiaJiaMob
//
//  Created by singelet on 2016/12/2.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "UIAlertController+Simple.h"
@implementation UIViewController (Extension)

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentController
{
    UIViewController *currentController = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootController = window.rootViewController;
    if (appRootController.presentedViewController) {
        nextResponder = appRootController.presentedViewController;
    }
    else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
//        nextResponder = [frontView nextResponder];
        nextResponder = appRootController;
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *navi = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        currentController = navi.childViewControllers.lastObject;
    }
    else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController *navi = (UIViewController *)nextResponder;
        currentController = navi.childViewControllers.lastObject;
    }
    else{
        currentController = nextResponder;
    }
    return currentController;
}
+ (UIViewController *)viewControllerWithXib {
    return [[self alloc] initWithNibName:NSStringFromClass(self) bundle:[NSBundle mainBundle]];
}

- (void)addImage:(CGFloat)ratio {
    UIAlertController *alert = [UIAlertController showSheetTitles:@[@"拍摄照片", @"从相册选取"] backIndex:^(UIAlertAction * _Nonnull UIAlertAction, NSInteger index) {
        if(index == 0){
            [self takePhoto];
        }else if(index == 1){
            TZImagePickerController *tzimagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            tzimagePickerController.allowTakePicture = NO;
            tzimagePickerController.allowPickingVideo = NO;
            tzimagePickerController.allowTakeVideo = NO;
            tzimagePickerController.hideWhenCanNotSelect = YES;
            tzimagePickerController.allowCrop = YES;
            CGFloat height = SCREEN_WIDTH/ratio;
            tzimagePickerController.cropRect = CGRectMake(0, (SCREEN_HEIGHT-height)/2, SCREEN_WIDTH, height);
            //            tzimagePickerController.needCircleCrop = YES;

            tzimagePickerController.barItemTextColor = Main_title_Color;
            tzimagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
            [[UIViewController getCurrentController] presentViewController:tzimagePickerController animated:YES completion:nil];
        }
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
//    [self.imgBtn setImage:photos.firstObject forState:UIControlStateNormal];
//    [self upLoadImage:photos.firstObject];
//
//    //    self.seleImage = [photos firstObject];
//    //    self.assetArray = [NSMutableArray arrayWithArray:assets];
//}
/**
 * @Author   liaoqingfeng
 * @DateTime 2018-06-08
 * @方法   openMenu 打开相机
 */
-(void)takePhoto{
    //判断是否有摄像头
    BOOL userCamara = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear | UIImagePickerControllerCameraDeviceFront];
    if (!userCamara) {
        [MBProgressHUD showError:@"该设备不支持摄像头"];
        return;
    }
    
    //设置影像来源
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
//        CGFloat height = 10.0/16*SCREEN_WIDTH;
//        picker.cameraOverlayView.frame = CGRectMake(0, (SCREEN_HEIGHT-height)/2, SCREEN_WIDTH, height);
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [[UIViewController getCurrentController] presentViewController:picker animated:YES completion:nil];
        //        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //        self.imagePickerController.allowsEditing = YES;
        //        [[UIViewController getCurrentController] presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

@end
