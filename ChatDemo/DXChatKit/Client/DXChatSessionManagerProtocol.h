//
//  DXChatSessionManagerProtocol.h
//  ChatDemo
//
//  Created by Xu Du on 2019/3/26.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#ifndef DXChatSessionManagerProtocol_h
#define DXChatSessionManagerProtocol_h

@protocol DXChatSessionManagerDelegate <NSObject>

- (void)sessionUpdated;

@end

@protocol DXChatSessionManager <NSObject>

/**
 初始化数据库

 @param userId 用户id
 */
- (void)initDBWithUserId:(NSString *)userId;

/**
 插入一条消息到数据库
 
 @param message 消息模型
 */
- (void)insertMessage:(DXChatMessage *)message;


/**
 查询所有会话
 */
- (NSArray *)querySessions;


/**
 根据会话查询本地消息

 @param sessionId 会话id
 */
- (NSArray *)queryLocalMessagesWithSessionId:(NSString *)sessionId;

/**
 更新本地消息发送状态

 @param message 消息模型
 @param status 发送状态
 */
- (void)updateLocalMessage:(DXChatMessage *)message sendStatus:(DXChatMessageStatus)status;

/**
 更新本地消息的content(例如图片或者音频上传成功后返回的内容)

 @param message 消息模型
 @param content 需要更新的content
 */
- (void)updateLocalMessage:(DXChatMessage *)message content:(NSString *)content;


/**
 添加代理

 @param delegate 代理对象
 */
- (void)addDelegate:(id<DXChatSessionManagerDelegate>)delegate;


/**
 移除代理

 @param delegate 代理对象
 */
- (void)removeDelegate:(id<DXChatSessionManagerDelegate>)delegate;

@end

#endif /* DXChatSessionManagerProtocol_h */
