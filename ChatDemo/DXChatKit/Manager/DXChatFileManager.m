//
//  DXChatFileManager.m
//  ChatDemo
//
//  Created by Xu Du on 2019/3/26.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#import "DXChatFileManager.h"

#import "DXChatFile.h"

@implementation DXChatFileManager

- (void)uploadFileWithMessage:(DXChatMessage *)message success:(DXFileUploadSuccess)success failed:(DXFileUploadFailed)failed {
    
    DXChatFile *file = [DXChatFile mj_objectWithKeyValues:message.Content];
    NSObject *obj = nil;
    DXUploadType uploadType = DXUploadTypeImage;
    if (message.ContentType == DXChatMessageTypeImage) {
        obj = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:file.FileName];
        uploadType = DXUploadTypeImage;
    }else if (message.ContentType == DXChatMessageTypeVoice) {
        obj = [self getCachePathWithMp3FileName:file.FileName];
        uploadType = DXUploadTypeVoice;
    }
    
    [DXNetWorkInstance uploadFile:obj fileName:file.FileName uploadType:uploadType success:^(id obj, NSString *successMsg) {
        
        if (success) {
            success(obj);
        }
        
    } failure:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
    }];
}

- (void)downloadMp3:(NSString *)fileLink fileName:(NSString *)filename success:(DXFileDownloadSuccess)success failure:(DXFileDownloadFailed)failure {
    
    [DXNetWorkInstance downloadMp3:fileLink fileName:filename success:^(id obj, NSString *successMsg) {
       
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

- (NSString *)getMp3CacheDirectory {
    NSString *mp3Path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"cn.com.xsthc.audioCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:mp3Path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:mp3Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return mp3Path;
}

- (NSString *)getCachePathWithMp3FileName:(NSString *)fileName {
    return [[self getMp3CacheDirectory] stringByAppendingPathComponent:fileName];
}

- (BOOL)isExistMp3File:(NSString *)fileName {
    return [[NSFileManager defaultManager] fileExistsAtPath:[[self getMp3CacheDirectory] stringByAppendingPathComponent:fileName]];
}

@end
