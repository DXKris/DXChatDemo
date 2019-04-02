//
//  DXAPIResponse.h
//  Consultation
//
//  Created by Xu Du on 2018/4/2.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXAPIResponse : NSObject

/** 接口访问信息 */
@property (nonatomic, copy) NSString *message;

/** 状态码 */
@property (nonatomic, assign) NSInteger statusCode;

/** 是否访问成功 */
@property (nonatomic, assign) BOOL success;

@end
