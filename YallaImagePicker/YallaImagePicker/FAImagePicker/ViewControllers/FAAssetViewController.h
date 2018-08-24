//
//  FAAssetViewController.h
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAAssetModel.h"

@interface FAAssetViewController : UIViewController

/**
 * 相册对象
 */
@property (strong, nonatomic) PHAssetCollection *collection;

/**
 * 完成回调Block
 */
@property (copy, nonatomic) void (^didFinishHandler)(NSArray<UIImage *>*info);

@end
