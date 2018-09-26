//
//  DXMoreView.m
//  ChatDemo
//
//  Created by Xu Du on 2018/8/24.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXMoreView.h"

#import "DXMoreCollectionCell.h"


@interface DXMoreView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation DXMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DXMoreCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DXMoreCollectionCell class]) forIndexPath:indexPath];
    cell.nameLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(20, 15, 0, 15);
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DXMoreCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([DXMoreCollectionCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 15;
        _flowLayout.minimumInteritemSpacing = (DXScreenW - DXMoreCollectionCellW * 4 - 30) / 3;
        _flowLayout.itemSize = CGSizeMake(DXMoreCollectionCellW, DXMoreCollectionCellH);
//        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

@end
