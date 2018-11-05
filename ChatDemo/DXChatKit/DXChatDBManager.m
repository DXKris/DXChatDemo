//
//  DXChatDBManager.m
//  ChatDemo
//
//  Created by Xu Du on 2018/11/5.
//  Copyright © 2018 Xu Du. All rights reserved.
//

#import "DXChatDBManager.h"

#import <FMDB.h>

#import "DXChatMessage.h"

@interface DXChatDBManager ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation DXChatDBManager

+ (instancetype)share {
    static DXChatDBManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[DXChatDBManager alloc] init];
    });
    return share;
}

- (void)initDBWithUsername:(NSString *)username {
//    NSLog(@"==%@", NSHomeDirectory());
    if (self.database) { //防止重新登录后更改database, 原来的database没有释放
        [self.database close];
    }
    NSString *path = @"/Users/senta/Desktop/chat.sqlite";
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    if ([database open]) {
//        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS chat_list ()"];
        [database executeUpdate:@"CREATE TABLE IF NOT EXISTS chat_msg (message_id TEXT PRIMARY KEY, date_time TEXT NOT NULL, src_user_id TEXT NOT NULL, group_id TEXT, dst_user_id TEXT NOT NULL, content_type INTEGER, content TEXT, nick_name TEXT)"];
        self.database = database;
    }
}

- (void)insertChatMessage:(DXChatMessage *)message {
    [self.database executeUpdate:@"INSERT INTO chat_msg (message_id, date_time, src_user_id, group_id, dst_user_id, content_type, content, nick_name) values (?,?,?,?,?,?,?,?)", message.MessageID, message.DateTime, message.SrcUserID, message.GroupID, message.DstUserID, @(message.ContentType), message.Content, message.NickName];
}

- (NSArray *)queryChatMessages {
    FMResultSet *rs = [self.database executeQuery:@"SELECT * FROM chat_msg"];
    NSMutableArray *temp = [NSMutableArray array];
    while ([rs next]) {
        DXChatMessage *message = [DXChatMessage new];
        message.MessageID = [rs stringForColumn:@"message_id"];
        message.DateTime = [rs stringForColumn:@"date_time"];
        message.SrcUserID = [rs stringForColumn:@"src_user_id"];
        message.GroupID = [rs stringForColumn:@"group_id"];
        message.DstUserID = [rs stringForColumn:@"dst_user_id"];
        message.ContentType = [rs intForColumn:@"content_type"];
        message.Content = [rs stringForColumn:@"content"];
        message.NickName = [rs stringForColumn:@"nick_name"];
        [temp addObject:message];
    }
    return [temp copy];
}

@end
