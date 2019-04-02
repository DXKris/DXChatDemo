//
//  DXRecord.h
//  ChatDemo
//
//  Created by Xu Du on 2018/11/6.
//  Copyright © 2018 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DXRecordDelegate <NSObject>

- (void)failRecord;
- (void)endConvertWithMP3FileName:(NSString *)fileName;

@end

@interface DXRecord : NSObject

@property (nonatomic, weak) id<DXRecordDelegate> delegate;

- (void)startRecord;

- (void)stopRecord;

- (void)cancelRecord;

@end
