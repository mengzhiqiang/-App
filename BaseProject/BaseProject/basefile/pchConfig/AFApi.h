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


extern NSString * const WX_APPID;                     //微信=ppid
extern NSString * const WX_APPsecret;                 //微信=secret
extern NSString * const ALIPAY_APPID;                 // 支付宝AppID

extern NSString * const  buglyID;               // bugly

extern NSString * const  mobTechKey;
extern NSString * const  mobTechSeret;

extern NSString * const  QQ_APPKey;
extern NSString * const  QQ_APPSeret;

extern NSString * const  sina_APPKey;
extern NSString * const  sina_APPSeret;

#pragma mark - MOB API
extern NSString * const  account_code;                        //发送验证码 GET  校验验证码 POST
extern NSString * const  account_login;                       //创建帐号 POST
extern NSString * const  client_weChatLogin;                  //微信登录
extern NSString * const  client_weChatLoginBand;              //微信绑定
extern NSString * const  client_register;                    //注册码注册

extern NSString * const  client_home_classify;                //获取分类
extern NSString * const  client_home_getHomeList;             //获取分类布局
extern NSString * const  client_home_getMoreBrand;            //获取分类布局
extern NSString * const  client_goods_getGoodsDetail;           //获取商品详情

extern NSString * const  client_bands_brandDetail;            //获取品牌详情
extern NSString * const  client_bands_getActivityDetails;      //获取活动详情
extern NSString * const  client_goods_getGoodsDetail;          //获取商品详情

extern NSString * const  client_search_getHotSearch;          //热门搜索
extern NSString * const  client_search_toSearch;              //关键字获取商品列表
extern NSString * const client_home_getLeftTotalBrand ;       //左边预告


/**
 地址管理接口
 */
extern NSString * const client_addAddress;                 //地址 添加
extern NSString * const client_getAddresses;               //地址 获取
extern NSString * const client_deleteAddresses;            //地址 删除
extern NSString * const client_putddresses;                //地址 修改

extern NSString * const wxpay_prepay;                      // 微信预支付接口
extern NSString * const ALiaPay_prepay;                    //  支付宝预支付接口

/**
 订单管理
 */
extern NSString * const client_cart_addCart;               //  添加购物车
extern NSString * const client_cart_deleteCart;            //  删除购物车
extern NSString * const client_cart_getCarts;              //  获取购物车

extern NSString * const client_order_getPostage;              //  获取全局运费
extern NSString * const client_order_getOrderCount ;          //  根据购物车id获取运费

extern NSString * const client_order_submitOrder;              // 提交订单
extern NSString * const client_order_getOrderList;             // 订单列表
extern NSString * const client_order_getOrderDetail;           // 订单详情
extern NSString * const gt100_getLogisticsInfo;                // 物流信息查询

extern NSString * const client_order_cancelOrder;             // 取消订单
extern NSString * const client_order_confirmOrder;            // 确认收货
extern NSString * const client_order_deleteOrder;             // 删除订单

/**售后*/
extern NSString * const client_order_submitAfterSales;        //提交退货
extern NSString * const client_order_getAfterSalesDetails;    //查询售后信息
extern NSString * const client_order_getAfterOrderList;       //获取可售后列表
extern NSString * const client_afterSales_getAfterOrderList;       //获取售后记录

/**个人中心*/
extern NSString * const client_order_getRegisterCodes;        //注册码
extern NSString * const client_order_getMyAccount;            //获取个人中心数据

extern NSString * const client_order_getTeamCenter;           //团队中心统计销售额
extern NSString * const client_order_getTurnoverByUserId;     //一级用户销售额
extern NSString * const client_order_getPerformance;          //根据用户id获取业绩记录
extern NSString * const client_order_getTouchBalance;          //获取余额明细
extern NSString * const client_roleLevel_getRoleLevelDetails;   //会员等级


extern NSString * const client_userManager_getPersonalCenter;    //个人中心数据集合

extern NSString * const client_account_getMyAccount;             //个人信息获取
extern NSString * const client_userManager_eidtUser ;            //个人信息编辑
extern NSString * const client_upload_uploadPortrait;            //上传头像
extern NSString * const client_opinion_addOpinion;               //意见反馈
extern NSString * const client_clause_getClause ;                //协议规则

//库直播
extern NSString * const app_Broadcast_list  ;         //直播列表
extern NSString * const app_Broadcast_WonderList ;    //直播预告
extern NSString * const app_Broadcast_Detail ;        //直播详情

extern NSString * const app_ShortVideo_List;          //短视频
extern NSString * const app_ShortVideo_detail ;       //短视频详情


