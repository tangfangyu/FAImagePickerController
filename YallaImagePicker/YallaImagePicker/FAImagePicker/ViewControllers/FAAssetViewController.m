//
//  FAAssetViewController.m
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import "FAAssetViewController.h"
#import "FAPreviewViewController.h"

#import "FAAssetCollectionViewCell.h"

@interface FAAssetViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray <PHAsset *>*selectedAsset;

@property (retain, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) FAAssetModel *model;

@end

@implementation FAAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weak_self = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        __strong typeof(weak_self) strong_self = weak_self;
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:{
                    strong_self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBarButtonItemClick:)];
                    [strong_self.model fetchAssetsInAssetCollection:self.collection ascending:YES];
                    [strong_self.view addSubview:strong_self.collectionView];
                }break;
                default:{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开相册访问权限" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [strong_self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alertController addAction:cancel];
                    [strong_self presentViewController:alertController animated:YES completion:nil];
                }break;
            }
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.collectionView setFrame:self.view.bounds];
}

#pragma mark - Event Methods
- (void)rightBarButtonItemClick:(UIBarButtonItem *)sender {
    NSMutableArray <UIImage *>*images = [[NSMutableArray alloc] init];
    __weak typeof(self) weak_self = self;
    [self.selectedAsset enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weak_self) strong_self = weak_self;
        [images addObject:[strong_self.model imageFromAsset:obj targetSize:CGSizeZero]];
    }];
    if (self.didFinishHandler) {
        self.didFinishHandler(images);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectedButtonClick:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    PHAsset *asset = [self.model.allAsset objectAtIndex:indexPath.row];
    if (!asset.isSelected) {
        if ([self verifyCanAddAsset]) {
            [self.selectedAsset addObject:asset];
            asset.isSelected = YES;
        }
    }else{
        asset.isSelected = NO;
        [self.selectedAsset removeObject:asset];
    }
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
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
    return self.model.allAsset.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.bounds)/3.0, CGRectGetWidth(collectionView.bounds)/3.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FAAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FAAssetCollectionViewCellIdentifier" forIndexPath:indexPath];
    FAImagePickerController *navigation = (FAImagePickerController *)self.navigationController;
    PHAsset *asset = [self.model.allAsset objectAtIndex:indexPath.row];
    cell.imageView.image = [self.model imageFromAsset:asset targetSize:cell.bounds.size];
    [cell.selectedButton setBackgroundImage:navigation.normalImage forState:UIControlStateNormal];
    [cell.selectedButton setBackgroundImage:navigation.selectedImage forState:UIControlStateSelected];
    [cell.selectedButton setSelected:asset.isSelected];
    [cell.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectedButton.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FAPreviewViewController *previewController = [[FAPreviewViewController alloc] init];
    previewController.allAsset = self.model.allAsset;
    previewController.selectedAsset = self.selectedAsset;
    previewController.currentIndexPath = indexPath;
    [self.navigationController pushViewController:previewController animated:YES];
}
#pragma mark -

#pragma mark - Getter Methods
- (NSMutableArray<PHAsset *> *)selectedAsset {
    if (!_selectedAsset) {
        _selectedAsset = [[NSMutableArray alloc] init];
    }
    return _selectedAsset;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[FAAssetCollectionViewCell class] forCellWithReuseIdentifier:@"FAAssetCollectionViewCellIdentifier"];
    }
    return _collectionView;
}

- (FAAssetModel *)model {
    if (!_model) {
        _model = [[FAAssetModel alloc] init];
    }
    return _model;
}
#pragma mark -

@end
