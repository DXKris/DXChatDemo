//
//  DXChatModel.h
//  ChatDemo
//
//  Created by Xu Du on 2018/9/6.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 聊天室类型

 - DXChatTypeSingle: 单聊
 - DXChatTypeGroup: 群聊
 */
typedef NS_ENUM(NSInteger, DXChatRoomType) {
    DXChatRoomTypeSingle = 1,
    DXChatRoomTypeGroup
};

/**
 消息来源

 - DXMessageFromSend: 发出的消息
 - DXMessageFromReceive: 接收的消息
 */
typedef NS_ENUM(NSInteger, DXChatMessageFrom) {
    DXChatMessageFromSend = 1,
    DXChatMessageFromReceive
};


/**
 消息类型

 - DXMessageTypeText: 文字表情
 - DXMessageTypeVoice: 语音
 - DXMessageTypeImage: 图片
 - DXMessageTypeReceipt: 回执
 */
typedef NS_ENUM(NSInteger, DXChatMessageType) {
    DXChatMessageTypeText = 1,
    DXChatMessageTypeVoice = 2,
    DXChatMessageTypeImage = 3,
    DXChatMessageTypeReceipt = 10000
};

@interface DXChatMessage : NSObject

/** 消息ID(UUID+时间戳) */
@property (nonatomic, copy) NSString *MessageID;

/** 时间 */
@property (nonatomic, copy) NSString *DateTime;

/** 发送方ID */
@property (nonatomic, copy) NSString *SrcUserID;

/** 群组ID */
@property (nonatomic, copy) NSString *GroupID;

/** 接收方ID */
@property (nonatomic, copy) NSString *DstUserID;

/** 内容消息类型 */
@property (nonatomic, assign) DXChatMessageType ContentType;

/** 消息ID(暂不用) */
@property (nonatomic, copy) NSString *ContentID;

/** 消息正文 */
@property (nonatomic, copy) NSString *Content;

/** 昵称 */
@property (nonatomic, copy) NSString *NickName;

/** 默认为0（单聊，群组聊天），手机及时会诊1，远程会诊2 */
@property (nonatomic, assign) NSInteger HzChatType;

+ (NSString *)generateIdentifierWithMessage:(DXChatMessage *)message;

@end
