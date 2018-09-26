//
//  DXBaseChatCell.h
//  ChatDemo
//
//  Created by Xu Du on 2018/9/5.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DXChatModel.h"

@interface DXBaseChatCell : UITableViewCell

@property (nonatomic, strong) UIView *chatBgView;
@property (nonatomic, strong) UIImageView *bgImageView;

/** 聊天类型(单聊或群聊) */
@property (nonatomic, assign) DXChatType chatType;

/** 消息来源(接收或发送) */
@property (nonatomic, assign) DXMessageFrom messageFrom;

- (void)addAndLayoutSubviews;

@end
