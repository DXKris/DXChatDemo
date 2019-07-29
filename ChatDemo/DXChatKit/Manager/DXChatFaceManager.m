//
//  DXChatFaceManager.m
//  ChatDemo
//
//  Created by Xu Du on 2019/4/9.
//  Copyright © 2019 Xu Du. All rights reserved.
//

#import "DXChatFaceManager.h"

#import <FMDB.h>

@interface DXChatFaceManager ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation DXChatFaceManager

+ (instancetype)share {
    static DXChatFaceManager *faceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        faceManager = [DXChatFaceManager new];
    });
    return faceManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *faceDBPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"db"];
        self.database = [FMDatabase databaseWithPath:faceDBPath];
    }
    return self;
}

- (NSArray *)getFaceNames {
    if ([self.database open]) {
        FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM face"];
        NSMutableArray *tempArray = [NSMutableArray array];
        while ([resultSet next]) {
            [tempArray addObject:[resultSet stringForColumn:@"facename"]];
        }
        return [tempArray copy];
    }
    return nil;
}

- (UIImage *)getFaceImageWithFaceName:(NSString *)faceName {
    if ([self.database open]) {
        NSData *imageData = [self.database dataForQuery:@"SELECT img FROM face WHERE facename = ?;", faceName];
        return [UIImage imageWithData:imageData];
    }
    return nil;
}

- (NSAttributedString *)getAttributedStringWithText:(NSString *)text {
    
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"\\[[^\\[\\]]*\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSInteger i = resultArray.count - 1; i >= 0 ; i--) {
        NSTextCheckingResult *result = resultArray[i];
        NSRange range =  [result range];
        NSString *subStr = [text substringWithRange:range];
        
        UIImage *faceImage = [[DXChatFaceManager share] getFaceImageWithFaceName:[subStr substringWithRange:NSMakeRange(1, subStr.length - 2)]];
        if (faceImage) {
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = faceImage;
            attachment.bounds = CGRectMake(1, -2, 18, 18);
            [attString replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        }
    }
    return [attString copy];
}

@end
