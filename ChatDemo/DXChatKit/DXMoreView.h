//
//  DXMoreView.h
//  ChatDemo
//
//  Created by Xu Du on 2018/8/24.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXMoreView : UIView

@property (nonatomic, copy) NSArray *moreItems;

@property (nonatomic, copy) void(^moreItemClickBlock)(NSIndexPath *indexPath);

@end
