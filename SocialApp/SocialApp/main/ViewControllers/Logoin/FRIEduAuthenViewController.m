//
//  FRIEduAuthenViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 2/12/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "FRIEduAuthenViewController.h"
#import "LLRightCell.h"
#import "UIAlertController+Simple.h"
#import "WKBaseWebViewController.h"
#import "FWRPickerView.h"
#import "TZImagePickerController.h"
static NSString *const LLRightCellid = @"LLRightCell";

@interface FRIEduAuthenViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;/** <#class#> **/
@property (strong, nonatomic) IBOutlet UIView *LowView;

@property (nonatomic,assign) NSInteger type;/** 认证类型 **/
@property (nonatomic,assign) NSInteger CerType;/** 证明类型 **/
@property (nonatomic,assign) NSInteger Cerstatus;/** 学历状态 **/
@property (nonatomic,assign) NSInteger userEducation;/**学历 **/
@property (nonatomic,assign) NSString *userSchool;/**学校 **/


@property (nonatomic,assign) BOOL isRead;/** 是否已读须知 **/

@property (nonatomic,strong) FWRPickerView *pickerView;/** 选择器**/

@property (weak, nonatomic) IBOutlet UIButton *firstImageButton;
@property (weak, nonatomic) IBOutlet UIButton *secondImageButton;
@property (nonatomic,strong) UIImage *image1;/** 图片1**/
@property (nonatomic,strong) UIImage *image2;/** 图片2**/
@property (nonatomic,assign) NSInteger imageidnex;/** 图片排序**/
@property (nonatomic,retain) NSString* imageString;/** 图片排序**/

@property (nonatomic,retain) NSString* friendID;/** 好友认证**/


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cerTypeButtons;

@end

@implementation FRIEduAuthenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"学历认证";
    self.type = 1 ;
    self.CerType = 1 ;

    [self.view  addSubview:self.tableView];
    
}

- (FWRPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[FWRPickerView alloc] init];
        [self.view addSubview:_pickerView];
    }
    return _pickerView;
}
#pragma mark  懒加载
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = White_Color;
        [ _tableView  registerClass:[LLRightCell class] forCellReuseIdentifier:LLRightCellid];
//         [ _tableView  registerClass:[LLTobeUploadIDCell class] forCellReuseIdentifier:LLTobeUploadIDCellid];
//        [ _tableView  registerClass:[BSStoreTableViewCell class] forCellReuseIdentifier:BSStoreTableViewCellID];

    }
    return _tableView;
}
static NSString *const LLChargeDetailsCellID = @"LLChargeDetailsCell";

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        if (_type == 2) {
            return 2;
        }
        return 1;
    }
    return 4;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (  section==0) {
           return 0.01;
       }
    if (section==1) {
        if (_type==2) {
            return 198;
        }else{
            if (_CerType==1) {
                      return 465;
                  }
                return 606;
        }
    }
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 10;

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view =[[UIView alloc]init];
    view.backgroundColor = Main_BG_Color;
    
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view =[[UIView alloc]init];
    view.backgroundColor = White_Color;
    if ( section==0) {
        return nil;
    }
    
    if (section==1) {
        _LowView.top = 0;
        _LowView.width = SCREEN_WIDTH;
        [view addSubview:_LowView];
        
        if (_type==2) {
          _LowView.height = 198;
        }else{
            if (_CerType==1) {
                        _LowView.height = 465;
                       _secondImageButton.hidden = YES;
                   }else{
                       _LowView.height = 606;
                       _secondImageButton.hidden = NO;

                   }
        }
        return view;
    }
    return nil;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LLRightCell *cell = [tableView dequeueReusableCellWithIdentifier:LLRightCellid];
    
    cell.rightlable.hidden = YES;
    cell.showimage.hidden = YES;
    cell.titlelable.hidden = NO;
    cell.rightlable.hidden = NO;
     cell.textview.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray * array  = @[@"*姓名",@"*状态",@"*学历",@"*学校"];
   cell.rightlable.text = @"请选择";

    if (indexPath.section==0) {
        cell.titlelable.text = array[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
            {
                cell.textview.hidden = NO;
                 cell.textview.placeholder = @"请输入姓名";
                cell.textview.text = _name;
                cell.textview.enabled = NO;
                cell.rightlable.hidden = YES;
                cell.textview.tag = 10 ;
                [cell.textview addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

                cell.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 1:
                     {
                         NSArray *array =@[@"在读",@"已毕业"];
                         if (_Cerstatus) {
                             cell.rightlable.text = array[_Cerstatus-1];
                         }else{
                             cell.rightlable.text = @"请选择";
                             
                         }
                     }
            break;
            case 2:
                {
                    NSArray *array =@[@"大专以下",@"大专", @"本科", @"研究生", @"博士"];
                    if (_userEducation) {
                        cell.rightlable.text = array[_userEducation-1];
                    }else{
                        cell.rightlable.text = @"请选择";
                        
                    }

                    }
                break;
                
            default:
                break;
        }
        
    }else{
        if (indexPath.row==0) {
            cell.titlelable.text = @"*认证方式";
        }else{
            cell.titlelable.text = @"*好友ID或手机号码";
            cell.textview.hidden = NO;
            cell.textview.placeholder = @"请输入";
            cell.textview.text = _friendID;
            cell.rightlable.hidden = YES;
            cell.textview.tag = 11 ;

           cell.accessoryType = UITableViewCellAccessoryNone;
           [cell.textview addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        
    }
    
    return  cell;
}

- (void) textFieldDidChange:(UITextField *) TextField{
    
    NSLog(@"==string=%@",TextField.text);
    if (TextField.tag==11) {
        _friendID = TextField.text;
    }else{
        _name = TextField.text;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WS(weakself);
    if (indexPath.section==0) {
    
       if (indexPath.row==1) {
           [self.pickerView setupPickerStyle:pickerDataTypestatue];
           
           self.pickerView.backPickerIndex = ^(NSString * _Nonnull index) {
               weakself.Cerstatus = index.integerValue;
               [weakself.tableView reloadData];
           };
             [self.pickerView showPickerView];
           
           
      }else  if (indexPath.row==2) {
          [self.pickerView setupPickerStyle:pickerDataTypeEdu];
           self.pickerView.backPickerIndex = ^(NSString * _Nonnull index) {
               weakself.userEducation = index.integerValue;
               [weakself.tableView reloadData];

            };
        [self.pickerView showPickerView];
      }else  if (indexPath.row==3) {
               
    }
            
    }else{
        
       UIAlertController *sheet = [UIAlertController showSheetTitles:@[@"资料认证", @"好友证明"] titleColor:Main_Color cancelColor:Sub_title_Color backIndex:^(UIAlertAction * _Nonnull UIAlertAction, NSInteger index) {
           self.type = index+1;
           [self.tableView reloadData];
       }];
        [self presentViewController:sheet animated:YES completion:nil];

    }
    
}
- (IBAction)selectCer:(UIButton *)sender {
    
    for (UIButton *btn in _cerTypeButtons) {
        btn.selected = NO;
    }
    sender.selected = YES;;
    _CerType = sender.tag-9;
    NSLog(@"===%D",_CerType);
    
    [self.tableView reloadData];
}

- (IBAction)uploadCerPic:(UIButton *)sender {
    
    if (sender.tag == 10) {
        _imageidnex = 1;
    }else{
       _imageidnex = 2;
    }
    [self addHeaderImage];
}
- (IBAction)explameImage:(UIButton *)sender {
    
}
- (IBAction)submitInfo:(UIButton *)sender {

    
    if (_Cerstatus<1) {
      [MBProgressHUD showError:@"请选择学历状态!"];  return;
    }
    if (_userEducation<1) {
        [MBProgressHUD showError:@"请选择学历!"];  return;
      }
    if (_friendID.length<1) {
        [MBProgressHUD showError:@"请输入好友ID或手机号!"];  return;
    }
     
    
    if (_type==2) {
        [self submintCerInfo];
    }else{
        if (_image1==nil) {
            [MBProgressHUD showError:@"请上传证书"];  return;
        }
        if (_CerType!=1 && _image2==nil) {
            [MBProgressHUD showError:@"请上传证书正反面"];  return;
        }
        NSData *imageData = UIImageJPEGRepresentation(_image1,1.0f);//
        [self loadImageOfID:imageData];
    }
    
}
- (IBAction)goWay:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)selectServer:(UIButton *)sender {
    
    if (sender.tag==10) {
        sender.selected = !sender.selected;
        _isRead  = sender.selected;
    }else{
//        [self getHelpCenter];
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
            tzimagePickerController.needCircleCrop = YES;
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


#pragma mark -- TZImagePickerController delegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    if (_imageidnex==1) {
        _image1 = [NSMutableArray arrayWithArray:photos].firstObject;
        [_firstImageButton setImage:_image1 forState:UIControlStateNormal];
    }else{
    _image2 = [NSMutableArray arrayWithArray:photos].firstObject;
        [_secondImageButton setImage:_image2 forState:UIControlStateNormal];
    }
//    self.images = [NSMutableArray arrayWithArray:photos];
//    self.assetArray = [NSMutableArray arrayWithArray:assets];
//    [self upLoadImage];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
   
    if (_imageidnex==1) {
           _image1 = @[info[UIImagePickerControllerEditedImage]].firstObject;
        [_firstImageButton setImage:_image1 forState:UIControlStateNormal];
       }else{
       _image2 =  @[info[UIImagePickerControllerEditedImage]].firstObject;
        [_secondImageButton setImage:_image2 forState:UIControlStateNormal];
       }
//    self.images = [@[info[UIImagePickerControllerEditedImage]] mutableCopy];
//    [self upLoadImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}



-(void)submintCerInfo{
    
    NSString *path = [API_HOST stringByAppendingString:client_education];
    NSMutableDictionary * diciton = [NSMutableDictionary dictionaryWithCapacity:20];
      
      [diciton setValue:@(_Cerstatus) forKey:@"educationStatus"];   //学历状态 1:在读 2:已毕业
      [diciton setValue:@(_type) forKey:@"userCertification"];  // 用户认证方式 1:审核认证，2好友担保
      [diciton setValue:@(_userEducation) forKey:@"userEducation"];     //学历
      [diciton setValue:@"北京大学" forKey:@"userSchool"];      //学校

      if (_type==2) {
          [diciton setValue:_friendID forKey:@"certificationUser"]; //好友ID或手机号

      }else{
          [diciton setValue:_imageString forKey:@"materialImg"];   //资料照片
          [diciton setValue:@(_CerType) forKey:@"materialType"];  //资料类型 1:毕业证/ 2:学生证照片/ 3:一卡通
      }
      
    
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diciton isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}

-(void)loadImageOfID:(NSData*)IDImage{
    
    NSString *path = [API_HOST stringByAppendingString:common_iamge];
    WS(weakself);
    
    [MBProgressHUD showActivityIndicator];

    [HttpEngine httpRequestWithResquestImagePath:IDImage imageSuffix:@".jpg" url:path params:nil isToken:YES errorDomain:nil errorString:nil success:^(CGFloat progress) {
        NSLog(@"=progress==%f",progress);
    } success:^(id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        if (weakself.CerType==1) {
            weakself.imageString = responseObject[@"name"];
            [self submintCerInfo];

        }else{
            if (weakself.imageString) {
                weakself.imageString = [NSString stringWithFormat:@"%@,%@",weakself.imageString,responseObject[@"name"]];
                [self submintCerInfo];
            }else{
                weakself.imageString = responseObject[@"name"];
                NSData *imageData = UIImageJPEGRepresentation(weakself.image2,1.0f);//
                [weakself loadImageOfID:imageData];
                return ;
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"=error==%@",error);
        NSDictionary * diction =error.userInfo;
        [MBProgressHUD showError:diction[@"message"]];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)getHelpCenter{
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_Iamage_HOST stringByAppendingString:@"身份认证"];
    NSDictionary*dict = @{@"clauseType":@(5)};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:dict isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [MBProgressHUD hideActivityIndicator];
        NSArray * array = [responseObject objectForKey:@"data"] ;
        if (array.count ) {
            WKBaseWebViewController *vc = [[WKBaseWebViewController alloc] init];
            vc.headTitle = @"帮助中心";
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
