//
//  DXChatTextCell.m
//  ChatDemo
//
//  Created by Xu Du on 2018/9/6.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXChatTextCell.h"

#import "DXChatFaceManager.h"

static CGFloat const TextMargin = 12.0;
static CGFloat const OutsideMargin = 6.0;//气泡图片那个小尖尖的宽度

@interface DXChatTextCell ()

@property (nonatomic, strong) UILabel *chatTextLabel;

@end

@implementation DXChatTextCell

- (void)addAndLayoutSubviews {
    [super addAndLayoutSubviews];
    
    [self.chatBgView addSubview:self.chatTextLabel];
    [self.chatTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatBgView).offset(TextMargin);
        make.bottom.equalTo(self.chatBgView).offset(-TextMargin);
        
        switch (self.messageFrom) {
            case DXChatMessageFromSend: {
                make.left.equalTo(self.chatBgView).offset(TextMargin);
                make.right.equalTo(self.chatBgView).offset(-(TextMargin + OutsideMargin));
            }
                break;
            case DXChatMessageFromReceive: {
                make.left.equalTo(self.chatBgView).offset(TextMargin + OutsideMargin);
                make.right.equalTo(self.chatBgView).offset(-TextMargin);
            }
                break;
            default:
                break;
        }
    }];
}

- (void)loadData:(DXChatMessage *)message {
    [super loadData:message];
    self.chatTextLabel.attributedText = [[DXChatFaceManager share] getAttributedStringWithText:message.Content];
}

#pragma mark - Getter
- (UILabel *)chatTextLabel {
    if (_chatTextLabel == nil) {
        _chatTextLabel = [UILabel new];
        _chatTextLabel.font = [UIFont systemFontOfSize:16.0];
        _chatTextLabel.numberOfLines = 0;
//        _chatTextLabel.textColor = (self.messageFrom == DXChatMessageFromSend ? [UIColor whiteColor] : [UIColor blackColor]);
    }
    return _chatTextLabel;
}

@end
