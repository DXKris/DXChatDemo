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

/**
 消息状态

 - DXChatMessageStatusReceive: 用于收到的消息
 - DXChatMessageStatusSending: 发送中
 - DXChatMessageStatusSuccess: 发送成功
 - DXChatMessageStatusFailed: 发送失败
 - DXChatMessageStatusUploadFailed: 上传文件失败
 */
typedef NS_ENUM(NSInteger, DXChatMessageStatus) {
    DXChatMessageStatusReceive,
    DXChatMessageStatusSending,
    DXChatMessageStatusSuccess,
    DXChatMessageStatusFailed,
    DXChatMessageStatusUploadFailed
};

@interface DXChatMessage : NSObject

/** 消息ID(UUID+时间戳) */
@property (nonatomic, copy) NSString *MessageID;

/** 时间 */
@property (nonatomic, assign) NSInteger DateTime;

/** 发送方ID */
@property (nonatomic, copy) NSString *SrcUserID;

/** 接收方ID */
@property (nonatomic, copy) NSString *DstUserID;

/** 群组ID */
@property (nonatomic, copy) NSString *GroupID;

/** 内容消息类型 */
@property (nonatomic, assign) DXChatMessageType ContentType;

/** 消息ID(暂不用) */
//@property (nonatomic, copy) NSString *ContentID;

/** 消息正文 */
@property (nonatomic, copy) NSString *Content;

/** 会话id */
@property (nonatomic, copy) NSString *sessionId;

/** 消息状态 */
@property (nonatomic, assign) DXChatMessageStatus status;

/** 是否已读(本地用) */
@property (nonatomic, assign) BOOL isRead;

/** 昵称 */
//@property (nonatomic, copy) NSString *NickName;

/** 默认为0（单聊，群组聊天），手机及时会诊1，远程会诊2 */
//@property (nonatomic, assign) NSInteger HzChatType;


/**
 生成聊天cell的具体类型Identifier

 @param message 消息模型
 @return cell的Identifier
 */
+ (NSString *)generateIdentifierWithMessage:(DXChatMessage *)message;


/**
 消息生成工厂方法

 @param content 内容
 @param sessionId 会话id
 @param contentType 消息类型
 @param chatRoomType 房间类型
 @return 消息模型
 */
+ (instancetype)messageWithContent:(NSString *)content sessionId:(NSString *)sessionId contentType:(DXChatMessageType)contentType chatRoomType:(DXChatRoomType)chatRoomType;

@end
