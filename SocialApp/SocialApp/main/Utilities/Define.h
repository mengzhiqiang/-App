//
//  Define.h
//  tp_self_help
//
//  Created by cloudpower on 13-7-22.
//  Copyright (c) 2013年 cloudpower. All rights reserved.
//


#define id_certificateNo    @"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}((19\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|(19\\d{2}(0[13578]|1[02])31)|(19\\d{2}02(0[1-9]|1\\d|2[0-8]))|(19([13579][26]|[2468][048]|0[48])0229))\\d{3}(\\d|X|x)?$"


#define EMAILE_ZH  @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"  ///邮箱正则
#define NickName_ZH  @"[a-zA-Z0-9\u4e00-\u9fa5]+$"   //// 只含有汉字、数字、字母


#define PASSWORKZ_ZH  @"[A-Za-z0-9_]{6,40}"
#define  PHONE  @"(0[0-9]{2,3})+([2-9][0-9]{6,7})"
#define  phone_zh @"^[1][3-8]+\\d{9}"

#define isPAD_or_IPONE4  (iPhone4Retina ||isPad)

// 该方法不能识别出ipad [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
// 暂用该方法判断是否为ipad
#define isPad (([[UIScreen mainScreen] currentMode].size.width/[[UIScreen mainScreen] currentMode].size.height==(float)3/4) && SCREEN_WIDTH !=375.0)

#define iPhone4Retina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6         (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)||(SCREEN_HEIGHT==667.0 &&SCREEN_WIDTH==375.0))

#define iPhone6plus        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)


#define  IS_X_ ((IS_IPHONE_X||IS_IPHONE_Xr||IS_IPHONE_Xs_Max)?YES:NO)


#define  DCTopNavH ((IS_X_)?88:64)

#define IsPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

///尺寸比率
#define  RATIO  (SCREEN_WIDTH/320)
#define  RATIO_IPHONE6  (SCREEN_WIDTH/375)
#define SCREEN_top    ((IS_X_)?88:64)
#define iphoneXTop    ((IS_X_)?24:0)

#define iphoneXTab    ((IS_X_)?34:0)

#define  Landscape_RATIO  (SCREEN_HEIGHT/320)
#define kNavHeight SCREEN_top


#define FontSize(size) [UIFont systemFontOfSize:CGFloatBasedI375(size)]

//-------------------适配-------------------------
UIKIT_STATIC_INLINE CGFloat CGFloatBasedI375(CGFloat size) {
    // 对齐到2倍数
    return trunc(size * UIScreen.mainScreen.bounds.size.width / 375 * 2) / 2.0;
}

#define DefluatPic @"img_smrz"
#define URL(path)  ([path hasPrefix:@"http"]?path:[NSString stringWithFormat:@"%@/%@",API_HOST,path])
#define UIImageName(name) [UIImage imageNamed:name]

//BLOCK相关
#define WEAKSELF_new    @weakify(self)
#define STRONGSELF  @strongify(self)

/********** 颜色 **********/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


/** 主颜色 */
#define Main_Color [UIColor colorWithHexString:@"#1A9DC7"]
/** 主文字颜色 */
#define Main_title_Color [UIColor colorWithHexString:@"#333333"]
#define Sub_title_Color [UIColor colorWithHexString:@"#999999"]
/** 主背景颜色 */
#define Main_BG_Color [UIColor colorWithHexString:@"#F7F9FC"]

/** 浅蓝色 */
#define LightBlue_Main_Color UIColorFromRGB(0x18C2EF)
/** 草绿色 在线状态 */
#define GrassGreen_Color UIColorFromRGB(0xB6DB19)
/** 教师端主色调 */
#define TeacherMain_Color UIColorFromRGB(0x79C108)
/** 黑色 */
#define Black_Color UIColorFromRGB(0x3B3E40)
/** 黑色(按钮) */
#define Black_Button_Color UIColorFromRGB(0x575966)
/** 红色 */
#define Red_Color UIColorFromRGB(0xFF0000)
/** 白色 */
#define White_Color UIColorFromRGB(0xffffff)
/** 导航条 浅白色 */
#define LightWhite_Color UIColorFromRGB(0xf6f6f6)
/** 浅蓝 */
#define LightBlue_Color UIColorFromRGB(0xD0E6EB)
/** 深蓝 */
#define Blue_Color UIColorFromRGB(0xACCDD9)
/** 字体灰色 */
#define FontGray_Color UIColorFromRGB(0xABABAB)
/** 浅灰色 */
#define LightGray_Color UIColorFromRGB(0xE8E8E8)
/** 线条灰色 */
#define LineGray_Color UIColorFromRGB(0xEFEFEF)
/** 按钮深灰 */
#define DarkGray_Color UIColorFromRGB(0x97948C)
/** 灰色边框色 */
#define BorderGray_Color  [[UIColor grayColor]CGColor]

//#define bgColor [UIColor colorWithHexString:@"#F5F5F5"]
/** 字体橘色 */
#define textOrange_Color [UIColor colorWithHexString:@"#FFAE00"]

#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Medium" : @"PingFang SC"

#define PFR20Font [UIFont fontWithName:PFR size:20];
#define PFR19Font [UIFont fontWithName:PFR size:19];
#define PFR16Font [UIFont fontWithName:PFR size:16];
#define PFR15Font [UIFont fontWithName:PFR size:15];
#define PFR14Font [UIFont fontWithName:PFR size:14];
#define PFR13Font [UIFont fontWithName:PFR size:13];
#define PFR12Font [UIFont fontWithName:PFR size:12];
#define PFR11Font [UIFont fontWithName:PFR size:11];
#define PFR10Font [UIFont fontWithName:PFR size:10];
#define PFR9Font [UIFont fontWithName:PFR size:9];
#define PFR8Font [UIFont fontWithName:PFR size:8];

#define rgba(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define WS(weakself) __weak __typeof(&*self)weakself = self

#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define BUNDLE_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

#define FORMAT(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]


#define ScreenRect                          [[UIScreen mainScreen] bounds]

#define IOS7 if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))\
{self.edgesForExtendedLayout=UIRectEdgeNone;\
self.navigationController.navigationBar.translucent = NO;}

#define HKColor(string) [UIColor HexString:string]
#define RECT(x,y,witdh,height) CGRectMake(x, y, witdh, height)

