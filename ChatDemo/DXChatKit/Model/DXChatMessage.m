//
//  DXChatModel.m
//  ChatDemo
//
//  Created by Xu Du on 2018/9/6.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXChatMessage.h"

@implementation DXChatMessage

MJLogAllIvars

+ (instancetype)messageWithContent:(NSString *)content srcUserId:(NSString *)srcUserId dstUserId:(NSString *)dstUserId contentType:(DXChatMessageType)contentType groupId:(NSString *)groupId {
    DXChatMessage *message = [DXChatMessage new];
    message.MessageID = [NSString stringWithFormat:@"%@%ld", [NSUUID UUID].UUIDString, (long)([[NSDate date] timeIntervalSince1970] * 1000)];
    message.DateTime = (long)([[NSDate date] timeIntervalSince1970] * 1000);
    message.status = DXChatMessageStatusSending;
    message.Content = content;
    message.SrcUserID = srcUserId;
    message.DstUserID = dstUserId;
    message.ContentType = contentType;
    message.GroupID = groupId;
    return message;
}

#pragma mark - public
+ (NSString *)generateIdentifierWithMessage:(DXChatMessage *)message {
    NSMutableString *mulStr = [NSMutableString string];
    
    //消息实际类型
    switch (message.ContentType) {
        case DXChatMessageTypeText:
            [mulStr appendString:@"DXChatTextCell"];
            break;
        case DXChatMessageTypeVoice:
            [mulStr appendString:@"DXChatVoiceCell"];
            break;
        case DXChatMessageTypeImage:
            [mulStr appendString:@"DXChatImageCell"];
            break;
        default:
            break;
    }
    
    //单聊或群聊
    if (message.GroupID.length == 0) {
        [mulStr appendFormat:@"_%ld", (long)DXChatRoomTypeSingle];
    }else {
        [mulStr appendFormat:@"_%ld", (long)DXChatRoomTypeGroup];
    }
    
    //发送或接收
    if ([message.SrcUserID isEqualToString:@"40288581653cab8201653cc96f3a0039"]) {
        [mulStr appendFormat:@"_%ld", (long)DXChatMessageFromSend];
    }else {
        [mulStr appendFormat:@"_%ld", (long)DXChatMessageFromReceive];
    }
    
    return [mulStr copy];
}

@end
