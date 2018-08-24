//
//  ViewController.m
//  YallaImagePicker
//
//  Created by fabs on 2018/8/21.
//  Copyright © 2018年 fabs. All rights reserved.
//

#import "ViewController.h"
#import "FAImagePickerController.h"

@interface ViewController ()<FAImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)imagePickerController:(FAImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSArray<UIImage *> *)info {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    FAImagePickerController *controller = [[FAImagePickerController alloc] init];
    controller.pickerDelegate = self;
    controller.selectedMaxNumber = 3;
    controller.normalImage = [UIImage imageNamed:@"service_seleted"];
    controller.selectedImage = [UIImage imageNamed:@"service_seleted_click"];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
