//
//  FAPreviewViewController.h
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "FAImagePickerController.h"

@interface FAPreviewViewController : UIViewController

/**
 * 所有的Asset对象
 */
@property (strong, nonatomic) NSArray <PHAsset *>*allAsset;

/**
 * 当前下标
 */
@property (strong , nonatomic) NSIndexPath *currentIndexPath;

/**
 * 选中的Asset对象
 */
@property (strong, nonatomic) NSMutableArray <PHAsset *>*selectedAsset;

@end
