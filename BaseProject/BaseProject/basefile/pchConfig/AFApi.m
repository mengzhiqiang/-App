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
//NSString * const API_HOST                    = @"http://lingmahui-vip.com:801";
//NSString * const API_Iamage_HOST             = @"http://lingmahui-vip.com:802";
//NSString * const API_LogisticsInfo_HOST      = @"http://lingmahui-vip.com:803";

///c测试
NSString * const API_HOST                    = @"http://120.79.203.119:801";
NSString * const API_Iamage_HOST             = @"http://120.79.203.119:802";
NSString * const API_LogisticsInfo_HOST      = @"http://120.79.203.119:803";


//NSString * const API_HOST                   = @"http://192.9.200.142:801";
//NSString * const API_Iamage_HOST             = @"http://192.9.200.123:802";

NSString * const API_shareUrl    = @"http://lingmahui-vip.com:801/views/user/regiest.html?inviteCode="; ///分享链接

NSString * const WX_APPID     = @"wxc4774ddab45904bf";                          //微信=ppid
NSString * const WX_APPsecret = @"2f2b4cbdfbd4952531d036df26a82b27";            //微信=secret

NSString * const ALIPAY_APPID = @"";                // 支付宝AppID
NSString * const  buglyID = @"fa28f6ae2f";            // buglY

NSString * const  mobTechKey    = @"2c681ea4e4acb";
NSString * const  mobTechSeret  = @"2be9ac6c2a786ceff9bcac9a5c0f5a6c";

NSString * const  QQ_APPKey     = @"1109813183";
NSString * const  QQ_APPSeret   = @"OQpktmKLsvLJrxT";

NSString * const  sina_APPKey   = @"2c681ea4e4acb";
NSString * const  sina_APPSeret = @"2be9ac6c2a786ceff9bcac9a5c0f5a6c";

//生产环境
//NSString * const API_HOST = @"https://lapi.oduola.com";
//NSString * const NTE_cerName = @"lediDistribution";                    //云信证书名称
//NSString * const NTES_APP_KEY = @"d9d6e917ea9699ee4fe588d8948b545e";   //云信key

#pragma mark -  MOB API

NSString * const  account_code             = @"/client/security/getCode";         //发送验证码
NSString * const  account_login            = @"/client/login";                    //创建帐号 登录账号
NSString * const  client_weChatLogin       = @"/client/weChatLogin";              //微信登录
NSString * const  client_weChatLoginBand   = @"/client/WeChatBind";               //微信绑定
NSString * const  client_register          = @"/client/register";                 //注册码注册


NSString * const  client_home_classify      = @"/client/home/getClassify";             //获取分类
NSString * const  client_home_getHomeList   = @"/client/home/getHomeList";             //获取分类布局
NSString * const  client_home_getMoreBrand   = @"/client/home/getMoreBrand";           //获取分类布局
NSString * const  client_goods_getGoodsDetail   = @"/client/goods/getGoodsDetail";           //获取商品详情

NSString * const  client_bands_brandDetail   = @"/client/brand/getBrandDetailById";      //获取品牌详情
NSString * const  client_bands_getActivityDetails   = @"/client/home/getActivityDetails";      //获取活动详情

NSString * const  client_search_getHotSearch   = @"/client/search/getHotSearch";          //热门搜索
NSString * const  client_search_toSearch       = @"/client/search/toSearch";              //关键字获取商品列表
NSString * const client_home_getLeftTotalBrand    = @"/client/home/getLeftTotalBrand";      //左边预告

/**
 地址管理接口
 */
NSString * const client_addAddress           = @"/client/address/updateAddress";                    //地址 添加
NSString * const client_getAddresses         = @"/client/address/getAddressList";                   //地址 获取
NSString * const client_deleteAddresses      = @"/client/address/deleteAddresses";                  //地址 删除
NSString * const client_putddresses          = @"/client/address/updateAddress";                    //地址 修改

NSString * const wxpay_prepay             = @"/client/wxpay/appPay";                  // 微信预支付接口
NSString * const ALiaPay_prepay           = @"/client/alipay/appPay";                  //  支付宝预支付接口

NSString * const client_cart_addCart      = @"/client/cart/addCart";               //  添加购物车
NSString * const client_cart_deleteCart      = @"/client/cart/deleteCart";          //  删除购物车
NSString * const client_cart_getCarts      = @"/client/cart/getCarts";              //  获取购物车

/**
 订单接口
 */
NSString * const client_order_getPostage         = @"/client/order/getPostage";               //  获取全局运费
NSString * const client_order_getOrderCount      = @"/client/order/getOrderCount";            //  根据购物车id获取运费
NSString * const client_order_submitOrder        = @"/client/order/submitOrder";              //  提交订单
NSString * const client_order_getOrderList       = @"/client/order/getOrderList";             //  订单列表
NSString * const client_order_getOrderDetail     = @"/client/order/getOrderDetail";           //  订单详情
NSString * const gt100_getLogisticsInfo          = @"/gt100/getLogisticsInfo";                //  物流信息查询

NSString * const client_order_cancelOrder     = @"/client/order/cancelOrder";             // 取消订单
NSString * const client_order_confirmOrder    = @"/client/order/confirmOrder";            // 确认收货
NSString * const client_order_deleteOrder     = @"/client/order/deleteOrder";             // 删除订单

/**售后*/
NSString * const client_order_submitAfterSales     = @"/client/afterSales/submitAfterSales";        //提交退货
NSString * const client_order_getAfterSalesDetails = @"/client/afterSales/getAfterSalesDetails";    //查询售后信息
NSString * const client_order_getAfterOrderList   = @"/client/order/getAfterOrderList";  //获取可售后列表
NSString * const client_afterSales_getAfterOrderList     = @"/client/afterSales/getAfterOrderList";      //获取售后记录


/**个人中心*/
NSString * const client_order_getRegisterCodes     = @"/client/setting/getRegisterCodes";        //注册码
NSString * const client_order_getMyAccount         = @"/client/account/getMyAccount";             //获取个人中心数据
NSString * const client_order_getTeamCenter        = @"/client/statistics/getTeamCenter";         //团队中心统计销售额
NSString * const client_order_getTurnoverByUserId  = @"/client/statistics/getTurnoverByUserId";   //一级用户销售额
NSString * const client_roleLevel_getRoleLevelDetails  = @"/client/roleLevel/getRoleLevelDetails";   //会员等级

NSString * const client_order_getPerformance       = @"/client/record/getPerformance";             //根据用户id获取业绩记录
NSString * const client_order_getTouchBalance      = @"/client/account/getTouchBalance";           //获取余额明细

NSString * const client_userManager_getPersonalCenter   = @"/client/userManager/getPersonalCenter";           //个人中心数据集合

NSString * const client_account_getMyAccount       = @"/client/account/getMyAccount";             //个人信息获取
NSString * const client_userManager_eidtUser       = @"/client/userManager/eidtUser";             //个人信息编辑
NSString * const client_upload_uploadPortrait      = @"/admin/setting/uploadOSSImage";             //上传头像
NSString * const client_opinion_addOpinion         = @"/client/opinion/addOpinion";             //意见反馈
NSString * const client_clause_getClause           = @"/admin/clause/getClause";             //协议规则

//库直播
NSString * const app_Broadcast_list        = @"/app/Broadcast/getIndexAppBroadcastListOrDetail";  //直播列表
NSString * const app_Broadcast_WonderList  = @"/app/Broadcast/getIndexAppWonderfulBroadcastList";  //直播预告
NSString * const app_Broadcast_Detail      = @"/app/Broadcast/getIndexAppBroadcastDetail";  //直播详情

NSString * const app_ShortVideo_List       = @"/app/ShortVideo/getVideoShortVideoList";     //短视频
NSString * const app_ShortVideo_detail     = @"/app/ShortVideo/getVideoShortVideoListDetail"; //短视频详情

