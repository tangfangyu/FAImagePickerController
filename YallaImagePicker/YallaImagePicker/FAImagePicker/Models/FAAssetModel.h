//
//  FAAssetModel.h
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface FAAssetModel : NSObject

@property (strong, nonatomic, readonly) NSArray <PHAsset *>*allAsset;

/**
 * 获取制定相册中所有图片对象。 ascending:是否是升序.
 */
- (void)fetchAssetsInAssetCollection:(PHAssetCollection *)collection
                           ascending:(BOOL)ascending;

/**
 * Asset转换成UIImage对象
 */
- (UIImage *)imageFromAsset:(PHAsset *)asset
                 targetSize:(CGSize)targetSize;

@end


@interface PHAsset(FACategory)

/**
 * 是否是选中状态
 */
@property (assign, nonatomic) BOOL isSelected;

@end
