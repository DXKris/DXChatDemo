//
//  DXChatVoiceCell.m
//  ChatDemo
//
//  Created by Xu Du on 2019/2/21.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#import "DXChatVoiceCell.h"

#import "DXChatFile.h"

@interface DXChatVoiceCell ()

@property (nonatomic, strong) UILabel *secondLabel;

@end

@implementation DXChatVoiceCell

- (void)addAndLayoutSubviews {
    [super addAndLayoutSubviews];
    
    [self.chatBgView addSubview:self.secondLabel];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chatBgView).offset(10);
        make.centerY.equalTo(self.chatBgView);
    }];
    
    [self.chatBgView addSubview:self.voiceImageView];
    [self.voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondLabel.mas_right).offset(5);
        make.right.equalTo(self.chatBgView).offset(-15);
        make.centerY.equalTo(self.secondLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)loadData:(DXChatMessage *)message {
    [super loadData:message];
    
    DXChatFile *chatFile = [DXChatFile mj_objectWithKeyValues:message.Content];
    
    if (chatFile.second < 60) {
        self.secondLabel.text = [NSString stringWithFormat:@"%ld''", chatFile.second];
    }else {
        NSInteger min = chatFile.second / 60;
        NSInteger seconds = chatFile.second % 60;
        self.secondLabel.text = [NSString stringWithFormat:@"%ld' %ld''", min, seconds];
    }
}

#pragma mark - Getter
- (UIImageView *)voiceImageView {
    if (_voiceImageView == nil) {
        _voiceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatImages.bundle/voice_3"]];
        _voiceImageView.animationImages = @[[UIImage imageNamed:@"ChatImages.bundle/voice_1"], [UIImage imageNamed:@"ChatImages.bundle/voice_2"], [UIImage imageNamed:@"ChatImages.bundle/voice_3"]];
        _voiceImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _voiceImageView.animationDuration = 1;
        _voiceImageView.animationRepeatCount = 0;
    }
    return _voiceImageView;
}

- (UILabel *)secondLabel {
    if (_secondLabel == nil) {
        _secondLabel = [UILabel new];
        _secondLabel.font = [UIFont systemFontOfSize:16.0];
//        _secondLabel.textColor = (self.messageFrom == DXChatMessageFromSend ? [UIColor whiteColor] : [UIColor blackColor]);
    }
    return _secondLabel;
}

@end
