//
//  DXChatFileManagerProtocol.h
//  ChatDemo
//
//  Created by Xu Du on 2019/3/26.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#ifndef DXChatFileManagerProtocol_h
#define DXChatFileManagerProtocol_h

typedef void(^DXFileUploadSuccess)(id obj);
typedef void(^DXFileUploadFailed)(NSError *error);

typedef void(^DXFileDownloadSuccess)(void);
typedef void(^DXFileDownloadFailed)(NSError *error);

@protocol DXChatFileManager <NSObject>


/**
 上传文件

 @param message 消息模型
 @param success 成功回调
 @param failed 失败回调
 */
- (void)uploadFileWithMessage:(DXChatMessage *)message success:(DXFileUploadSuccess)success failed:(DXFileUploadFailed)failed;

- (void)downloadMp3:(NSString *)fileLink fileName:(NSString *)filename success:(DXFileDownloadSuccess)success failure:(DXFileDownloadFailed)failure;


/**
 获取本地缓存mp3文件目录地址

 @return 目录地址
 */
- (NSString *)getMp3CacheDirectory;

/**
 获得本地缓存mp3文件的完整路径

 @return 文件路径
 */
- (NSString *)getCachePathWithMp3FileName:(NSString *)fileName;


/**
 判断mp3文件是否存在

 @param fileName 文件名
 */
- (BOOL)isExistMp3File:(NSString *)fileName;

@end

#endif /* DXChatFileManagerProtocol_h */
