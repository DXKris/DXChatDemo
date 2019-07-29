//
//  DXNetWorkManager.m
//  Consultation
//
//  Created by Xu Du on 2018/4/2.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXNetWorkManager.h"

#import "DXAPIResponse.h"

#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>

NSString * const DXConfigIP = @"configIP";

void CallSuccessBlockOnMainQueue(SuccessBlock success, id obj, NSString *successMsg) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (success) {
            success(obj, successMsg);
        }
    });
}

void CallFailureBlockOnMainQueue(FailureBlock failure, NSError *error) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (failure) {
            failure(error);
        }
    });
}

@interface DXNetWorkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation DXNetWorkManager

+ (instancetype)shareInstance {
    static DXNetWorkManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[DXNetWorkManager alloc] init];
    });
    return shareInstance;
}

- (void)postWithMethod:(NSString *)method parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.5:17001/Home/%@", method];
    
    [self.sessionManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DXAPIResponse *apiResponse = [DXAPIResponse mj_objectWithKeyValues:responseObject];
        
        if (apiResponse.statusCode == 200 && apiResponse.success) {
            CallSuccessBlockOnMainQueue(success, responseObject, apiResponse.message);
        }else {
            if (apiResponse.statusCode == 407) {//登录失败
//                [UIApplication sharedApplication].keyWindow.rootViewController = [[DXLoginController alloc] init];
//
//                [EMClient.sharedClient logout:YES];
//                [DXJCManager.shareManager.client logout];
                
                return ;
            }
            
            CallFailureBlockOnMainQueue(failure, [NSError errorWithDomain:@"cn.com.xscth.errorDomain" code:apiResponse.statusCode userInfo:@{NSLocalizedDescriptionKey : apiResponse.message}]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CallFailureBlockOnMainQueue(failure, error);
    }];
}

- (void)chatPostWithMethod:(NSString *)method parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [@"http://192.168.0.5:17001/Home" stringByAppendingPathComponent:method];
    
    [self.sessionManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CallSuccessBlockOnMainQueue(success, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CallFailureBlockOnMainQueue(failure, error);
    }];
}

- (void)uploadFile:(NSObject *)file fileName:(NSString *)fileName uploadType:(DXUploadType)uploadType success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = @"http://192.168.0.5:17001/Home";
    switch (uploadType) {
        case DXUploadTypeImage:
            url = [url stringByAppendingPathComponent:@"UploadImage"];
            break;
        case DXUploadTypeVoice:
            url = [url stringByAppendingPathComponent:@"UploadMedia"];
            break;
        default:
            break;
    }
    
    [self.sessionManager POST:[url copy] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        switch (uploadType) {
            case DXUploadTypeImage: {
                [formData appendPartWithFileData:UIImageJPEGRepresentation((UIImage *)file, 0.75) name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            }
                break;
            case DXUploadTypeVoice: {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:(NSString *)file] name:@"file" fileName:fileName mimeType:@"audia/mpeg" error:nil];
            }
                break;
            default:
                break;
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CallSuccessBlockOnMainQueue(success, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CallFailureBlockOnMainQueue(failure, error);
    }];
    
}

- (void)downloadMp3:(NSString *)url fileName:(NSString *)fileName success:(SuccessBlock)success failure:(FailureBlock)failure {
    [[self.sessionManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *mp3Path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"cn.com.xsthc.audioCache"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:mp3Path]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:mp3Path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return [NSURL fileURLWithPath:[mp3Path stringByAppendingPathComponent:fileName]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            CallFailureBlockOnMainQueue(failure, error);
            return ;
        }
        CallSuccessBlockOnMainQueue(success, fileName, nil);
    }] resume];
}

- (void)setToken:(NSString *)token {
    [self.sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
}

#pragma mark - Getter
- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 10.0; //10s超时
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [_sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"application/json", nil]];
    }
    return _sessionManager;
}

@end
