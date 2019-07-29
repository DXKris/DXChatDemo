//
//  DXFaceView.h
//  ChatDemo
//
//  Created by Xu Du on 2018/8/24.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXChatFaceManager;

@protocol DXFaceViewDelegate <NSObject>

- (void)selectFace:(NSString *)faceName;

@end

@interface DXFaceView : UIView

@property (nonatomic, weak) id<DXFaceViewDelegate> delegate;

@end
