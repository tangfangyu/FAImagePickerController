//
//  FAAssetCollectionListCell.m
//  YallaImagePicker
//
//  Created by fabs on 2018/8/24.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import "FAAssetCollectionListCell.h"

@implementation FAAssetCollectionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.imageView.backgroundColor = [UIColor redColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetHeight(self.contentView.bounds) -20;
    [self.imageView setFrame:CGRectMake(10, 10, width, width)];
    [self.textLabel setFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 0, CGRectGetWidth(self.contentView.bounds) - width - 20, CGRectGetHeight(self.contentView.bounds))];
}

@end
