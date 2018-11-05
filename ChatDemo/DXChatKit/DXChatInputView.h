//
//  DXInputView.h
//  ChatDemo
//
//  Created by Xu Du on 2018/8/21.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXChatInputView : UIView

/** 更多item点击 */
@property (nonatomic, copy) void(^moreItemClickBlock)(NSIndexPath *indexPath);

- (void)initChatToolBar;

- (void)addMoreItemImageName:(NSString *)itemImageName itemName:(NSString *)itemName click:(void(^)(void))click;

@end
