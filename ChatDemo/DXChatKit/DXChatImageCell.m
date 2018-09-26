//
//  DXChatImageCell.m
//  ChatDemo
//
//  Created by Xu Du on 2018/9/7.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXChatImageCell.h"

@interface DXChatImageCell ()

@property (nonatomic, strong) UIImageView *chatImageView;

@end

@implementation DXChatImageCell

- (void)addAndLayoutSubviews {
    [super addAndLayoutSubviews];
    
    [self.chatBgView addSubview:self.chatImageView];
    [self.chatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.size.mas_equalTo(CGSizeMake(100, 100 * 4 / 3));//宽度固定, 高度按照4:3比例
    }];
}

#pragma mark - Getter
- (UIImageView *)chatImageView {
    if (_chatImageView == nil) {
        _chatImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test"]];
    }
    return _chatImageView;
}

@end
