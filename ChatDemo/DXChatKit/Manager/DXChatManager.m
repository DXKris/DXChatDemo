//
//  DXChatManager.m
//  ChatDemo
//
//  Created by Xu Du on 2019/3/25.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#import "DXChatManager.h"
#import <MQTTClient.h>

#import "DXChatUser.h"

@interface DXChatManagerDelegateBridge : NSObject

@property (nonatomic, weak) id<DXChatMessageManagerDelegate> delegate;

@end

@implementation DXChatManagerDelegateBridge

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end

@interface DXChatManager ()<MQTTSessionDelegate>

@property (nonatomic, strong) MQTTCFSocketTransport *transport;
@property (nonatomic, strong) MQTTSession *session;

@property (nonatomic, strong) NSMutableArray *delegates;

@end

@implementation DXChatManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [MQTTLog setLogLevel:DDLogLevelOff];
    }
    return self;
}

#pragma mark - DXChatLoginManager
- (void)loginWithUsername:(NSString *)username password:(NSString *)password clientId:(NSString *)clientId complete:(DXChatLoginComplete)complete {
    
    [[DXChatClient share].sessionManager initDBWithUserId:clientId];
    
    DXChatUser *user = [DXChatUser new];
    user.UserName = username;
    user.Password = password;
    user.Type = DXChatUserTypeDoctor;
    user.ConnectType = DXChatUserContentTypeCons;
    user.HzUserType = DXChatUserHzUserTypeMobile;
    
    self.session.userName = user.mj_JSONString;
    self.session.clientId = clientId;
    
    [self.session connectWithConnectHandler:^(NSError *error) {
        if (!error) {
            [self.session subscribeToTopic:clientId atLevel:MQTTQosLevelExactlyOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
                if (error) {
                    NSLog(@"Subscription failed %@", error.localizedDescription);
                } else {
                    NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
                }
            }];
        }
        
        if (complete) {
            complete(error);
        }
    }];
}

- (NSString *)getCurrentUserClientId {
    return self.session.clientId;
}

#pragma mark - DXChatMessageManager
- (void)addDelegate:(id<DXChatMessageManagerDelegate>)delegate {
    DXChatManagerDelegateBridge *bridge = [DXChatManagerDelegateBridge new];
    bridge.delegate = delegate;
    [self.delegates addObject:bridge];
}

- (void)removeDelegate:(id<DXChatMessageManagerDelegate>)delegate {
    for (DXChatManagerDelegateBridge *bridge in self.delegates) {
        if (bridge.delegate == nil || bridge.delegate == delegate) {
            [self.delegates removeObject:bridge];
        }
    }
}

#pragma mark - MQTTSessionDelegate
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    
    DXChatMessage *message = [DXChatMessage mj_objectWithKeyValues:data];
    
    if (message.ContentType == DXChatMessageTypeReceipt) { //发送成功回执
        
        [[DXChatClient share].sessionManager updateLocalMessage:message sendStatus:DXChatMessageStatusSuccess];
        
        for (DXChatManagerDelegateBridge *bridge in self.delegates) {
            if (bridge.delegate && [bridge.delegate respondsToSelector:@selector(receiveReceiptMessage:)]) {
                [bridge.delegate receiveReceiptMessage:message];
            }
        }
    }else {
        
        if ([message.SrcUserID isEqualToString:self.session.clientId] && message.GroupID.length > 0) { //过滤自己发送的群消息
            return;
        }
        
        message.sessionId = message.GroupID.length == 0 ? message.SrcUserID : message.GroupID;
        
        //发送消息收到回执
        DXChatMessage *receiptMessage = [DXChatMessage new];
        receiptMessage.ContentType = DXChatMessageTypeReceipt;
        receiptMessage.MessageID = message.MessageID;
        receiptMessage.DateTime = message.DateTime;
        receiptMessage.sessionId = @"TextCenter";
        [self sendMessage:receiptMessage];
        
        //插入消息到数据库
        [[DXChatClient share].sessionManager insertMessage:message];
        //收到消息代理
        for (DXChatManagerDelegateBridge *bridge in self.delegates) {
            if (bridge.delegate && [bridge.delegate respondsToSelector:@selector(receiveMessage:)]) {
                [bridge.delegate receiveMessage:message];
            }
        }
    }
}

- (void)sendMessage:(DXChatMessage *)message {
    [self.session publishData:message.mj_JSONData onTopic:message.sessionId retain:NO qos:MQTTQosLevelExactlyOnce publishHandler:^(NSError *error) {
        
    }];
}

- (void)connected:(MQTTSession *)session {
    [self _getUnreadMessagesWithStartTime:0 jsonIDList:nil];
}

- (void)_getUnreadMessagesWithStartTime:(NSInteger)startTime jsonIDList:(NSString *)jsonIDList {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.session.clientId forKey:@"UserID"];
    [parameters setObject:@(50) forKey:@"PageSize"];
    if (startTime > 0) {
        [parameters setObject:@(startTime) forKey:@"StartTime"];
    }
    
    if (jsonIDList.length > 0) {
        [parameters setObject:jsonIDList forKey:@"JsonIDList"];
    }
    
    [DXNetWorkInstance chatPostWithMethod:@"GetUnreadChatMessage" parameters:[parameters copy] success:^(id obj, NSString *successMsg) {
        
        NSArray *unreadMessages = [[DXChatMessage mj_objectArrayWithKeyValuesArray:obj] copy];
        
        if (unreadMessages.count != 0) {
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (DXChatMessage *message in unreadMessages) {
                
                message.sessionId = message.GroupID.length == 0 ? message.SrcUserID : message.GroupID;
                
                //插入消息到数据库
                [[DXChatClient share].sessionManager insertMessage:message];
                //收到消息代理
                for (DXChatManagerDelegateBridge *bridge in self.delegates) {
                    if (bridge.delegate && [bridge.delegate respondsToSelector:@selector(receiveMessage:)]) {
                        [bridge.delegate receiveMessage:message];
                    }
                }
                
                [tempArray addObject:message.MessageID];
            }
            DXChatMessage *lastUnreadMessage = unreadMessages.lastObject;
            [self _getUnreadMessagesWithStartTime:lastUnreadMessage.DateTime jsonIDList:tempArray.mj_JSONString];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Getter
- (MQTTCFSocketTransport *)transport {
    if (!_transport) {
        _transport = [[MQTTCFSocketTransport alloc] init];
        _transport.host = @"192.168.0.5";
        _transport.port = 1883;
    }
    return _transport;
}

- (MQTTSession *)session {
    if (!_session) {
        _session = [[MQTTSession alloc] init];
        _session.transport = self.transport;
        _session.delegate = self;
    }
    return _session;
}

- (NSMutableArray *)delegates {
    if (!_delegates) {
        _delegates = [NSMutableArray array];
    }
    return _delegates;
}

@end
