//
//  testOperation.m
//  test-001
//
//  Created by lin zoup on 12/21/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testOperation.h"

@implementation testOperation

// 自定义operation需要实现main函数
- (void)main {
    
    // main 里需要建立 autorelease pool
    @autoreleasepool {
        // do something
        // 1. upload image
        // 2. upload other
    }
}

- (void)cancel {
  
    // 取消正在进行的操作
    [super cancel];
}

@end
