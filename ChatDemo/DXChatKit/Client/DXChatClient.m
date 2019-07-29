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
