//
//  NETworking.m
//  ALPHA
//
//  Created by teelab2 on 14-5-15.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+Extension.h"
static NSString *kNotificationUpdateUserInfo = @"updateUserInfo";
@interface UserInfo : NSObject
@property (nonatomic, strong)    NSString               *userNickname;
/// 帐号ID(八位数-环信帐号)
@property (nonatomic, strong)    NSString               *accountId;
/// 学历认证状态 1:审核中(好友证明-证明中)，2:认证通过(好友证明-确认证明) 3:认证不通过（好友取消证明）0：学历还未申请认证
@property (nonatomic, strong)    NSString               *authentication;
/// 学历状态 1:在读 2:已毕业
@property (nonatomic, strong)    NSString               *certificationUser;
/// 婚恋状况 0:暂不填写，1:单身，2:非单身
@property (nonatomic, strong)    NSString               *marriageStatus;
@property (nonatomic, strong)    NSString               *userAge;
/// 用户认证方式 1:审核认证，2好友担保
@property (nonatomic, strong)    NSString               *userCertification;
/// 用户学历 1:大学专科以下，2:大学专科，3:大学本科，4:研究生硕士，5:研究生博士 （注：默认为0，即无学历资料认证）
@property (nonatomic, strong)    NSString               *userEducation;
/// 用户身份证号（唯一索引 ps:一个身份证只能绑定一个账号,默认为0，即无实名认证）
@property (nonatomic, strong)    NSString               *userIdentity;
@property (nonatomic, strong)    NSString               *userImg;
/// 用户个性签名
@property (nonatomic, strong)    NSString               *userMotto;
/// 用户真实姓名
@property (nonatomic, strong)    NSString               *userName;
@property (nonatomic, strong)    NSString               *userQrCode;

@property (nonatomic, strong)    NSString               *token;
@end
