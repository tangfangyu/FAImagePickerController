//
//  FAImagePickerController.h
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FAImagePickerController;
@protocol FAImagePickerControllerDelegate <NSObject>

/**
 * 选完图片的回调方法
 */
- (void)imagePickerController:(FAImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSArray <UIImage *>*)info;

@end

NS_CLASS_AVAILABLE_IOS(8_0) @interface FAImagePickerController : UINavigationController

/**
 * delegate
 */
@property (weak, nonatomic) id <FAImagePickerControllerDelegate>pickerDelegate;

/**
 * 图片最大数量. 默认是9长.
 */
@property (assign, nonatomic) NSInteger selectedMaxNumber;

/**
 * 未选中时的状态图片
 */
@property (strong, nonatomic) UIImage *normalImage;

/**
 * 选中时的状态图片
 */
@property (strong, nonatomic) UIImage *selectedImage;

@end
