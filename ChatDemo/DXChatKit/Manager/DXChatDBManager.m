//
//  DXChatDBManager.m
//  ChatDemo
//
//  Created by Xu Du on 2019/3/26.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#import "DXChatDBManager.h"

#import <FMDB.h>
#import "DXChatSession.h"

@interface DXChatDBManagerDelegateBridge : NSObject

@property (nonatomic, weak) id<DXChatSessionManagerDelegate> delegate;

@end

@implementation DXChatDBManagerDelegateBridge

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end

@interface DXChatDBManager ()

@property (nonatomic, strong) FMDatabase *database;

@property (nonatomic, strong) NSMutableArray *delegates;

@end

@implementation DXChatDBManager

#pragma mark - DXChatSessionManager
- (void)initDBWithUserId:(NSString *)userId {
    if (self.database) { //防止重新登录后更改database, 原来的database没有释放
        [self.database close];
    }
    NSString *path = [NSString stringWithFormat:@"/Users/senta/Desktop/%@.db", userId];
    //[[self _getChatDBPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db", clientId]]
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    if ([database open]) {
        [database executeUpdate:@"CREATE TABLE IF NOT EXISTS 'chat_message' ('message_id' TEXT PRIMARY KEY, 'date_time' INTEGER, 'from' TEXT, 'to' TEXT, 'group_id' TEXT, 'content_type' INTEGER, 'content' TEXT, 'session_id' TEXT, 'status' INTEGER, 'is_read' INTEGER);"];
        [database executeUpdate:@"CREATE TABLE IF NOT EXISTS 'chat_session' ('session_id' TEXT PRIMARY KEY, 'last_message' TEXT, 'chat_room_type' INTEGER);"];
        self.database = database;
    }
}

- (void)insertMessage:(DXChatMessage *)message {
    //插入或更新会话
    DXChatSession *chatSession = [DXChatSession new];
    chatSession.sessionId = message.sessionId;
    chatSession.lastMessage = message;
    chatSession.chatRoomType = message.GroupID.length == 0 ? DXChatRoomTypeSingle : DXChatRoomTypeGroup;
    [self _CreateOrUpdateChatSession:chatSession];
    
    int count = [self.database intForQuery:@"SELECT COUNT(*) FROM chat_message WHERE message_id = ?;", message.MessageID];
    
    if (count == 0) { //不存在就插入
        [self.database executeUpdate:@"INSERT INTO 'chat_message' ('message_id', 'date_time', 'from', 'to', 'group_id', 'content_type', 'content', 'session_id', 'status', 'is_read') VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", message.MessageID, @(message.DateTime), message.SrcUserID, message.DstUserID, message.GroupID, @(message.ContentType), message.Content, message.sessionId, @(message.status), @(message.isRead)];
    }
}

- (void)_CreateOrUpdateChatSession:(DXChatSession *)chatSession {
    
    int count = [self.database intForQuery:@"SELECT COUNT(*) FROM chat_session WHERE session_id = ?;", chatSession.sessionId];
    
    if (count == 0) {
        //插入会话
        [self.database executeUpdate:@"INSERT INTO chat_session (session_id, last_message, chat_room_type) VALUES (?, ?, ?);", chatSession.sessionId, chatSession.lastMessage.mj_JSONString, @(chatSession.chatRoomType)];
        
    }else {
        //更新会话
        [self.database executeUpdate:@"UPDATE chat_session SET last_message = ? WHERE session_id = ?;", chatSession.lastMessage.mj_JSONString, chatSession.sessionId];
    }
    
    for (DXChatDBManagerDelegateBridge *bridge in self.delegates) {
        if (bridge.delegate && [bridge.delegate respondsToSelector:@selector(sessionUpdated)]) {
            [bridge.delegate sessionUpdated];
        }
    }
}

- (NSArray *)querySessions {
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM chat_session;"];
    NSMutableArray *tempArray = [NSMutableArray array];
    while ([resultSet next]) {
        DXChatSession *session = [DXChatSession new];
        session.sessionId = [resultSet stringForColumn:@"session_id"];
        session.lastMessage = [DXChatMessage mj_objectWithKeyValues:[resultSet stringForColumn:@"last_message"]];
        session.chatRoomType = [resultSet longForColumn:@"chat_room_type"];
        [tempArray addObject:session];
    }
    return [tempArray copy];
}

- (NSArray *)queryLocalMessagesWithSessionId:(NSString *)sessionId {
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM chat_message WHERE session_id = ? ORDER BY date_time ASC;", sessionId];
    NSMutableArray *tempArray = [NSMutableArray array];
    while ([resultSet next]) {
        DXChatMessage *message = [DXChatMessage new];
        message.MessageID = [resultSet stringForColumn:@"message_id"];
        message.DateTime = [resultSet longForColumn:@"date_time"];
        message.SrcUserID = [resultSet stringForColumn:@"from"];
        message.DstUserID = [resultSet stringForColumn:@"to"];
        message.GroupID = [resultSet stringForColumn:@"group_id"];
        message.ContentType = [resultSet longForColumn:@"content_type"];
        message.Content = [resultSet stringForColumn:@"content"];
        message.sessionId = [resultSet stringForColumn:@"session_id"];
        message.status = [resultSet longForColumn:@"status"];
        [tempArray addObject:message];
    }
    return [tempArray copy];
}

- (void)updateLocalMessage:(DXChatMessage *)message sendStatus:(DXChatMessageStatus)status {
    [self.database executeUpdate:@"UPDATE chat_message SET status = ? WHERE message_id = ?;", @(status), message.MessageID];
}

- (void)updateLocalMessage:(DXChatMessage *)message content:(NSString *)content {
    [self.database executeUpdate:@"UPDATE chat_message SET content = ? WHERE message_id = ?;", content, message.MessageID];
}

- (void)addDelegate:(id<DXChatSessionManagerDelegate>)delegate {
    DXChatDBManagerDelegateBridge *bridage = [DXChatDBManagerDelegateBridge new];
    bridage.delegate = delegate;
    [self.delegates addObject:bridage];
}

- (void)removeDelegate:(id<DXChatSessionManagerDelegate>)delegate {
    for (DXChatDBManagerDelegateBridge *bridge in self.delegates) {
        if (bridge.delegate == nil || bridge.delegate == delegate) {
            [self.delegates removeObject:bridge];
        }
    }
}

#pragma mark - Getter
- (NSMutableArray *)delegates {
    if (!_delegates) {
        _delegates = [NSMutableArray array];
    }
    return _delegates;
}

@end
