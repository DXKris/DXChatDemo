//
//  DXBaseChatCell.h
//  ChatDemo
//
//  Created by Xu Du on 2018/9/5.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXBaseChatCell;

@protocol DXBaseChatCellDelegate <NSObject>

- (void)tapCell:(DXBaseChatCell *)cell;

- (void)tapSendFailButtonWithCell:(DXBaseChatCell *)cell;

@end

@interface DXBaseChatCell : UITableViewCell

@property (nonatomic, strong) UIView *chatBgView;
@property (nonatomic, weak) id delegate;

/** 聊天类型(单聊或群聊) */
@property (nonatomic, assign) DXChatRoomType chatType;

/** 消息来源(接收或发送) */
@property (nonatomic, assign) DXChatMessageFrom messageFrom;

- (void)addAndLayoutSubviews;

- (void)loadData:(DXChatMessage *)message;

@end
