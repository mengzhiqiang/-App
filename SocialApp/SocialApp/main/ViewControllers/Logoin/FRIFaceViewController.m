//
//  FRIFaceViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 2/12/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIFaceViewController.h"
#import "LivenessViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import "DetectionViewController.h"
#import "FRIEduAuthenViewController.h"

@interface FRIFaceViewController ()

@end

@implementation FRIFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"人脸识别";
    [self detectAction];
}

- (void)detectAction{
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    
    DetectionViewController* dvc = [[DetectionViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:dvc];
    navi.navigationBarHidden = true;
    WS(weakself);
    dvc.backImage = ^(NSArray *images) {
        [weakself loadImageOfID:images.firstObject];
    };
    [self presentViewController:navi animated:YES completion:nil];
}


//- (void)livenessAction{
//    if ([[FaceSDKManager sharedInstance] canWork]) {
//        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
//        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
//    }
//    LivenessViewController* lvc = [[LivenessViewController alloc] init];
//    LivingConfigModel* model = [LivingConfigModel sharedInstance];
//    [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
//    navi.navigationBarHidden = true;
//    [self presentViewController:navi animated:YES completion:nil];
//    WS(weakself);
//    lvc.backImage = ^(NSArray *images) {
//        [weakself loadImageOfID:images.firstObject];
//    };
//}

-(void)loadImageOfID:(NSData*)IDImage{

    NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:_userIdentity,@"userIdentity",_userName,@"userName", nil];
    
    NSString *path = [API_HOST stringByAppendingString:client_attestation];

    [HttpEngine httpRequestWithResquestImagePath:IDImage imageSuffix:@".PNG" url:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(CGFloat progress) {
        NSLog(@"=progress==%f",progress);
    } success:^(id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        [MBProgressHUD showSuccess:@"身份验证成功！"];

        FRIEduAuthenViewController * eduVC= [FRIEduAuthenViewController new];
        [self.navigationController pushViewController:eduVC animated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"=error==%@",error);
        NSDictionary * diction =error.userInfo;
        [MBProgressHUD showError:diction[@"message"]];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
