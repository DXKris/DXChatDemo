//
//  DXChatClient.m
//  ChatDemo
//
//  Created by Xu Du on 2019/3/18.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#import "DXChatClient.h"

#import "DXChatManager.h"
#import "DXChatDBManager.h"
#import "DXChatFileManager.h"

@interface DXChatClient ()

@property (nonatomic, strong) DXChatManager *chatManager;

@end

@implementation DXChatClient

+ (instancetype)share {
    static DXChatClient *chatClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatClient = [[DXChatClient alloc] init];
    });
    return chatClient;
}

//#pragma mark - DXChatManagerDelegate
//- (void)receiveMessage:(DXChatMessage *)message {
//
//    if (message.ContentType == DXChatMessageTypeReceipt) { //发送成功回执
//        //更新消息状态
//        [self.chatDbManager updateMessage:message status:DXChatMessageStatusSuccess];
//        [[NSNotificationCenter defaultCenter] postNotificationName:DXChatSendMessageSuccessNotification object:nil userInfo:@{DXReceiveMessage : message}];
//        return;
//    }else { //发送已收到回执
//        DXChatMessage *RecepitMessage = [DXChatMessage new];
//        RecepitMessage.ContentType = DXChatMessageTypeReceipt;
//        RecepitMessage.DateTime = message.DateTime;
//        RecepitMessage.MessageID = message.MessageID;
//        [self.chatManager sendMessage:RecepitMessage];
//    }
//
//    message.sessionId = message.GroupID.length == 0 ? message.SrcUserID : message.GroupID;
//    [self.chatDbManager insertChatMessage:message];
//    [[NSNotificationCenter defaultCenter] postNotificationName:DXChatReceiveMessageNotification object:nil userInfo:@{DXReceiveMessage : message}];
//
//    extern NSString *DXChatSessionListRefreshNotification;
//    [[NSNotificationCenter defaultCenter] postNotificationName:DXChatSessionListRefreshNotification object:nil];
//}

#pragma mark - Getter
- (id<DXChatLoginManager>)loginManger {
    return self.chatManager;
}

- (id<DXChatMessageManager>)messageManager {
    return self.chatManager;
}

- (id<DXChatSessionManager>)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [DXChatDBManager new];
    }
    return _sessionManager;
}

- (id<DXChatFileManager>)fileManager {
    if (!_fileManager) {
        _fileManager = [DXChatFileManager new];
    }
    return _fileManager;
}

- (DXChatManager *)chatManager {
    if (!_chatManager) {
        _chatManager = [DXChatManager new];
    }
    return _chatManager;
}

@end
