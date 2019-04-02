//
//  DXChatToolBar.m
//  ChatDemo
//
//  Created by Xu Du on 2018/8/22.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXChatToolBar.h"

#import "LCCKProgressHUD.h"

#import <AVFoundation/AVFoundation.h>
#import "DXRecord.h"

static CGFloat const DXMargin = 7;
static CGFloat const DXLineHeight = 0.5;
static CGFloat const DXRecordBtnInset = 6;

@interface DXChatToolBar ()<UITextViewDelegate, DXRecordDelegate>

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *faceBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) CGFloat lastHeight;
@property (nonatomic, copy) NSString *cacheText;

@property (nonatomic, assign) DXChatToolBarShowType showType;
@property (nonatomic, strong) DXRecord *recorder;

@end

@implementation DXChatToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = HexColor(0xf5f4f6);
        
        [self _addAndLayoutSubviews];
        
    }
    return self;
}

- (void)_addAndLayoutSubviews {
    [self addSubview:self.topLine];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(DXLineHeight);
    }];
    
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(DXLineHeight);
    }];
    
    [self addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(DXMargin);
        make.bottom.equalTo(self).offset(-DXMargin);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [self addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-DXMargin);
        make.bottom.equalTo(self.voiceBtn);
        make.size.equalTo(self.voiceBtn);
    }];
    
    [self addSubview:self.faceBtn];
    [self.faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreBtn.mas_left).offset(-DXMargin);
        make.bottom.equalTo(self.voiceBtn);
        make.size.equalTo(self.voiceBtn);
    }];
    
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(DXMargin);
        make.left.equalTo(self.voiceBtn.mas_right).offset(DXMargin);
        make.right.equalTo(self.faceBtn.mas_left).offset(-DXMargin);
        make.bottom.equalTo(self.voiceBtn);
    }];
    
    [self addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textView).insets(UIEdgeInsetsMake(-DXRecordBtnInset, -DXRecordBtnInset, -DXRecordBtnInset, -DXRecordBtnInset));
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    //FIXME: 进来如果有默认的字符, 这个height不能获取实际高度(待修复), 测试可以在layoutsubviews中初始化
    CGFloat height = [textView sizeThatFits:CGSizeMake(textView.bounds.size.width, MAXFLOAT)].height;
    
    //FIXME: 这里的70是测试3行的高度, 待有更好方法修复
    if (self.lastHeight != height) {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height > 70 ? 70 : height);
        }];
    }
    
    textView.scrollEnabled = height > 70;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (self.showType != DXChatToolBarShowTypeKeyBorad &&
        self.showType != DXChatToolBarShowTypeInit) {
        self.showType = DXChatToolBarShowTypeKeyBorad;
        self.voiceBtn.selected = NO;
        self.faceBtn.selected = NO;
        self.moreBtn.selected = NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        NSString *wipeSpaceStr = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; //去除首尾空格
        if (wipeSpaceStr.length == 0) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"不能发送空格" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
            textView.text = nil;
            return NO;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendText:)]) {
            [self.delegate sendText:wipeSpaceStr];
        }
        
        textView.text = nil;
        [self textViewDidChange:textView];
        return NO;
    }
    return YES;
}

#pragma mark - RecordEvent
- (void)_startRecord {
    
    //权限处理
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {}];
        return;
    }else if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您的麦克风权限未打开" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    [LCCKProgressHUD show];
    [self _setRecordBtnHighlight];
    [self.recorder startRecord];
}

- (void)_updateCancelRecord {
    [LCCKProgressHUD changeSubTitle:@"松开取消录音"];
}

- (void)_updateContinueRecord {
    [LCCKProgressHUD changeSubTitle:@"向上滑动取消录音"];
}

- (void)_completeRecord {
    [self _setRecordBtnNormal];
    [self.recorder stopRecord];
}

- (void)_cancelRecord {
    [LCCKProgressHUD dismissWithMessage:@"取消录音"];
    [self _setRecordBtnNormal];
    [self.recorder cancelRecord];
}

- (void)_setRecordBtnNormal {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(9, 9, 9, 9);
    UIImage *voiceRecordButtonNormalBackgroundImage = [[UIImage imageNamed:@"record_btn_normal"] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    [self.recordBtn setBackgroundImage:voiceRecordButtonNormalBackgroundImage forState:UIControlStateNormal];
    [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
}

- (void)_setRecordBtnHighlight {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(9, 9, 9, 9);
    UIImage *voiceRecordButtonHighlightedBackgroundImage = [[UIImage imageNamed:@"record_btn_highlight"] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    [self.recordBtn setBackgroundImage:voiceRecordButtonHighlightedBackgroundImage forState:UIControlStateNormal];
    [_recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
}

#pragma mark - DXRecordDelegate
- (void)failRecord {
    [LCCKProgressHUD dismissWithProgressState:LCCKProgressShort];
}

- (void)endConvertWithMP3FileName:(NSString *)fileName {
    if (fileName.length == 0) {
        [LCCKProgressHUD dismissWithProgressState:LCCKProgressError];
    }else {
        [LCCKProgressHUD dismissWithProgressState:LCCKProgressSuccess];
        if (self.delegate && [self.delegate respondsToSelector:@selector(endConvertWithMP3FileName:seconds:)]) {
            [self.delegate endConvertWithMP3FileName:fileName seconds:[LCCKProgressHUD seconds]];
        }
    }
}

#pragma mark - Listen
- (void)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        if (button == self.voiceBtn) {
            self.showType = DXChatToolBarShowTypeVoice;
            self.faceBtn.selected = NO;
            self.moreBtn.selected = NO;
        }else if (button == self.faceBtn) {
            self.showType = DXChatToolBarShowTypeFace;
            self.voiceBtn.selected = NO;
            self.moreBtn.selected = NO;
        }else if (button == self.moreBtn) {
            self.showType = DXChatToolBarShowTypeMore;
            self.voiceBtn.selected = NO;
            self.faceBtn.selected = NO;
        }
    }else {
        self.showType = DXChatToolBarShowTypeKeyBorad;
    }
}

#pragma mark - Public
- (void)showRecordBtn:(BOOL)show {
    if (show) {
        self.textView.hidden = YES;
        self.recordBtn.hidden = NO;
    }else {
        self.recordBtn.hidden = YES;
        self.textView.hidden = NO;
    }
}

- (void)showKeyboard:(BOOL)show {
    if (show) {
        [self.textView becomeFirstResponder];
    }else {
        [self.textView resignFirstResponder];
    }
}

- (void)initToolBar {
    
    if (self.showType == DXChatToolBarShowTypeVoice) {
        return;
    }

    self.faceBtn.selected = NO;
    self.moreBtn.selected = NO;
    self.showType = DXChatToolBarShowTypeInit;
}

#pragma mark - Setter
- (void)setShowType:(DXChatToolBarShowType)showType {
    
    if (showType == DXChatToolBarShowTypeVoice) {
        self.cacheText = self.textView.text;
        self.textView.text = nil;
        [self textViewDidChange:self.textView];
    }else if (_showType == DXChatToolBarShowTypeVoice) {
        self.textView.text = self.cacheText;
        [self textViewDidChange:self.textView];
    }
    
    _showType = showType;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatToolBar:show:)]) {
        [self.delegate chatToolBar:self show:showType];
    }
}

#pragma mark - Getter
- (UIView *)topLine {
    if (_topLine == nil) {
        _topLine = [UIView new];
        _topLine.backgroundColor = HexColor(0xd2d2d2);
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = HexColor(0xd2d2d2);
    }
    return _bottomLine;
}

- (UIButton *)voiceBtn {
    if (_voiceBtn == nil) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setImage:[UIImage imageNamed:@"ic_luying"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageNamed:@"ic_jianpang"] forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

- (UIButton *)faceBtn {
    if (_faceBtn == nil) {
        _faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceBtn setImage:[UIImage imageNamed:@"ic_biaoqing"] forState:UIControlStateNormal];
        [_faceBtn setImage:[UIImage imageNamed:@"ic_jianpang"] forState:UIControlStateSelected];
        [_faceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceBtn;
}

- (UIButton *)moreBtn {
    if (_moreBtn == nil) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"ic_genduo"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIButton *)recordBtn {
    if (_recordBtn == nil) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self _setRecordBtnNormal];
        
        [_recordBtn addTarget:self action:@selector(_startRecord) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(_updateCancelRecord) forControlEvents:UIControlEventTouchDragExit];
        [_recordBtn addTarget:self action:@selector(_updateContinueRecord) forControlEvents:UIControlEventTouchDragEnter];
        [_recordBtn addTarget:self action:@selector(_completeRecord) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(_cancelRecord) forControlEvents:UIControlEventTouchUpOutside];
        
        _recordBtn.hidden = YES;
        _recordBtn.adjustsImageWhenHighlighted = NO;
    }
    return _recordBtn;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [UITextView new];
        _textView.font = [UIFont systemFontOfSize:15.0];
        _textView.layer.cornerRadius = 5.0;
        _textView.scrollEnabled = NO;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.delegate = self;
    }
    return _textView;
}

- (DXRecord *)recorder {
    if (!_recorder) {
        _recorder = [DXRecord new];
        _recorder.delegate = self;
    }
    return _recorder;
}

@end
