//
//  DXChatImageCell.m
//  ChatDemo
//
//  Created by Xu Du on 2018/9/7.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXChatImageCell.h"
#import "DXChatFile.h"

#import <UIImageView+WebCache.h>

@interface DXChatImageCell ()

@property (nonatomic, strong) UIImageView *chatImageView;

@end

@implementation DXChatImageCell

- (void)addAndLayoutSubviews {
    [super addAndLayoutSubviews];
    
    [self.chatBgView addSubview:self.chatImageView];
    [self.chatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width / 4;
        make.size.mas_equalTo(CGSizeMake(screenW, screenW * 4 / 3));//宽度固定, 高度按照4:3比例
    }];
}

- (void)loadData:(DXChatMessage *)message {
    [super loadData:message];
    
    DXChatFile *chatFile = [DXChatFile mj_objectWithKeyValues:message.Content];
    
    [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:chatFile.FileName] completion:^(BOOL isInCache) {
        
        if (isInCache) {
            [self.chatImageView sd_setImageWithURL:[NSURL URLWithString:chatFile.FileName]];
        }else {
            [self.chatImageView sd_setImageWithURL:[NSURL URLWithString:chatFile.FileLink]];
        }
    }];
}

#pragma mark - Getter
- (UIImageView *)chatImageView {
    if (_chatImageView == nil) {
        _chatImageView = [[UIImageView alloc] init];
        _chatImageView.layer.cornerRadius = 4.0;
        _chatImageView.clipsToBounds = YES;
    }
    return _chatImageView;
}

@end
