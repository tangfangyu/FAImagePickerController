//
//  FAImagePickerController.m
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import "FAImagePickerController.h"
#import "FAAsserCollectionController.h"
#import "FAAssetViewController.h"

@implementation FAImagePickerController
@synthesize selectedMaxNumber = _selectedMaxNumber;

- (instancetype)initWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    FAAsserCollectionController *collectionController = [[FAAsserCollectionController alloc] init];
    [collectionController setDidFinishHandler:[self didFinishHandler]];
    self = [super initWithRootViewController:collectionController];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        FAAssetViewController *assetController = [[FAAssetViewController alloc] init];
        [assetController setSourceType:sourceType];
        [assetController setDidFinishHandler:[self didFinishHandler]];
        [self pushViewController:assetController animated:NO];
    }
    return self;
}

- (void(^)(NSArray<UIImage *> *info))didFinishHandler {
    __weak typeof(self) weak_self = self;
    return ^(NSArray<UIImage *> *info){
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.pickerDelegate && [strong_self.pickerDelegate respondsToSelector:@selector(fabs_imagePickerController:didFinishPickingMediaWithInfo:)]) {
            [strong_self.pickerDelegate fabs_imagePickerController:strong_self didFinishPickingMediaWithInfo:info];
        }
    };
}

- (NSInteger)selectedMaxNumber {
    if (!_selectedMaxNumber) {
        _selectedMaxNumber = 9;
    }
    return _selectedMaxNumber;
}
@end
