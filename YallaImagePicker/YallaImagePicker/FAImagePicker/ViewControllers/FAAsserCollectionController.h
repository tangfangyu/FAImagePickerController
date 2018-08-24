//
//  FAAsserCollectionController.h
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAAsserCollectionController : UIViewController

/**
 * 完成回调Block
 */
@property (copy, nonatomic) void (^didFinishHandler)(NSArray<UIImage *>*info);

@end
