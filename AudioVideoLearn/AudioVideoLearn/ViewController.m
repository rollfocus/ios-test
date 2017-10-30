//
//  ViewController.m
//  AudioVideoLearn
//
//  Created by lin zoup on 2/21/17.
//  Copyright © 2017 cDuozi. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "LLRecordViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:1.0];
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    bgView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:bgView];
    
    // create subviews
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    videoBtn.frame = CGRectMake(100, 300, 200, 40);
    videoBtn.backgroundColor = [UIColor greenColor];
    [videoBtn setTintColor:[UIColor redColor]]; // nothing?
    [videoBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [videoBtn.titleLabel setText:@"Record Video"];
//    videoBtn.titleLabel.textColor = [UIColor blackColor];
    [videoBtn setTitle:@"Record Video" forState:UIControlStateNormal];
    [videoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [videoBtn setTitleColor:[UIColor blueColor] forState:UIControlStateFocused];
//    [videoBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];

    [videoBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.view addSubview:videoBtn];
    
    [videoBtn addTarget:self action:@selector(recordVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.title = @"Video T";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordVideo:(id)sender {
//    NSLog(@">>>> begin to record video");
    
    [self.navigationController pushViewController:[LLRecordViewController new] animated:YES];
    return;

    
//    UIViewController *vc = [UIViewController new];
//    vc.view.backgroundColor = [UIColor orangeColor];
//    vc.title = @"Record";
//    [self.navigationController pushViewController:vc animated:YES];
    
//    [self showVideoPicker];
}

- (UIImagePickerController *)showVideoPicker {
    // check available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return nil;
    }
    
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    camera.mediaTypes = @[(NSString *)kUTTypeMovie];
    camera.allowsEditing = NO;
//    camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    camera.delegate = self;
    
    [self presentViewController:camera animated:YES completion:nil];
    
    return camera;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@">>>>> finished");
}

@end
