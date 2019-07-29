//
//  DXChatLoginManagerProtocol.h
//  ChatDemo
//
//  Created by Xu Du on 2019/3/25.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#ifndef DXChatLoginManagerProtocol_h
#define DXChatLoginManagerProtocol_h

typedef void (^DXChatLoginComplete)(NSError *error);

@protocol DXChatLoginManager <NSObject>


/**
 获取当前登录用户的clientId

 @return clientId
 */
- (NSString *)getCurrentUserClientId;

/**
 登录
 
 @param username 用户名
 @param password 密码
 @param clientId 用户id
 @param complete 回调
 */
- (void)loginWithUsername:(NSString *)username password:(NSString *)password clientId:(NSString *)clientId complete:(DXChatLoginComplete)complete;

@end

#endif /* DXChatLoginManagerProtocol_h */
