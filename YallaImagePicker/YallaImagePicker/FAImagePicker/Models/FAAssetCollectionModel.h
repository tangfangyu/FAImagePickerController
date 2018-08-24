//
//  FAAssetCollectionModel.h
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface FAAssetCollectionModel : NSObject

/**
 * 所有相册对象.必须先调用fetchAllAssetCollections.
 */
@property (strong, nonatomic, readonly) NSArray <PHAssetCollection *>*allAlbums;

/**
 * 查询所有相册.
 */
- (void)fetchAllAssetCollections;

/**
 * 获取指向相册的标题
 */
- (NSString *)titleWithAssetCollection:(PHAssetCollection *)collection;

/**
 * 获取指定相册的封面图片
 */
- (UIImage *)coverImageForAssetCollection:(PHAssetCollection *)collection;

@end


@interface PHAssetCollection (FAAssetCollectionCategory)

/**
 * 封面图片对象
 */
@property (strong, nonatomic) PHAsset *coverAsset;

@end
