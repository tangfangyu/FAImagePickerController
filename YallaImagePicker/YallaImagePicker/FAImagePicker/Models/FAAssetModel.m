//
//  FAAssetModel.m
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import "FAAssetModel.h"
#import <objc/runtime.h>

@implementation FAAssetModel
@synthesize allAsset = _allAsset;

- (void)fetchAssetsInAssetCollection:(PHAssetCollection *)collection
                           ascending:(BOOL)ascending {
    NSMutableArray *allAsset = [[NSMutableArray alloc] init];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    if (collection) {
        [[PHAsset fetchAssetsInAssetCollection:collection options:options] enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allAsset addObject:obj];
        }];
    }else{
        [[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options] enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allAsset addObject:obj];
        }];
    }
    _allAsset = allAsset;
}

- (UIImage *)imageFromAsset:(PHAsset *)asset
                 targetSize:(CGSize)targetSize {
    if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
        targetSize = PHImageManagerMaximumSize;
    }
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    option.networkAccessAllowed = YES;
    option.synchronous = YES;
    __block UIImage *img;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        img = image;
    }];
    return img;
}

@end


static NSString *const FAAssetCategoryIsSelectedKey = @"FAAssetCategoryIsSelectedKey";
@implementation PHAsset(FACategory)

- (void)setIsSelected:(BOOL)isSelected {
    objc_setAssociatedObject(self, [FAAssetCategoryIsSelectedKey UTF8String], @(isSelected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSelected {
    return [objc_getAssociatedObject(self, [FAAssetCategoryIsSelectedKey UTF8String]) boolValue];
}

@end

