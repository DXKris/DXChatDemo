//
//  DXChatFile.h
//  ChatDemo
//
//  Created by Xu Du on 2019/2/19.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DXChatFile : NSObject

/** 文件链接 */
@property (nonatomic, copy) NSString *FileLink;

/** 文件名 */
@property (nonatomic, copy) NSString *FileName;

/** 服务器传回来的文件名 */
@property (nonatomic, copy) NSString *NewFileName;

/** 录音文件秒数 */
@property (nonatomic, assign) NSInteger second;

@end

NS_ASSUME_NONNULL_END
