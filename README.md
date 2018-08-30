一.Example 例子

FAImagePickerController *controller = [[FAImagePickerController alloc] initWithSourceType:UIImagePickerControllerSourceTypeCamera]; 
 
controller.pickerDelegate = self;

controller.selectedMaxNumber = 3;

controller.normalImage = [UIImage imageNamed:@"service_seleted"];

controller.selectedImage = [UIImage imageNamed:@"service_seleted_click"];

[self presentViewController:controller animated:YES completion:nil];


二.Requirements 要求

iOS 8 or later. Requires ARC

iOS8及以上系统可使用. ARC环境.

