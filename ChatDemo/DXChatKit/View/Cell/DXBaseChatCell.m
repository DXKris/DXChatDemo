//
//  DXBaseChatCell.m
//  ChatDemo
//
//  Created by Xu Du on 2018/9/5.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXBaseChatCell.h"

@interface DXBaseChatCell ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *sendFailImageView;

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
        make.top.equalTo(self.contentView).offset(10);
//        make.bottom.lessThanOrEqualTo(self.contentView);
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
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-10);
        make.size.greaterThanOrEqualTo(self.headImageView);
        
        switch (self.messageFrom) {
            case DXChatMessageFromSend: {
                make.right.equalTo(self.headImageView.mas_left).offset(-5);
//                make.left.greaterThanOrEqualTo(self.contentView).offset(40);
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
    
    if (self.messageFrom == DXChatMessageFromSend) {
        
        [self.contentView addSubview:self.sendFailImageView];
        [self.sendFailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.chatBgView.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.left.greaterThanOrEqualTo(self.contentView).offset(40);
        }];
        
        [self.contentView addSubview:self.indicatorView];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.sendFailImageView);
        }];
    }
}

- (void)loadData:(DXChatMessage *)message {
    self.nameLabel.text = message.SrcUserID;
    if (message.ContentType == DXChatMessageTypeImage) {
        self.bgImageView.hidden = YES;
    }else {
        self.bgImageView.hidden = NO;
    }
    
    switch (message.status) {
        case DXChatMessageStatusSending:
            [self.indicatorView startAnimating];
            break;
        case DXChatMessageStatusFailed: {
            if (self.indicatorView.isAnimating) {
                [self.indicatorView stopAnimating];
            }
            self.sendFailImageView.hidden = NO;
        }
            break;
        default: {
            if (self.indicatorView.isAnimating) {
                [self.indicatorView stopAnimating];
            }
            if (!self.sendFailImageView.hidden) {
                self.sendFailImageView.hidden = YES;
            }
        }
            break;
    }
}

#pragma mark - Actions
- (void)tapCell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapCell:)]) {
        [self.delegate tapCell:self];
    }
}

- (void)_tapSendFailImageView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapSendFailButtonWithCell:)]) {
        [self.delegate tapSendFailButtonWithCell:self];
    }
}

#pragma mark - Getter
- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatImages.bundle/ic_yisheng"]];
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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell)];
        [_chatBgView addGestureRecognizer:tap];
    }
    return _chatBgView;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.messageFrom == DXChatMessageFromSend ? @"ChatImages.bundle/chat_bg_right" : @"ChatImages.bundle/chat_bg_left"]];
        
        _bgImageView = [[UIImageView alloc] initWithImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height / 2, image.size.width / 2, image.size.height / 2 - 1, image.size.width / 2 - 1) resizingMode:UIImageResizingModeStretch]];
    }
    return _bgImageView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

- (UIImageView *)sendFailImageView {
    if (!_sendFailImageView) {
        _sendFailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatImages.bundle/message_send_failed"]];
        _sendFailImageView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapSendFailImageView)];
        [_sendFailImageView addGestureRecognizer:tap];
    }
    return _sendFailImageView;
}

@end
