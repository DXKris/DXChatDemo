//
//  DXNetWorkManager.h
//  Consultation
//
//  Created by Xu Du on 2018/4/2.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DXNetWorkInstance [DXNetWorkManager shareInstance]

extern NSString * const DXConfigIP;

typedef void(^SuccessBlock)(id obj, NSString *successMsg);
typedef void(^FailureBlock)(NSError *error);

typedef NS_ENUM(NSInteger, DXUploadType) {
    DXUploadTypeImage = 1,
    DXUploadTypeVoice
};

@interface DXNetWorkManager : NSObject

+ (instancetype)shareInstance;

- (void)uploadFile:(NSObject *)file fileName:(NSString *)fileName uploadType:(DXUploadType)uploadType success:(SuccessBlock)success failure:(FailureBlock)failure;

- (void)downloadMp3:(NSString *)url fileName:(NSString *)fileName success:(SuccessBlock)success failure:(FailureBlock)failure;

- (void)postWithMethod:(NSString *)method parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

- (void)setToken:(NSString *)token;

@end
