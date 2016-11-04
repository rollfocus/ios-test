//
//  ViewController.m
//  test-001
//
//  Created by lin zoup on 11/2/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ca.h"
#import "NSString+reverse.h"
#import "caHeader.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *test = [[UIView alloc] init];
    [test init:12 name:@"test"];
    
    NSString *str = @"123456哈哈";
    NSString *reverse = [str reverse];
    NSLog(@">>> %@", reverse);
    
    
    [self performSelectorOnMainThread:@selector(addAWin) withObject:nil waitUntilDone:NO];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^() {
                       //属于在异步线程中retain self，不用担心循环引用？
                       [self refreshBtns];
    });
 
    [NSRunLoop currentRunLoop];
    
    
    // core data
    NSData *nData = [NSKeyedArchiver archivedDataWithRootObject:self];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:nData];
//    [NSKeyedArchiver archiveRootObject:self toFile:@"file-path"];
    // 偏好设置
    [[NSUserDefaults standardUserDefaults] setObject:nData forKey:@"viewControlleer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    // 剪切板
    [[UIPasteboard generalPasteboard] setData:nData forPasteboardType:@"testView"];
    
    
    NSLog(@"The end");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshBtns
{
    @autoreleasepool {
        CGFloat posX = 0;
        CGFloat posY = 30;
        CGFloat buttonWid = 80;
        CGFloat buttonHei = 25;
        for (NSInteger i = 0; i < 100; i ++) {
            @autoreleasepool {
                
                //即时释放内存
                UIButton *btn = [[UIButton alloc] init];
                btn.backgroundColor = [UIColor purpleColor];

                if ((posX + buttonWid) > screenWidth) {
                    posX = posX + buttonWid - screenWidth;
                    posX = 0;
                    posY += buttonHei + 5;
                }
                
                btn.frame = CGRectMake(posX, posY, buttonWid, buttonHei);
                posX += buttonWid + 5;
            
                dispatch_async(dispatch_get_main_queue(), ^() {
                    [btn setTitle:[NSString stringWithFormat:@"btn%ld", i] forState:UIControlStateNormal];
                    [self.view addSubview:btn];
                });
            }
            
            usleep(100);
        }
    }
}

- (void)addAWin {
    
    UIView *titleView = [[UIView alloc] init];
    CGRect rect = CGRectMake((screenWidth - 100 )/2, 0, 100, 20);
    titleView.frame = rect;
    
    titleView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:titleView];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@">>>>> touch began");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //触控压力的改变也会触发touch move事件
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
