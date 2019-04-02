//
//  DXMoreViewItem.h
//  ChatDemo
//
//  Created by Xu Du on 2018/11/5.
//  Copyright © 2018 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXMoreViewItem : NSObject

/** 图片名 */
@property (nonatomic, copy) NSString *itemImageName;

/** 名字 */
@property (nonatomic, copy) NSString *itemName;

/** 点击效果 */
@property (nonatomic, copy) void(^click)(void);

@end
