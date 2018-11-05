//
//  DXBaseChatCell.m
//  ChatDemo
//
//  Created by Xu Du on 2018/9/5.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXBaseChatCell.h"

@interface DXBaseChatCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation DXBaseChatCell

/**
 cell初始化方法

 @param reuseIdentifier 格式:cell实际类型_单聊或群聊_接收或发出
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        NSArray *component = [reuseIdentifier componentsSeparatedByString:@"_"];
        self.chatType = [component[1] integerValue];
        self.messageFrom = [component[2] integerValue];
        
        [self addAndLayoutSubviews];
    }
    return self;
}

#pragma mark - Public
- (void)addAndLayoutSubviews {
    
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.lessThanOrEqualTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        
        switch (self.messageFrom) {
            case DXChatMessageFromSend: {
                make.right.equalTo(self.contentView).offset(-5);
            }
                break;
            case DXChatMessageFromReceive: {
                make.left.equalTo(self.contentView).offset(5);
            }
                break;
            default:
                break;
        }
    }];
    
    if (self.chatType == DXChatRoomTypeGroup) { //群聊添加名字
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImageView);
            
            switch (self.messageFrom) {
                case DXChatMessageFromSend: {
                    make.right.equalTo(self.headImageView.mas_left).offset(-10);
                }
                    break;
                case DXChatMessageFromReceive: {
                    make.left.equalTo(self.headImageView.mas_right).offset(10);
                }
                    break;
                default:
                    break;
            }
        }];
    }
    
    [self.contentView addSubview:self.chatBgView];
    [self.chatBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.lessThanOrEqualTo(self.contentView);
        make.width.height.greaterThanOrEqualTo(self.headImageView);
        
        switch (self.messageFrom) {
            case DXChatMessageFromSend: {
                make.right.equalTo(self.headImageView.mas_left).offset(-5);
                make.left.greaterThanOrEqualTo(self.contentView).offset(40);
            }
                break;
            case DXChatMessageFromReceive: {
                make.left.equalTo(self.headImageView.mas_right).offset(5);
                make.right.lessThanOrEqualTo(self.contentView).offset(-40);
            }
                break;
            default:
                break;
        }
        
        switch (self.chatType) {
            case DXChatRoomTypeSingle: {
                make.top.equalTo(self.headImageView);
                
            }
                break;
            case DXChatRoomTypeGroup: {
                make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            }
                break;
            default:
                break;
        }
    }];
    
    [self.chatBgView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)loadData:(DXChatMessage *)message {
    self.nameLabel.text = message.SrcUserID;
}

#pragma mark - Getter
- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_yisheng"]];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12.0];
        _nameLabel.textColor = HexColor(0x333333);
        _nameLabel.text = @"杜旭";
    }
    return _nameLabel;
}

- (UIView *)chatBgView {
    if (_chatBgView == nil) {
        _chatBgView = [UIView new];
    }
    return _chatBgView;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", self.messageFrom == DXChatMessageFromSend ? @"chat_bg_right" : @"chat_bg_left"]]];
    }
    return _bgImageView;
}

@end
