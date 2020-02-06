//
//  FRIMyInfoViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 28/10/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIMineViewController.h"
#import "LivenessViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import "DetectionViewController.h"
#import "FRIMyInfoVC.h"
#import "FRISystemSettingVC.h"
#import "SAUserWalletVC.h"
#import "FRICurrencyVC.h"
#import "FRIMineInfoRequest.h"
#import "Global.h"
@interface FRIMineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) FRIMineInfoRequest *req;
@property (nonatomic, strong) UserInfo *infoModel;
@end

@implementation FRIMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.customNavBar removeFromSuperview];
    self.dataArr = @[
        @[@"icon_wdjf", @"我的才值"],
        @[@"icon_wdqb", @"我的钱包"],
        @[@"icon_xlzm", @"学历证明"],
        @[@"icon_dpsc", @"店铺收藏"],
        @[@"icon_fxyq", @"分享邀请"],
        @[@"icon_setup", @"系统设置"],
    ];
    
    CAShapeLayer *cornerLayer = [CAShapeLayer layer];
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(25, 25)];
    cornerLayer.path = cornerPath.CGPath;
    cornerLayer.frame = frame;
    self.bottomView.layer.mask = cornerLayer;
    
    MJWeakSelf
    self.req = [FRIMineInfoRequest Request];
    self.req.successBlock = ^(NSDictionary *dic) {
        [MBProgressHUD hideActivityIndicator];
        UserInfo *infoModel = [UserInfo mj_objectWithKeyValues:dic[@"data"]];
        weakSelf.infoModel = infoModel;
        [weakSelf updateInfo:infoModel];
        [Global sharedGlobal].curUser = infoModel;
    };
    [self updateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:kNotificationUpdateUserInfo object:nil];
//    [self addObserver:self forKeyPath:@"infoModel" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self livenessAction];
}

- (void)updateData {
    [MBProgressHUD showActivityIndicator];
    self.req.requestNeedActive = YES;

}

- (IBAction)infoAction:(UIButton *)sender {
    FRIMyInfoVC *vc = (FRIMyInfoVC *)[FRIMyInfoVC viewControllerWithXib];
    vc.model = self.infoModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)activityAction:(UIButton *)sender {
    
}

- (IBAction)myActivityAction:(UIButton *)sender {
    
}

- (void)updateInfo:(UserInfo *)model {
    [self.headerIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_HOST, model.userImg]]];
    self.nameLbl.text = model.userNickname;
    self.idLbl.text = [NSString stringWithFormat:@"ID:%@", model.accountId];
}

#pragma TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *arr = self.dataArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:arr.firstObject];
    cell.textLabel.text = arr.lastObject;
    WS(weakself);
    //    cell.tapBlock = ^(NSInteger types, NSString * _Nonnull ID) {
    //        if(types == 1){//取消关注
    ////            [weakself attenUrl:ID];
    //        }else{//关注
    //        }
    //    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[FRICurrencyVC viewControllerWithXib] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[SAUserWalletVC viewControllerWithXib] animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:[FRISystemSettingVC new] animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)livenessAction {
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    LivenessViewController* lvc = [[LivenessViewController alloc] init];
    LivingConfigModel* model = [LivingConfigModel sharedInstance];
    [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)detectAction{
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    
    DetectionViewController* dvc = [[DetectionViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:dvc];
    navi.navigationBarHidden = true;
    [self presentViewController:navi animated:YES completion:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    [self updateInfo:object];
//}
@end
