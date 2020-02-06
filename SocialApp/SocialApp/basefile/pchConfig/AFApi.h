//
//  AFApi.h
//  AFjettMob
//
//  Created by singelet on 16/7/21.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kSmartDeviceLoginTokenKey ;     //TOKEN 存储
extern NSString * const kGoodShareAddPirceKey;     //加价存储


#pragma mark - ServerAddress

extern NSString * const API_HOST;                    //测试
extern NSString * const API_Iamage_HOST;
extern NSString * const API_LogisticsInfo_HOST;

extern NSString * const API_shareUrl;               ///分享链接


extern NSString * const AMAP_apiKey;         // 高德地图KEY

extern NSString * const WX_APPID;                     //微信=ppid
extern NSString * const WX_APPsecret;                 //微信=secret
extern NSString * const ALIPAY_APPID;                 // 支付宝AppID

extern NSString * const  buglyID;               // bugly

extern NSString * const  mobTechKey;
extern NSString * const  mobTechSeret;

#pragma mark - MOB API


extern NSString * const  account_code;                        //发送验证码 GET  校验验证码
extern NSString * const  account_register;                    //注册
extern NSString * const  account_login;                       //创建帐号 POST

extern NSString * const  client_attestation ;              //实名认证
extern NSString * const  client_education;                 //学历认证


/**
 公共类
*/
extern NSString * const  common_iamge ;                 //上传图片
extern NSString * const  common_reglation;                 //规则中心

/**
选项类型 1:兴趣特征类型,2:期望及所属标签,3:遇见自己活动类型,4:预约失败原因（商家端对用户的活动订单的取消）,5:年龄层次,6:活动类型
 */
extern NSString * const  common_select;                 //选项管理
extern NSString * const  common_phone;                 //客服电话


/**
 友趣
 */
extern NSString * const  youFun_merchant;                 //获取商家列表 商家详情
extern NSString * const  youFun_SQActivity;               //广场活动
extern NSString * const  youFun_commodity;                // 商家商品-商品详情
extern NSString * const  youFun_activity;                 //商家详情里面 - 活动列表
extern NSString * const  youFun_activityDetail;           //活动详情
extern NSString * const  youFun_evaluate;                 //获取用户评论

extern NSString * const  youFun_search;                       //搜索

extern NSString * const  youFun_addActivity;                 //参加活动
extern NSString * const  youFun_setActivity ;                //发起活动
extern NSString * const  youFun_setFeedback ;                //商家反馈



extern NSString * const  kUploadImage ;


/**个人中心*/




