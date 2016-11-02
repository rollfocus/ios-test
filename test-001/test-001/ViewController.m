//
//  ViewController.m
//  test-001
//
//  Created by lin zoup on 11/2/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ca.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *test = [[UIView alloc] init];
    [test init:12 name:@"test"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
