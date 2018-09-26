//
//  DXChatManager.m
//  ChatDemo
//
//  Created by Xu Du on 2018/9/12.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXChatManager.h"

#import <MQTTClient.h>

#import "DXChatUserModel.h"

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
    
    DXChatUserModel *userModel = [DXChatUserModel new];
    userModel.UserName = @"heyun";
    userModel.Password = @"2006c565cde24095";
    userModel.Type = DXChatUserModelTypeDoctor;
    userModel.ConnectType = DXChatUserModelContentTypeCons;
    
    self.session.userName = userModel.mj_JSONString;
    self.session.clientId = @"402880155ceedcda015ceef7bb9c000a";
    
    [self.session connectWithConnectHandler:^(NSError *error) {
        if (error) {
            
        }else {
            [self.session subscribeToTopic:@"402880155ceedcda015ceef7bb9c000a" atLevel:MQTTQosLevelExactlyOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
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
    // New message received in topic
    NSLog(@"--%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

#pragma mark - Getter
- (MQTTCFSocketTransport *)transport {
    if (_transport == nil) {
        _transport = [[MQTTCFSocketTransport alloc] init];
        _transport.host = @"192.168.0.138";
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
