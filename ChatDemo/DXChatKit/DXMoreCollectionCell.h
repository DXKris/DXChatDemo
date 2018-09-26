//
//  DXMoreCollectionCell.h
//  ChatDemo
//
//  Created by Xu Du on 2018/8/29.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const DXMoreCollectionCellW;
extern CGFloat const DXMoreCollectionCellH;

@interface DXMoreCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
