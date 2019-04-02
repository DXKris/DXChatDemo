//
//  DXChatUserModel.h
//  ChatDemo
//
//  Created by Xu Du on 2018/9/13.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 用户类型

 - DXChatUserModelTypePatient: 患者
 - DXChatUserModelTypeDoctor: 医生
 */
typedef NS_ENUM(NSInteger, DXChatUserType) {
    DXChatUserTypePatient = 0,
    DXChatUserTypeDoctor = 1
};


/**
 连接类型

 - DXChatUserModelContentTypeNormal: 普通连接
 - DXChatUserModelContentTypeCons: 会诊连接
 */
typedef NS_ENUM(NSInteger, DXChatUserContentType) {
    DXChatUserContentTypeNormal = 0,
    DXChatUserContentTypeCons = 1
};


/**
 会诊用户类型

 - DXChatUserModelHzUserTypeMobile: 手机
 - DXChatUserModelHzUserTypePC: PC
 */
typedef NS_ENUM(NSInteger, DXChatUserHzUserType) {
    DXChatUserHzUserTypeMobile = 0,
    DXChatUserHzUserTypePC = 1
};

@interface DXChatUser : NSObject

/** 用户名 */
@property (nonatomic, copy) NSString *UserName;

/** 密码 */
@property (nonatomic, copy) NSString *Password;

/** 用户类型 */
@property (nonatomic, assign) DXChatUserType Type;

/** 连接类型 */
@property (nonatomic, assign) DXChatUserContentType ConnectType;

/** 用户和MQTT的连接ID */
@property (nonatomic, copy) NSString *ClientId;

/** 会诊用户类型 */
@property (nonatomic, assign) DXChatUserHzUserType HzUserType;

@end
