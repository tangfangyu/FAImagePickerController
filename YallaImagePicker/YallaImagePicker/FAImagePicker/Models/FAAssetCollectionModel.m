//
//  FAAssetCollectionModel.m
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import "FAAssetCollectionModel.h"
#import <objc/runtime.h>

@implementation FAAssetCollectionModel
@synthesize allAlbums = _allAlbums;

- (void)fetchAllAssetCollections {
    NSMutableArray *collections = [[NSMutableArray alloc] init];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    // 获取所有照片
    PHFetchResult <PHAssetCollection *>*systemAblums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:options];
    [systemAblums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.estimatedAssetCount) {
            [collections addObject:obj];
        }
    }];
    
    // 获取用户定义的相册
    PHFetchResult <PHAssetCollection *>*allAblums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:options];
    [allAblums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.estimatedAssetCount) {
            [collections addObject:obj];
        }
    }];
    _allAlbums = collections;
}

- (NSString *)titleWithAssetCollection:(PHAssetCollection *)collection {
    NSString *title = collection.localizedTitle;
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }
    return title;
}

- (UIImage *)coverImageForAssetCollection:(PHAssetCollection *)collection {
    if (!collection.coverAsset) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        [[PHAsset fetchAssetsInAssetCollection:collection options:options] enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            collection.coverAsset = obj;
            *stop = YES;
        }];
    }
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    option.networkAccessAllowed = YES;
    option.synchronous = YES;
    __block UIImage *img;
    [[PHCachingImageManager defaultManager] requestImageForAsset:collection.coverAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        img = image;
    }];
    return img;
}

@end


@implementation PHAssetCollection(FAAssetCollectionCategory)
static NSString *const FAAssetCollectionCategoryKey = @"FAAssetCollectionCategoryKey";

- (void)setCoverAsset:(PHAsset *)coverAsset {
    objc_setAssociatedObject(self, [FAAssetCollectionCategoryKey UTF8String], coverAsset, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PHAsset *)coverAsset {
    return objc_getAssociatedObject(self, [FAAssetCollectionCategoryKey UTF8String]);
}

@end
