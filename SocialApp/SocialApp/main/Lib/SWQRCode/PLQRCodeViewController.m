//
//  PLQRCodeViewController.m
//  PieLifeApp
//
//  Created by libj on 2019/7/31.
//  Copyright © 2019 Libj. All rights reserved.
//

#import "PLQRCodeViewController.h"
#import "SWScannerView.h"
#import "SOCAccountTools.h"
//#import "PLQRCodeSucceedController.h"

@interface PLQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/** 扫描器 */
@property (nonatomic, strong) SWScannerView *scannerView;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIButton *slightbtn;
@property (nonatomic,strong) UIView *backbuView;

@property (nonatomic,strong) UIImageView *showimage;

@end

@implementation PLQRCodeViewController{
    BOOL _isclick;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (SWScannerView *)scannerView
{
    if (!_scannerView) {
        _scannerView = [[SWScannerView alloc]initWithFrame:CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top) config:_codeConfig];;
    }
    return _scannerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseAttribute];
}

- (void) setBaseAttribute {
    self.customNavBar.title = @"扫一扫";
    [self _setupUI];
    _isclick = NO;
    [self setLayout];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPicking:) name:@"PreviewPhotoSureActionNotification" object:nil];
}

#pragma mark ============= 布局 =============
-(void)setLayout{
    WS(weakself);
    [self.backbuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(CGFloatBasedI375(60));
        //        make.height.offset(CGFloatBasedI375(60));
        make.bottom.offset(CGFloatBasedI375(-60));
        make.centerX.equalTo(weakself.view.mas_centerX);
    }];
    [self.showimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(CGFloatBasedI375(45));
        make.height.offset(CGFloatBasedI375(45));
        make.top.equalTo(weakself.backbuView).offset(CGFloatBasedI375(10));
        make.centerX.equalTo(weakself.backbuView.mas_centerX);
    }];
   
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    //    self.navigationController.navigationBar.barTintColor = MainColor;
    [super viewWillAppear:animated];
    [self resumeScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.scannerView sw_setFlashlightOn:NO];
    [self.scannerView sw_hideFlashlightWithAnimated:YES];
}

- (void)_setupUI {
    
    self.view.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *albumItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(showAlbum)];
    [albumItem setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = albumItem;
    
    [self.view addSubview:self.scannerView];
    
    // 校验相机权限
    [SWQRCodeManager sw_checkCameraAuthorizationStatusWithGrand:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _setupScanner];
            });
        }
    }];
}

/** 创建扫描器 */
- (void)_setupScanner {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if (self.codeConfig.scannerArea == SWScannerAreaDefault) {
        metadataOutput.rectOfInterest = CGRectMake([self.scannerView scanner_y]/self.view.frame.size.height, [self.scannerView scanner_x]/self.view.frame.size.width, [self.scannerView scanner_width]/self.view.frame.size.height, [self.scannerView scanner_width]/self.view.frame.size.width);
    }
    
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
    if ([self.session canAddOutput:metadataOutput]) {
        [self.session addOutput:metadataOutput];
    }
    if ([self.session canAddOutput:videoDataOutput]) {
        [self.session addOutput:videoDataOutput];
    }
    
    metadataOutput.metadataObjectTypes = [SWQRCodeManager sw_metadataObjectTypesWithType:self.codeConfig.scannerType];
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    videoPreviewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:videoPreviewLayer atIndex:0];
    
    [self.session startRunning];
}

- (void)didFinishPicking:(NSNotification *)notification {
    NSDictionary *dict = (NSDictionary *) [notification object];
    NSLog(@"%@",[notification object]);
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    // 获取选择图片中识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(dict[@"image"])]];
    if (features.count > 0) {
        CIQRCodeFeature *feature = features[0];
        NSString *stringValue = feature.messageString;
        [self pauseScanning];
        [self sw_handleWithValue:stringValue];
    }
    else {
        [self pauseScanning];
        [self sw_didReadFromAlbumFailed];
    }
}
#pragma mark -- 跳转相册
- (void)imagePicker {
   
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // 获取扫一扫结果
    if (metadataObjects && metadataObjects.count > 0) {
        
        [self pauseScanning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *stringValue = metadataObject.stringValue;
        
        [self sw_handleWithValue:stringValue];
    }
}

#pragma mark -- AVCaptureVideoDataOutputSampleBufferDelegate
/** 此方法会实时监听亮度值 */
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    
    // 亮度值
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    if (![self.scannerView sw_flashlightOn]) {
        if (brightnessValue < -4.0) {
            [self.scannerView sw_showFlashlightWithAnimated:YES];
        }else
        {
            [self.scannerView sw_hideFlashlightWithAnimated:YES];
        }
    }
    
    
}

- (void)showAlbum {
    
    // 校验相册权限
    [SWQRCodeManager sw_checkAlbumAuthorizationStatusWithGrand:^(BOOL granted) {
        if (granted) {
            [self imagePicker];
        }
    }];
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    // 获取选择图片中识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(pickImage)]];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (features.count > 0) {
            CIQRCodeFeature *feature = features[0];
            NSString *stringValue = feature.messageString;
            [self pauseScanning];
            [self sw_handleWithValue:stringValue];
        }
        else {
            [self pauseScanning];
            [self sw_didReadFromAlbumFailed];
        }
    }];
}

#pragma mark -- App 从后台进入前台
- (void)appDidBecomeActive:(NSNotification *)notify {
    [self resumeScanning];
}

#pragma mark -- App 从前台进入后台
- (void)appWillResignActive:(NSNotification *)notify {
    [self pauseScanning];
}

/** 恢复扫一扫功能 */
- (void)resumeScanning {
    if (self.session) {
        [self.session startRunning];
        [self.scannerView sw_addScannerLineAnimation];
    }
}


/** 暂停扫一扫功能 */
- (void)pauseScanning {
    if (self.session) {
        [self.session stopRunning];
        [self.scannerView sw_pauseScannerLineAnimation];
    }
}

#pragma mark -- 扫一扫API
/**
 处理扫一扫结果
 @param value 扫描结果
 */
- (void)sw_handleWithValue:(NSString *)value {
    NSLog(@"sw_handleWithValue === %@", value);
    
//
//    NSDictionary *params = [self parameterWithURL:[NSURL URLWithString:url]];
    NSArray * array = [value componentsSeparatedByString:@"&"];
    if (array.count>=2) {
        [self attendanceGamesWithDic:array];
        [[SOCAccountTools shareSOCAccountTool] SocjoinGroup:@"" accessoryStyle:1 completion:^(NSString * _Nonnull result) {
            
            if (!result) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
     }else{
         [MBProgressHUD showError:@"请扫描群组二维码！"];
     }

    /** 退出界面 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.navigationController popViewControllerAnimated:YES];

    });
}

#pragma mark 扫描二维码签到
- (void)attendanceGamesWithDic:(NSArray*)array {
    
//    NSString *url = FORMAT(@"%@%@",API_HOST,client_competitioncheckIn);

    NSMutableDictionary * diction = [NSMutableDictionary dictionaryWithCapacity:20];
    
//    [diction setObject:(_gameId?_gameId:@"") forKey:@"id"];
    if (array.count>=2) {
        [diction setObject:array.firstObject forKey:@"id"];
//        [diction setObject:array[1] forKey:@""];
    }else{
        
    }
    [HttpEngine requestPostWithURL:nil params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        [AFAlertViewHelper alertViewWithTitle:@"签到成功" message:@"请核对好用户信息" delegate:self cancelTitle:@"确定" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
            
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"error=%@",error);
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        [MBProgressHUD showError:userInfo[@"message"]];
    }];
}

-(NSDictionary *)parameterWithURL:(NSURL *) url {
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    
    return parm;
}



- (void) bakcClick {
    [self resumeScanning];
}
/**
 相册选取图片无法读取数据
 */
- (void)sw_didReadFromAlbumFailed {
    NSLog(@"sw_didReadFromAlbumFailed");
    //    [MBProgressHUD showError:@"没有该用户哦"];
  
    
}
-(UIView *)backbuView{
    if(!_backbuView){
        _backbuView = [[UIView alloc]init];
        //        _backbuView.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.2];
        //        _imagebaView.layer.masksToBounds = YES;
        //        _imagebaView.layer.cornerRadius  = 10;
        _backbuView.userInteractionEnabled = YES;
        [self.view addSubview:self.backbuView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        [self.backbuView addGestureRecognizer:tap];
        
    }
    return _backbuView;
}
-(void)click{
    if(_isclick == YES){
        _isclick = NO;
        [SWQRCodeManager sw_FlashlightOn:NO];
        self.showimage.image = [UIImage imageNamed:@"main_btn_light_default"];
    }else{
        _isclick = YES;
        [SWQRCodeManager sw_FlashlightOn:YES];
        self.showimage.image = [UIImage imageNamed:@"main_btn_light_pressed"];
    }
    
}
- (UIImageView *)showimage{
    if(!_showimage){
        _showimage = [[UIImageView alloc]init];
        _showimage.image = [UIImage imageNamed:@"main_btn_light_default"];
        _showimage.userInteractionEnabled = YES;
        [self.backbuView addSubview:self.showimage];
    }
    return _showimage;
}



@end
