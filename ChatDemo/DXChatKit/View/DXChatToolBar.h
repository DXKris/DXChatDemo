//
//  DXChatToolBar.h
//  ChatDemo
//
//  Created by Xu Du on 2018/8/22.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DXChatToolBarShowType) {
    DXChatToolBarShowTypeInit = 0, //默认状态
    DXChatToolBarShowTypeKeyBorad, //展开键盘
    DXChatToolBarShowTypeVoice, //显示录音
    DXChatToolBarShowTypeFace, //显示表情
    DXChatToolBarShowTypeMore //显示更多
};

@protocol DXChatToolBarDelegate;

@interface DXChatToolBar : UIView

@property (nonatomic, weak) id<DXChatToolBarDelegate> delegate;

/**
 录音按钮显示
 */
- (void)showRecordBtn:(BOOL)show;

/**
 键盘显示
 */
- (void)showKeyboard:(BOOL)show;

- (void)initToolBar;

@end

@protocol DXChatToolBarDelegate<NSObject>

- (void)chatToolBar:(DXChatToolBar *)toolBar show:(DXChatToolBarShowType)showType;

- (void)sendText:(NSString *)text;

- (void)endConvertWithMP3FileName:(NSString *)fileName seconds:(NSInteger)seconds;

@end
