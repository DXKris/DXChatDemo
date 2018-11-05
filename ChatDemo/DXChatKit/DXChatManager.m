//
//  DXChatManager.m
//  ChatDemo
//
//  Created by Xu Du on 2018/9/12.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXChatManager.h"

#import <MQTTClient.h>

#import "DXChatUser.h"
#import "DXChatDBManager.h"
#import "DXChatMessage.h"

@interface DXChatManager ()<MQTTSessionDelegate>

@property (nonatomic, strong) MQTTCFSocketTransport *transport;
@property (nonatomic, strong) MQTTSession *session;

@end

@implementation DXChatManager

+ (instancetype)share {
    static DXChatManager *chatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatManager = [[DXChatManager alloc] init];
    });
    return chatManager;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password clientId:(NSString *)clientId {
    
    [MQTTLog setLogLevel:DDLogLevelOff];
    
    [DXChatDBManager.share initDBWithUsername:nil];
    
    DXChatUser *user = [DXChatUser new];
    user.UserName = @"yy1";
    user.Password = @"65eda3bb2e4805c1";
    user.Type = DXChatUserTypeDoctor;
    user.ConnectType = DXChatUserContentTypeCons;
    user.HzUserType = DXChatUserHzUserTypeMobile;
    
    self.session.userName = user.mj_JSONString;
    self.session.clientId = @"40288581653cab8201653cc96f3a0039";
    
    [self.session connectWithConnectHandler:^(NSError *error) {
        if (error) {

        }else {
            [self.session subscribeToTopic:@"40288581653cab8201653cc96f3a0039" atLevel:MQTTQosLevelExactlyOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
                if (error) {
                    NSLog(@"Subscription failed %@", error.localizedDescription);
                } else {
                    NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
                }
            }];
        }
    }];
}

#pragma mark - MQTTSessionDelegate
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    
    NSLog(@"--%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    DXChatMessage *messge = [DXChatMessage mj_objectWithKeyValues:data];
    [[DXChatDBManager share] insertChatMessage:messge];
    
}

#pragma mark - Getter
- (MQTTCFSocketTransport *)transport {
    if (_transport == nil) {
        _transport = [[MQTTCFSocketTransport alloc] init];
//        _transport.host = @"192.168.0.138";
        _transport.host = @"172.16.95.129";
        _transport.port = 1883;
    }
    return _transport;
}

- (MQTTSession *)session {
    if (_session == nil) {
        _session = [[MQTTSession alloc] init];
        _session.transport = self.transport;
        _session.delegate = self;
    }
    return _session;
}

@end
