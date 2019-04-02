//
//  DXInputView.h
//  ChatDemo
//
//  Created by Xu Du on 2018/8/21.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DXChatInputViewDelegate <NSObject>

- (void)sendText:(NSString *)text;

- (void)endConvertWithMP3FileName:(NSString *)fileName seconds:(NSInteger)seconds;

- (void)inputViewShow;

@end

@interface DXChatInputView : UIView

@property (nonatomic, weak) id<DXChatInputViewDelegate> delegate;

- (void)initChatToolBar;

- (void)addMoreItemImageName:(NSString *)itemImageName itemName:(NSString *)itemName click:(void(^)(void))click;

@end
