//
//  DXChatClient.h
//  ChatDemo
//
//  Created by Xu Du on 2019/3/18.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DXChatMessage.h"

#import "DXChatLoginManagerProtocol.h"
#import "DXChatMessageManagerProtocaol.h"
#import "DXChatSessionManagerProtocol.h"
#import "DXChatFileManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DXChatClient : NSObject

/** 登录管理器 */
@property (nonatomic, strong) id<DXChatLoginManager> loginManger;

/** 消息管理器(消息的发送和接收) */
@property (nonatomic, strong) id<DXChatMessageManager> messageManager;

/** 会话管理消息(插入或查询 消息、会话等 ) */
@property (nonatomic, strong) id<DXChatSessionManager> sessionManager;

/** 文件管理器(上传、下载) */
@property (nonatomic, strong) id<DXChatFileManager> fileManager;

+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
