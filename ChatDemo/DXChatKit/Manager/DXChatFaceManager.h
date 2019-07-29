//
//  DXChatFaceManager.h
//  ChatDemo
//
//  Created by Xu Du on 2019/4/9.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DXChatFaceManager : NSObject

+ (instancetype)share;

- (NSArray *)getFaceNames;

- (UIImage *)getFaceImageWithFaceName:(NSString *)faceName;

- (NSAttributedString *)getAttributedStringWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
