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
- (void)fabs_imagePickerController:(FAImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSArray <UIImage *>*)info;

@end

NS_CLASS_AVAILABLE_IOS(8_0) @interface FAImagePickerController : UINavigationController

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass NS_UNAVAILABLE;

/**
 * 初始化方法.
 */
- (instancetype)initWithSourceType:(UIImagePickerControllerSourceType)sourceType;

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
