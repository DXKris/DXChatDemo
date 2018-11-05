//
//  DXChatDBManager.h
//  ChatDemo
//
//  Created by Xu Du on 2018/11/5.
//  Copyright © 2018 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DXChatMessage;

@interface DXChatDBManager : NSObject

+ (instancetype)share;

- (void)initDBWithUsername:(NSString *)username;

- (void)insertChatMessage:(DXChatMessage *)message;

- (NSArray *)queryChatMessages;

@end
