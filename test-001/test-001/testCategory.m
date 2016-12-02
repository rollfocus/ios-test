//
//  testCategory.m
//  test-001
//
//  Created by lin zoup on 11/29/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testCategory.h"

#import <objc/runtime.h> //运行时头文件


//static const void *pKey = &pKey;

@implementation testCategory

// add category property
- (void)setCatStr:(NSString *)str {
    objc_setAssociatedObject(self, @selector(catStr), str, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)catStr {
    return objc_getAssociatedObject(self, @selector(catStr));
}


@end
