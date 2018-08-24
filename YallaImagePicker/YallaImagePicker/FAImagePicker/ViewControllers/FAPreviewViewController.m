//
//  FAPreviewViewController.m
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import "FAPreviewViewController.h"
#import "FAAssetCollectionViewCell.h"
#import "FAAssetModel.h"


@interface UIImageView (FAPreviewCategory)

- (void)_setImageWithAsset:(PHAsset *)asset placeholder:(UIImage *)placeholder;

@end

@implementation UIImageView (FAPreviewCategory)

- (void)_setImageWithAsset:(PHAsset *)asset placeholder:(UIImage *)placeholder {
    self.image = placeholder;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = YES;
    __weak typeof(self) weak_self = self;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        __strong typeof(weak_self) strong_self = weak_self;
        strong_self.image = image;
    }];
}

@end

@interface FAPreviewViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (retain, nonatomic) UIButton *rightButton;

@property (retain, nonatomic) UICollectionView *collectionView;

@end

@implementation FAPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    PHAsset *asset = [self.allAsset objectAtIndex:self.currentIndexPath.row];
    self.rightButton.selected = asset.isSelected;
    self.rightButton.tag = self.currentIndexPath.row;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.collectionView setFrame:self.view.bounds];
}

#pragma mark - Event Methods
- (void)rightButtonClick:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    PHAsset *asset = [self.allAsset objectAtIndex:indexPath.row];
    if (!asset.isSelected) {
        if ([self verifyCanAddAsset]) {
            [self.selectedAsset addObject:asset];
            asset.isSelected = YES;
        }
    }else{
        asset.isSelected = NO;
        [self.selectedAsset removeObject:asset];
    }
    self.rightButton.selected = asset.isSelected;
}
#pragma mark -

- (BOOL)verifyCanAddAsset {
    NSInteger selectedMaxNumber = ((FAImagePickerController *)self.navigationController).selectedMaxNumber;
    if (self.selectedAsset.count >= selectedMaxNumber) {
        NSString *message = [NSString stringWithFormat:@"最多只能选择%zd张图片",selectedMaxNumber];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancle];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark - <UICollectionViewDelegate>And<UICollectionViewDataSource>Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allAsset.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FAAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FAAssetCollectionViewCellIdentifier" forIndexPath:indexPath];
    PHAsset *asset = [self.allAsset objectAtIndex:indexPath.row];
    [cell.imageView _setImageWithAsset:asset placeholder:nil];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.selectedButton.hidden = YES;
    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger idx = targetContentOffset->x/scrollView.frame.size.width;
    PHAsset *asset = [self.allAsset objectAtIndex:idx];
    self.rightButton.selected = asset.isSelected;
    self.rightButton.tag = idx;
}
#pragma mark -

#pragma mark - Getter Methods
- (UIButton *)rightButton {
    if (!_rightButton) {
        FAImagePickerController *navigation = (FAImagePickerController *)self.navigationController;
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setBackgroundImage:navigation.normalImage forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:navigation.selectedImage forState:UIControlStateSelected];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.estimatedItemSize = CGSizeZero;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[FAAssetCollectionViewCell class] forCellWithReuseIdentifier:@"FAAssetCollectionViewCellIdentifier"];
    }
    return _collectionView;
}
#pragma mark -
@end
