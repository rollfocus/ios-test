//
//  testTouchEvent.m
//  test-001
//
//  Created by lin zoup on 3/6/17.
//  Copyright © 2017 cDuozi. All rights reserved.
//

#import "testTouchEvent.h"
#import <UIKit/UIKit.h>

@interface View1 : UIView

@end

@implementation View1

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@">>>> view1 hittest");
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@">>>> View1 pointInside");
    //return [super pointInside:point withEvent:event];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@">>> view1 touch begin");
    
    //[super touchesBegan:touches withEvent:event];
}

@end

@interface View2 : UIView

@end

@implementation View2

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@">>>> view2 hitest");
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@">>>> View2 pointInside");
    return [super pointInside:point withEvent:event];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@">>> view2 touch begin");
    
    [super touchesBegan:touches withEvent:event];
    
    
    //再发送一个UIEvent事件？
    CGPoint point = [[touches anyObject] locationInView:self];
    
//    [[UIApplication sharedApplication] sendEvent:event];
}

@end

@interface hitView : UIView {
    View1 *v1;
    View2 *v2;
}

@end

@implementation hitView

- (instancetype)init {
    if (self = [super init]) {
        v1 = [[View1 alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        v1.backgroundColor = [UIColor redColor];
        v2 = [[View2 alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
        v2.backgroundColor = [UIColor yellowColor];
        [self addSubview:v1];
        [self addSubview:v2];
        
//        [v1 becomeFirstResponder];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapV1)];
        tap1.numberOfTapsRequired = 1;
        [v1 addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapV2)];
        tap1.numberOfTapsRequired = 1;
        [v2 addGestureRecognizer:tap2];
        
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapV)];
        tap3.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap3];

    }
    return self;
}

- (void)tapV1 {
    NSLog(@">>>> handle tap View 1");
}

- (void)tapV2 {
    NSLog(@">>>> handle tap View 2");
}

- (void)tapV {
    NSLog(@">>>> handle tap view...");
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@">>>> hitView touches begin");
//    
//    
//    //[v1 touchesBegan:touches withEvent:event];
//    
//    //发送一个系统触摸事件？？
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return v1;
}

@end

@implementation testTouchEvent

+ (void)showTouchView {
//    UIView *view = [UIView new];
//    View1 *v1 = [[View1 alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    v1.backgroundColor = [UIColor redColor];
//    View2 *v2 = [[View2 alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
//    v2.backgroundColor = [UIColor yellowColor];
//    [view addSubview:v1];
//    [view addSubview:v2];
    
    UIView *view = [[hitView alloc] init];
    view.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    //处理uiapllication 给发送两个事件？
}

@end
