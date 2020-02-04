//
//  LLPersonalViewController.m
//  FindWorker
//
//  Created by lijun L on 2019/7/16.
//  Copyright © 2019年 zhiqiang meng. All rights reserved.
//

#import "LLPersonalViewController.h"
#import "LLRightCell.h"
#import "TZImagePickerController.h"
#import "LMHAccountViewController.h"
#import "FRMAddressViewController.h"
#import "CommonVariable.h"
#import "UIAlertController+Simple.h"
#import "LMHChangeUserNameVC.h"
#import "LMHForwardingPriceView.h"
#import "LMHFeedBackVC.h"
#import "LMHAboutUsVC.h"
#import "CommonVariable.h"
#import "LMHMemberLevelVC.h"
#import "WKBaseWebViewController.h"
#import "AppDelegate+Update.h"

#import "BENLoginViewController.h"
static NSString *const LLRightCellid = @"LLRightCell";
@interface LLPersonalViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;/** <#class#> **/

@property (retain, nonatomic)  NSMutableArray * images;               // 发布图片
@property (retain, nonatomic)  NSMutableArray * assetArray;            // 选择的发布图片

@property (retain, nonatomic)  UserInfo * useInfo;        //当然用户

@end

@implementation LLPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _useInfo = [CommonVariable getUserInfo];
        self.customNavBar.title = @"个人资料";
    self.view.backgroundColor = Main_BG_Color;
    [self.view addSubview:self.tableView];
    [self creatRightBtn];
    [self getUseInfo];
}
#pragma mark  创建保存
-(void)creatRightBtn{
    UIButton *customeBtnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    [customeBtnFirst addTarget:self action:@selector(enterehzFilesVC) forControlEvents:UIControlEventTouchUpInside];
    [customeBtnFirst setTitle:@"保存" forState:UIControlStateNormal];
    [customeBtnFirst sizeToFit];
    customeBtnFirst.titleLabel.font = [UIFont systemFontOfSize:CGFloatBasedI375(13)];
    [customeBtnFirst setTitleColor:[UIColor colorWithHexString:@"#DB2A21"] forState:UIControlStateNormal];
    UIBarButtonItem *customeBtnFirstItem = [[UIBarButtonItem alloc] initWithCustomView:customeBtnFirst];
  
    self.navigationItem.rightBarButtonItem  = customeBtnFirstItem;
}
#pragma mark  保存
-(void)enterehzFilesVC{
    
}
static NSString *const LLChargeDetailsCellID = @"LLChargeDetailsCell";
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 ) {
        return  3 ;
    } else  if (section ==1 ) {
        return  2;
    }else  if (section ==3 ) {
        return  1 ;
    }
    return 4;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==3) {
        return  50 ;
    }else if (indexPath.section==0 && indexPath.row==0 ){
        return 60;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==3) {
        return 20 ;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view =[[UIView alloc]init];
    view.backgroundColor = Main_BG_Color;
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLRightCell *cell = [tableView dequeueReusableCellWithIdentifier:LLRightCellid];
    
    cell.textview.hidden = YES;
    cell.showimage.hidden = YES;
    cell.rightlable.hidden = YES;

    if (indexPath.section==0) {
        cell.titlelable.text = @[@"用户头像",@"用户昵称",@"手机号"][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        switch (indexPath.row) {
            case 0:
                {
                    cell.showimage.hidden = NO;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    [cell.showimage setImageWithURL:[NSURL URLWithString:_useInfo.portrait] placeholderImage:[UIImage imageNamed:DefluatPic]];
                }
                break;
            case 1:
            {
                cell.rightlable.text = (_PersonModel.userName?_PersonModel.userName:[_useInfo.phone changePhone]);
                cell.rightlable.hidden = NO;
            }
                break;
                
            case 2:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.rightlable.text = [_useInfo.phone changePhone];
                cell.rightlable.hidden = NO;
                [cell.rightlable mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(CGFloatBasedI375(-15));
                }];
                
            }
                break;
                
            default:
                break;
        }
        
    }else  if (indexPath.section==1) {
//        cell.titlelable.text = @[@"转发商品设置",@"会员等级",@"账号管理",@"地址管理"][indexPath.row];

        cell.titlelable.text = @[@"转发商品设置",@"地址管理"][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
            {

                cell.rightlable.hidden = NO;
              NSString*price =   [[NSUserDefaults standardUserDefaults] objectForKey:kGoodShareAddPirceKey];
                if (price.integerValue==0) {
                    cell.rightlable.text = @"不加价";
                }else{
                    cell.rightlable.text = [NSString stringWithFormat:@"加价 %@元",price];
                }
                
            }
                break;
            case 1:
            {
//                cell.rightlable.text = _PersonModel.levelName;
//                cell.rightlable.hidden = NO;

            }
                break;

            default:
                break;
        }
        
    }else   if (indexPath.section==2) {
        cell.titlelable.text = @[@"意见反馈",@"清除缓存",@"检查更新",@"关于我们"][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 1:
            {
                cell.rightlable.text =  [NSString stringWithFormat:@"%.2fMB",[self getFilePath]];
                cell.rightlable.hidden = NO;
            }
                break;
            default:
                break;
        }
    } else   if (indexPath.section==3) {
        cell.titlelable.text = @"退出登录";
        cell.titlelable.textColor = White_Color ;
        cell.titlelable.textAlignment = NSTextAlignmentCenter;

        [cell.titlelable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(CGFloatBasedI375(43));
            make.right.offset(CGFloatBasedI375(-43));
            make.top.offset(1);
            make.height.offset(CGFloatBasedI375(49));
        }];
        cell.titlelable.backgroundColor = Main_Color;
        [cell.titlelable draCirlywithColor:nil andRadius:8.0];
        
        cell.backgroundColor = Main_BG_Color;
        cell.showimage.hidden = YES;
        cell.rightlable.hidden = YES;
        cell.lineView.hidden = YES;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            {
                switch (indexPath.row) {
                    case 0:
                        {
                            [self addHeaderImage];
                        }
                        break;
                    case 1:
                    {
                      //昵称
                        [self.navigationController pushViewController:[LMHChangeUserNameVC new] animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
            break;
            
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {  //转发
                    LMHForwardingPriceView *view = [[NSBundle mainBundle] loadNibNamed:@"LMHForwardingPriceView" owner:self options:nil].firstObject;
                    [self.view addSubview:view];
                    
                    view.backchange = ^() {
                        [_tableView reloadData];
                    };
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.view);
                    }];
                }
                    break;
//                case 1:
//                {
//                    // 会员
//                    LMHMemberLevelVC *vc = [[LMHMemberLevelVC alloc] initWithNibName:@"LMHMemberLevelVC" bundle:[NSBundle mainBundle]];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                    break;
                case 1:
//                {
//                    //账号
//                    LMHAccountViewController *vc = [[LMHAccountViewController alloc] initWithNibName:@"LMHAccountViewController" bundle:[NSBundle mainBundle]];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                    break;
//                case 3:
                {
                    //地址
                    FRMAddressViewController * addressVC =[[FRMAddressViewController alloc]init];
                    [self.navigationController pushViewController:addressVC animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;

        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {  //意见反馈
                    LMHFeedBackVC *vc = [[LMHFeedBackVC alloc] initWithNibName:@"LMHFeedBackVC" bundle:[NSBundle mainBundle]];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    // 清楚缓存
                    [self clearCache];
                }
                    break;
                case 2:
                {
                    //检查更新
                    [AppDelegate  checkAppVersion:NO];
                }
                    break;
                case 3:
                {
//                    LMHAboutUsVC *vc = [[LMHAboutUsVC alloc] initWithNibName:@"LMHAboutUsVC" bundle:[NSBundle mainBundle]];
//                    [self.navigationController pushViewController:vc animated:YES];
                    [self getaboutUS];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;

        case 3:
        {
            UIAlertController *alert = [UIAlertController showWithTitle:@"退出登录" message:@"你确定要退出登录吗?" confirm:^(UIAlertAction *alertAction) {
                [self logout ];
            }];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
#pragma mark 选择图片
- (void)addHeaderImage{
    UIAlertController *sheet = [UIAlertController showSheetTitles:@[@"拍照", @"从手机相册选择"] titleColor:Main_Color cancelColor:Sub_title_Color backIndex:^(UIAlertAction * _Nonnull UIAlertAction, NSInteger index) {
        if (index == 0) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            }

        } else if (index == 1) {
            TZImagePickerController *tzimagePickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
            tzimagePickerController.allowPickingVideo = NO;
            tzimagePickerController.allowTakeVideo = NO;
            tzimagePickerController.hideWhenCanNotSelect = YES;
            tzimagePickerController.allowCrop = YES;
            tzimagePickerController.needCircleCrop = YES;
            tzimagePickerController.circleCropRadius = SCREEN_WIDTH/2;
            tzimagePickerController.barItemTextColor = Main_title_Color;
            //    tzimagePickerController.al
            tzimagePickerController.needShowStatusBar = NO;
            tzimagePickerController.navLeftBarButtonSettingBlock = ^(UIButton *leftButton) {
                NSLog(@"==");
            };
            [self presentViewController:tzimagePickerController animated:YES completion:nil];
        } else {
            
        }
    }];
    [self presentViewController:sheet animated:YES completion:nil];
}

-(void)logout{
    
    [CommonVariable removeUserInfoData];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DefaultAddress"];
    [[NSUserDefaults standardUserDefaults]setObject:@"Newlogin" forKey:@"DefaultAddress"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController pushViewController:[BENLoginViewController new] animated:YES];
    NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
    self.navigationController.viewControllers = @[arr.firstObject, arr.lastObject];
}

#pragma mark -- TZImagePickerController delegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    self.images = [NSMutableArray arrayWithArray:photos];
    self.assetArray = [NSMutableArray arrayWithArray:assets];
    [self upLoadImage];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    self.images = [@[info[UIImagePickerControllerEditedImage]] mutableCopy];
    [self upLoadImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)upLoadImage{
    
    NSString * url = [API_Iamage_HOST stringByAppendingString:client_upload_uploadPortrait];
    UIImage * image= _images [0];
    NSData *imageData = UIImagePNGRepresentation(image);
    WS(weakself);
    [MBProgressHUD showActivityIndicator];
    [HttpEngine httpRequestWithResquestImagePath:imageData imageSuffix:nil url:url params:nil isToken:NO errorDomain:nil errorString:nil success:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        if ([responseObject objectForKey:@"data"]) {
            [weakself changeleHeadImage:[responseObject objectForKey:@"data"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"上传失败"];
        [MBProgressHUD hideActivityIndicator];

    }];
}

-(void)changeleHeadImage:(NSDictionary*)diction{
    
    _useInfo.portrait =  diction[@"src"];
    [CommonVariable saveWithModle:_useInfo];
    NSString * url = [API_HOST stringByAppendingString:client_userManager_eidtUser];
    NSDictionary*dic = @{@"portrait": diction[@"src"]};
    [_tableView reloadData];
    WS(weakself);
    [HttpEngine requestPostWithURL:url params:dic isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];

        [MBProgressHUD showSuccess:@"修改成功！"];
        return;
//        [weakself getUseInfo];
        [MBProgressHUD hideActivityIndicator];

    } failure:^(NSError *error) {
        [MBProgressHUD hideActivityIndicator];

        
    }];
    
}
-(void)getUseInfo{
    
    NSString * url = [API_HOST stringByAppendingString:client_account_getMyAccount];
    
    WS(weakself);
    [HttpEngine requestPostWithURL:url params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        
        if (responseObject[@"data"]) {
//            [CommonVariable saveUserInfoDataWithResponseObject:[responseObject objectForKey:@"data"]];
//            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark  懒加载
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = Main_BG_Color;
        [ _tableView  registerClass:[LLRightCell class] forCellReuseIdentifier:LLRightCellid];
    }
    return _tableView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight =10; //这里是我的headerView和footerView的高度
    if(_tableView.contentOffset.y<=sectionHeaderHeight&&_tableView.contentOffset.y>=0){
        _tableView.contentInset = UIEdgeInsetsMake(-_tableView.contentOffset.y,0,0,0);
        
      }else if(_tableView.contentOffset.y>=sectionHeaderHeight){
          _tableView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight,0,0,0);
     }
}


/*
 清除缓存
 */

-(void)clearCache{
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       //                       NSString *cachPath0 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       //
                       //                       NSArray *files0 = [[NSFileManager defaultManager] subpathsAtPath:cachPath0];
                       //                       NSLog(@"files :%lu",(unsigned long)[files0 count]);
                       //                       for (NSString *p in files0) {
                       //
                       //                           NSLog(@"NSDocumentDirectory-->files :%@",p);
                       //
                       //                           if ([p isEqualToString:@""] || [p rangeOfString:kJiaJiaMobBabiesRobotsInformation].location != NSNotFound|| [p rangeOfString:kJiaJiaMobBabiesInformation].location != NSNotFound|| [p rangeOfString:kJiaJiaMobAccountInformation].location != NSNotFound || [p rangeOfString:kJiaJiaMobPhotoFileName].location != NSNotFound) {
                       //                               NSLog(@"NSDocumentDirectory-不删除的文件->files :%@",p);
                       //                               continue;
                       //                           }
                       //                           NSError *error;
                       //                           NSString *path = [cachPath0 stringByAppendingPathComponent:p];
                       //                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                       //                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                       //                           }
                       //                       }
                       /*
                        聊天暂时不给删除
                        */
                       //                       [AFChatRecordEngine removeNIMChatRecord]; ///删除聊天记录
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSLog(@"NSCachesDirectory--->files :%@",p);
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       
                       //                       NSFileManager *fileManager=[NSFileManager defaultManager];
                       //                       if ([fileManager fileExistsAtPath:cachPath]) {
                       //                           NSArray *fileNames = [fileManager subpathsAtPath:cachPath];
                       //                           for (NSString *fileName in fileNames) {
                       //                               NSString *absolutePath = [cachPath stringByAppendingPathComponent:fileName];
                       //                               [fileManager removeItemAtPath:absolutePath error:nil];
                       //                           }
                       //                       }
                       
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                   });
}

#pragma mark 统计缓存
///////统计缓存数据大小
-(float)getFilePath{
    //文件管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    unsigned long long cacheFolderSize = 0;
    
    //缓存路径
    //    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //    NSString *cacheDir = [cachePaths objectAtIndex:0];
    //    NSArray *cacheFileList;
    //    NSEnumerator *cacheEnumerator;
    //    NSString *cacheFilePath;
    //    unsigned long long cacheFolderSize1 = 0;
    
    //    cacheFileList = [fileManager subpathsOfDirectoryAtPath:cacheDir error:nil];
    //    cacheEnumerator = [cacheFileList objectEnumerator];
    //    while (cacheFilePath = [cacheEnumerator nextObject]) {
    //
    //        if ([cacheFilePath rangeOfString:kJiaJiaMobBabiesRobotsInformation].location != NSNotFound|| [cacheFilePath rangeOfString:kJiaJiaMobBabiesInformation].location != NSNotFound|| [cacheFilePath rangeOfString:kJiaJiaMobAccountInformation].location != NSNotFound ||[cacheFilePath rangeOfString:kAFPhotoDatabaseSubPath].location != NSNotFound || [cacheFilePath rangeOfString:kAFPhotoTempUploadFilesSubPath].location != NSNotFound) {
    //            continue;
    //        }
    //
    //        NSDictionary *cacheFileAttributes = [fileManager attributesOfItemAtPath:[cacheDir stringByAppendingPathComponent:cacheFilePath] error:nil];
    //        cacheFolderSize += [cacheFileAttributes fileSize];
    //    }
    
    //单位MB
    /*  另一种计数方法  */
    //
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    //    NSLog(@"NSCachesDirectory==files :%lu",(unsigned long)[files count]);
    for (NSString *p in files) {
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        NSDictionary *cacheFileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
        cacheFolderSize += [cacheFileAttributes fileSize];
    }
    
    
    return (float)cacheFolderSize/1024/1024;
}

-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
    [_tableView reloadData];
    [MBProgressHUD showSuccess:@"缓存已清除"];
    
}

-(void)getaboutUS{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_Iamage_HOST stringByAppendingString:client_clause_getClause];
    NSDictionary*dict = @{@"clauseType":@(2)};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:dict isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [MBProgressHUD hideActivityIndicator];
        NSArray * array = [responseObject objectForKey:@"data"] ;
        if (array.count ) {
            WKBaseWebViewController *vc = [[WKBaseWebViewController alloc] init];
            vc.headTitle = @"关于我们";
            vc.webStr = [[array objectAtIndex:0]objectForKey:@"content"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}
@end
