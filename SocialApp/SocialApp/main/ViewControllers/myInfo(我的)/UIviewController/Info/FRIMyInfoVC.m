//
//  FRIMyInfoVC.m
//  SocialApp
//
//  Created by wfg on 2019/12/31.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIMyInfoVC.h"
#import "UIAlertController+Simple.h"
#import "FRIEditNameVC.h"
#import "FRIMyCodeVC.h"
#import "FRICardEnterViewController.h"
#import "FRIEduAuthenViewController.h"
#import "FRINameAuthedVC.h"
#import "FRIMineInfoEditRequest.h"
#import "Global.h"
@interface FRIMyInfoVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;
@property (weak, nonatomic) IBOutlet UITextField *idTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIImageView *codeIv;
@property (weak, nonatomic) IBOutlet UITextField *signTF;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextField *marriageTF;
@property (weak, nonatomic) IBOutlet UITextField *nameAuthTF;
@property (weak, nonatomic) IBOutlet UITextField *eduAuthTF;

@end

@implementation FRIMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"个人资料";
    [[Global sharedGlobal] addObserver:self forKeyPath:@"curUser" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    UserInfo *model = self.model;
    [self.headerIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_HOST, model.userImg]]];
    self.idTF.text = model.accountId;
    self.nameTF.text = model.userNickname;
    self.signTF.text = model.userMotto;
    //    self.sexTF.text = mode
    self.ageTF.text = model.userAge;
    //    self.marriageTF.text = model.marriageStatus;
    self.nameAuthTF.text = model.userIdentity;
    self.eduAuthTF.text = model.userEducation;
    self.marriageTF.text = @[@"暂不填写", @"单身", @"非单身"][model.marriageStatus.integerValue];
    if (self.model.userIdentity.length > 1) {
        self.nameAuthTF.text = @"已实名认证";
    } else {
        self.nameAuthTF.text = @"";
    }
}

- (IBAction)headerAction:(UIButton *)sender {
    [self addImage:1];
}

- (IBAction)nameAction:(UIButton *)sender {
    FRIEditNameVC *vc = [FRIEditNameVC viewControllerWithXib];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)codeAction:(UIButton *)sender {
    FRIMyCodeVC *vc = (FRIMyCodeVC *)[FRIMyCodeVC viewControllerWithXib];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sexAction:(UIButton *)sender {
}

- (IBAction)marriageAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController showSheetTitles:@[@"单身", @"非单身", @"暂不填写"] backIndex:^(UIAlertAction * _Nonnull UIAlertAction, NSInteger index) {
        FRIMineInfoEditRequest *req = [FRIMineInfoEditRequest Request];
        req.marriageStatus = @((index + 1)%3).stringValue;
        MJWeakSelf
        req.successBlock = ^(NSDictionary *dic) {
            [weakSelf handleSuccess:dic];
            weakSelf.marriageTF.text = @[@"单身", @"非单身", @"暂不填写"][index];
        };
        req.requestNeedActive = YES;

    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)nameAuthAction:(UIButton *)sender {
    if (self.model.userIdentity.length > 1) {
        [self.navigationController pushViewController:[FRINameAuthedVC new] animated:YES];
    } else {
        [self.navigationController pushViewController:[FRICardEnterViewController new] animated:YES];
    }
}

- (IBAction)eduAuthAction:(UIButton *)sender {
    [self.navigationController pushViewController:[FRIEduAuthenViewController new] animated:YES];
}

- (IBAction)completeInfoAction:(UIButton *)sender {
}

#pragma mark Image

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    [self upLoadImage:photos.firstObject];
    
}

/**
 * @Author   liaoqingfeng
 * @DateTime 2018-06-08
 * @方法   选择后图片
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //    [self.picArr addObject:image];
    //    [self updatePics];
    //    [self.imgBtn setImage:image forState:UIControlStateNormal];
    [self upLoadImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)upLoadImage:(UIImage*)loadImage{
    NSString * url = [API_HOST stringByAppendingString:kUploadImage];
    MJWeakSelf
    [MBProgressHUD showActivityIndicator];
    [HttpEngine httpRequestWithResquestImagePath:UIImagePNGRepresentation(loadImage)
                                     imageSuffix:nil url:url params:nil isToken:NO errorDomain:nil errorString:nil success:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        NSString *path = [responseObject objectForKey:@"data"];
        FRIMineInfoEditRequest *req = [FRIMineInfoEditRequest Request];
        req.userImg = path;
        req.successBlock = ^(NSDictionary *dic) {
            [weakSelf.headerIv sd_setImageWithUrlString:path];
            [weakSelf handleSuccess:dic];
        };
        req.requestNeedActive = YES;
    } failure:^(NSError *error) {
        [MBProgressHUD hideActivityIndicator];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (void)handleSuccess:(NSDictionary *)dic {
    [MBProgressHUD hideActivityIndicator];
    [MBProgressHUD showError:dic[@"message"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateUserInfo object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UserInfo *model = [object valueForKeyPath:keyPath];
    self.model = model;
    [self updateUI];
}

- (void)dealloc {
    [[Global sharedGlobal] removeObserver:self forKeyPath:@"curUser"];
}
@end
