//
//  DXInputView.m
//  ChatDemo
//
//  Created by Xu Du on 2018/8/21.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXChatInputView.h"

#import "DXChatToolBar.h"
#import "DXFaceView.h"
#import "DXMoreView.h"

static CGFloat const DXFaceViewHeight = 210.0;

@interface DXChatInputView ()<DXChatToolBarDelegate>

@property (nonatomic, strong) DXChatToolBar *toolBar;
@property (nonatomic, strong) DXFaceView *faceView;
@property (nonatomic, strong) DXMoreView *moreView;

@property (nonatomic, assign) DXChatToolBarShowType showType;

@end

@implementation DXChatInputView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexColor(0xf5f4f6);
        
        [self addSubview:self.toolBar];
        [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.toolBar);
        }];
        
        [self addSubview:self.faceView];
        [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.toolBar.mas_bottom);
            make.height.mas_equalTo(DXFaceViewHeight);
        }];
        
        [self addSubview:self.moreView];
        [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.toolBar.mas_bottom);
            make.height.mas_equalTo(DXFaceViewHeight);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - Notifications
- (void)_keyboardWillShow:(NSNotification *)notification {
    
    CGRect endRect = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.toolBar).offset(endRect.size.height);
    }];
    [self.superview layoutIfNeeded];
}

- (void)_keyboardWillHide:(NSNotification *)notification {
    
    if (self.showType == DXChatToolBarShowTypeFace ||
        self.showType == DXChatToolBarShowTypeMore) {
        return;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.toolBar);
    }];
    [self.superview layoutIfNeeded];
}

#pragma mark - DXChatToolBarDelegate
- (void)chatToolBar:(DXChatToolBar *)toolBar show:(DXChatToolBarShowType)showType {
    self.showType = showType;
    
    switch (showType) {
        case DXChatToolBarShowTypeInit: {
            [self _showFaceView:NO];
            [self _showMoreView:NO];
            [toolBar showKeyboard:NO];
        }
            break;
        case DXChatToolBarShowTypeKeyBorad: {
            [toolBar showRecordBtn:NO];
            [self _showFaceView:NO];
            [self _showMoreView:NO];
            [toolBar showKeyboard:YES];
        }
            break;
        case DXChatToolBarShowTypeVoice: {
            [toolBar showKeyboard:NO];
            [self _showFaceView:NO];
            [self _showMoreView:NO];
            [toolBar showRecordBtn:YES];
        }
            break;
        case DXChatToolBarShowTypeFace: {
            [toolBar showKeyboard:NO];
            [toolBar showRecordBtn:NO];
            [self _showMoreView:NO];
            [self _showFaceView:YES];
        }
            break;
        case DXChatToolBarShowTypeMore: {
            [toolBar showKeyboard:NO];
            [toolBar showRecordBtn:NO];
            [self _showFaceView:NO];
            [self _showMoreView:YES];
        }
            break;
        default:
            break;
    }
}

- (void)_showFaceView:(BOOL)show {
    if (show) {
        self.faceView.hidden = NO;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.toolBar).offset(DXFaceViewHeight);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.superview layoutIfNeeded];
        }];
    }else {
        self.faceView.hidden = YES;
        if (self.showType == DXChatToolBarShowTypeKeyBorad) {
            return;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self.toolBar);
            }];
            [self.superview layoutIfNeeded];
        }];
    }
}

- (void)_showMoreView:(BOOL)show {
    if (show) {
        self.moreView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self.toolBar).offset(DXFaceViewHeight);
            }];
            [self.superview layoutIfNeeded];
        }];
    }else {
        self.moreView.hidden = YES;
        if (self.showType == DXChatToolBarShowTypeKeyBorad) {
            return;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self.toolBar);
            }];
            [self.superview layoutIfNeeded];
        }];
    }
}

#pragma mark - Public
- (void)initChatToolBar {
    [self.toolBar initToolBar];
}

#pragma mark - Getter
- (DXChatToolBar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [DXChatToolBar new];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

- (DXFaceView *)faceView {
    if (_faceView == nil) {
        _faceView = [DXFaceView new];
        _faceView.hidden = YES;
    }
    return _faceView;
}

- (DXMoreView *)moreView {
    if (_moreView == nil) {
        _moreView = [DXMoreView new];
        _moreView.hidden = YES;
    }
    return _moreView;
}

@end