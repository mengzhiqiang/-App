//
//  ShareSystemTools.m
//  BaseProject
//
//  Created by zhiqiang meng on 27/9/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "ShareSystemTools.h"

@implementation ShareSystemTools

+(void)shareWithData:(NSArray*)activityItems{
    
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //    3》很多系统自带的分享功能如果不需要的可以隐去，即设置不出现在活动项目中的选项数组  //不出现在活动项目
    activityVc.excludedActivityTypes = @[
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo
                                         ];
   
    
    //    4》推出控制器及分享回调
    [[UIViewController getCurrentController] presentViewController:activityVc animated:YES completion:nil];
    activityVc.completionWithItemsHandler = ^(UIActivityType _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
        if (completed) {
            NSLog(@"分享成功");
        }else{
            NSLog(@"分享取消");
        }
    };
}

@end
