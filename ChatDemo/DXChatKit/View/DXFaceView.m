//
//  DXFaceView.m
//  ChatDemo
//
//  Created by Xu Du on 2018/8/24.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXFaceView.h"
#import "DXFaceCollectionCell.h"
#import "DXChatFaceManager.h"

@interface DXFaceView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, copy) NSArray *faceNames;
@end

@implementation DXFaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DXFaceCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([DXFaceCollectionCell class])];
        
        self.faceNames = [[DXChatFaceManager share] getFaceNames];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.faceNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *faceName = self.faceNames[indexPath.item];
    
    DXFaceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DXFaceCollectionCell class]) forIndexPath:indexPath];
    
    cell.faceImageView.image = [[DXChatFaceManager share] getFaceImageWithFaceName:faceName];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectFace:)]) {
        [self.delegate selectFace:self.faceNames[indexPath.item]];
    }
}

#pragma mark - Getter
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemWH = (DXScreenW - 6) / 7.0;
        _flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
