//
//  DXChatManagerProtocaol.h
//  ChatDemo
//
//  Created by Xu Du on 2019/3/26.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#ifndef DXChatManagerProtocaol_h
#define DXChatManagerProtocaol_h

@protocol DXChatMessageManagerDelegate <NSObject>

/**
 收到消息
 
 @param message 消息模型
 */
- (void)receiveMessage:(DXChatMessage *)message;

@optional
/**
 收到消息回执(发送成功)
 
 @param message 消息模型
 */
- (void)receiveReceiptMessage:(DXChatMessage *)message;

@end

@protocol DXChatMessageManager <NSObject>


/**
 发送消息

 @param message 消息模型
 */
- (void)sendMessage:(DXChatMessage *)message;

/**
 添加代理
 */
- (void)addDelegate:(id<DXChatMessageManagerDelegate>)delegate;


/**
 移除代理
 */
- (void)removeDelegate:(id<DXChatMessageManagerDelegate>)delegate;

@end

#endif /* DXChatManagerProtocaol_h */
