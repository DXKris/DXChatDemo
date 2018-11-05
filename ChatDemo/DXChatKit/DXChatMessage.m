//
//  DXChatModel.m
//  ChatDemo
//
//  Created by Xu Du on 2018/9/6.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXChatMessage.h"

@implementation DXChatMessage

+ (NSString *)generateIdentifierWithMessage:(DXChatMessage *)message {
    NSMutableString *mulStr = [NSMutableString string];
    
    //消息实际类型
    switch (message.ContentType) {
        case DXChatMessageTypeText:
            [mulStr appendString:@"DXChatTextCell"];
            break;
        case DXChatMessageTypeVoice:
//            [mulStr appendString:@"DXChatTextCell"];
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
