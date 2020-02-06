//
//  AFApi.m
//  AFjettMob
//
//  Created by singelet on 16/7/21.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFApi.h"

/*
 API 地址
 生产环境版访问协议为https  @"https://lapi.oduola.com";      ///生产
 测试开发版访问协议为http   @"http://api.ledi.oduola.com";   /// 测试
 
 */

#pragma mark - ServerAddress

//#ifdef RELEASE_jettMOB_DEVELOP
////开发环境
//NSString * const API_HOST = @"https://rsdb.oduola.com";
//
//#elif RELEASE_jettMOB_TEST
//
////测试环境
//NSString * const API_HOST = @"https://rsdb.oduola.com";
//
//#elif RELEASE_jettMOB_PRODUCTION
//
////生产环境 生产包域名
//NSString * const API_HOST = @"https://rapi.oduola.com";
//
//#endif

NSString * const kSmartDeviceLoginTokenKey = @"DeviceLoginTokenKey" ;     //TOKEN 存储
NSString * const kGoodShareAddPirceKey = @"AddPrice" ;     //加价存储

//生产
NSString * const API_HOST                    = @"http://120.78.204.199:8091";
NSString * const API_Iamage_HOST              = @"http://120.78.204.199:8091";
//NSString * const API_LogisticsInfo_HOST      = @"http://lingmahui-vip.com:803";

///c测试
//NSString * const API_HOST                    = @"http://192.9.200.14:8091";
//NSString * const API_Iamage_HOST             = @"http://192.9.200.14:8091";
//NSString * const API_LogisticsInfo_HOST      = @"http://120.79.203.119:803";


//NSString * const API_HOST                   = @"http://192.9.200.142:801";
//NSString * const API_Iamage_HOST             = @"http://192.9.200.123:802";

NSString * const AMAP_apiKey  = @"b000b9b23084e018246bdf85f2b95b31";         // 高德地图KEY

NSString * const WX_APPID     = @"wxc4774ddab45904bf";                          //微信=ppid
NSString * const WX_APPsecret = @"2f2b4cbdfbd4952531d036df26a82b27";            //微信=secret

NSString * const  ALIPAY_APPID = @"";                // 支付宝AppID
NSString * const  buglyID = @"4933841625";            // buglY

NSString * const  mobTechKey    = @"2c681ea4e4acb";
NSString * const  mobTechSeret  = @"2be9ac6c2a786ceff9bcac9a5c0f5a6c";


//生产环境
//NSString * const API_HOST = @"https://lapi.oduola.com";
//NSString * const NTE_cerName = @"lediDistribution";                    //云信证书名称
//NSString * const NTES_APP_KEY = @"d9d6e917ea9699ee4fe588d8948b545e";   //云信key

#pragma mark -  MOB API


NSString * const  account_code             = @"/app/login/get/verification/code";         //发送验证码
NSString * const  account_login            = @"/app/login";                    //创建帐号 登录账号
NSString * const  account_register         = @"/app/login/register";


NSString * const  client_attestation          = @"/app/login/autonym";                 //实名认证
NSString * const  client_education          = @"/app/login/education";                 //学历认证

/**
 公共类
*/
NSString * const  common_iamge          = @"/common/img";                 //上传图片
NSString * const  common_reglation          = @"/common/reglation";                 //规则中心
NSString * const  common_select          = @"/common/select";                 //选项管理 选项类型 1:兴趣特征类型,2:期望及所属标签,3:遇见自己活动类型,4:预约失败原因（商家端对用户的活动订单的取消）,5:年龄层次,6:活动类型
NSString * const  common_phone          = @"/common/service/phone";                 //客服电话





/**
 友趣
 */
NSString * const  youFun_merchant           = @"/app/youfun/get/merchant";                 //获取商家列表 商家详情
NSString * const  youFun_SQActivity         = @"/app/youfun/youqu/activity";               //广场活动
NSString * const  youFun_commodity          = @"/app/youfun/get/commodity";                // 商家商品-商品详情
NSString * const  youFun_activity           = @"/app/youfun/get/activity";                 //商家详情里面 - 活动列表
NSString * const  youFun_activityDetail     = @"/app/youfun/get/activity/detail";          //活动详情
NSString * const  youFun_evaluate           = @"/app/youfun/get/evaluate";                 //获取用户评论

NSString * const  youFun_search             = @"/app/youfun/search";                       //搜索

NSString * const  youFun_addActivity          = @"/app/youfun/add/activity";                 //参加活动
NSString * const  youFun_setActivity          = @"/app/youfun/set/activity";                 //发起活动
NSString * const  youFun_setFeedback          = @"/app/youfun/set/feedback";                 //商家反馈
NSString * const  kUploadImage                  = @"/common/img";              



/**个人中心*/

