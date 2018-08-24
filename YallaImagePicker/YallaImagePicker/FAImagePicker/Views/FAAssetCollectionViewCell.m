//
//  FAAssetCollectionViewCell.m
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import "FAAssetCollectionViewCell.h"

@implementation FAAssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectedButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView setFrame:self.contentView.bounds];
    [self.selectedButton setFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds) - 30, 0, 30, 30)];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _selectedButton;
}

@end
