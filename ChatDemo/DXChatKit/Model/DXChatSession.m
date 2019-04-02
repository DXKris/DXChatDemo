//
//  DXChatSession.m
//  ChatDemo
//
//  Created by Xu Du on 2019/3/13.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#import "DXChatSession.h"

#import "DXChatFile.h"

@implementation DXChatSession

- (void)uploadFile:(id)file uploadType:(DXUploadType)uploadType sendMessage:(DXChatMessage *)message {
    message.sessionId = (message.GroupID.length == 0 ? message.DstUserID : message.GroupID);
    
//    [[DXChatClient share].chatDbManager insertChatMessage:message];
    DXChatFile *chatFile = [DXChatFile mj_objectWithKeyValues:message.Content];
    
//    extern NSString *DXChatSessionListRefreshNotification;
//    [[NSNotificationCenter defaultCenter] postNotificationName:DXChatSessionListRefreshNotification object:nil];
    
    [DXNetWorkInstance uploadFile:file fileName:chatFile.FileName uploadType:uploadType success:^(id obj, NSString *successMsg) {
        
        DXChatFile *uploadedChatFile = [DXChatFile mj_objectWithKeyValues:obj];
        
        if (uploadType == DXUploadTypeVoice) {
            uploadedChatFile.second = chatFile.second;
        }
        
        message.Content = uploadedChatFile.mj_JSONString;
//        [[DXChatClient share].chatManager sendMessage:message];

    } failure:^(NSError *error) {

    }];
}

@end
