//
//  FAAsserCollectionController.m
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import "FAAsserCollectionController.h"
#import "FAAssetViewController.h"

#import "FAAssetCollectionListCell.h"

#import "FAAssetCollectionModel.h"

@interface FAAsserCollectionController ()<UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) UITableView *tableView;

@property (strong, nonatomic) FAAssetCollectionModel *model;

@end

@implementation FAAsserCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBarButtonItemClick:)];
    [self.model fetchAllAssetCollections];
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tableView setFrame:self.view.bounds];
}

#pragma mark - Event Methods
- (void)leftBarButtonItemClick:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -

#pragma mark - <UITableViewDelegate>And<UITableViewDataSource>Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.allAlbums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FAAssetCollectionListCellIdentifier";
    FAAssetCollectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FAAssetCollectionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    PHAssetCollection *collection = [self.model.allAlbums objectAtIndex:indexPath.row];
    cell.imageView.image = [self.model coverImageForAssetCollection:collection];
    cell.textLabel.text = [self.model titleWithAssetCollection:collection];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PHAssetCollection *collection = [self.model.allAlbums objectAtIndex:indexPath.row];
    FAAssetViewController *assetController = [[FAAssetViewController alloc] init];
    assetController.collection = collection;
    assetController.didFinishHandler = self.didFinishHandler;
    [self.navigationController pushViewController:assetController animated:YES];
}
#pragma mark -

#pragma mark - Getter Methods
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.estimatedRowHeight = 44.0;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (FAAssetCollectionModel *)model {
    if (!_model) {
        _model = [[FAAssetCollectionModel alloc] init];
    }
    return _model;
}
#pragma mark -
@end
