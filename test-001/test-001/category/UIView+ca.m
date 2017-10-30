//
//  UIView+ca.m
//  test-001
//
//  Created by lin zoup on 11/2/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "UIView+ca.h"
#import <objc/runtime.h> //运行时头文件

@implementation UIView (ca)

- (void)init:(NSInteger)index name:(NSString *)name {
    
    NSLog(@">>>>> test override: %ld,%@", index, name);
    
}


#pragma mark - 属性测试

// add category property
- (void)setCatStr:(NSString *)str {
    objc_setAssociatedObject(self, @selector(catStr), str, OBJC_ASSOCIATION_COPY_NONATOMIC);    
}

- (NSString *)catStr {
    return objc_getAssociatedObject(self, @selector(catStr));
}

@end
