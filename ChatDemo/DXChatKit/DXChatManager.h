//
//  DXChatManager.h
//  ChatDemo
//
//  Created by Xu Du on 2018/9/12.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXChatManager : NSObject

+ (instancetype)share;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password clientId:(NSString *)clientId;

@end
