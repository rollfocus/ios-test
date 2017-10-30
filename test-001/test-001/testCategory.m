//
//  testCategory.m
//  test-001
//
//  Created by lin zoup on 11/29/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testCategory.h"
#import "UIView+ca.h"


//static const void *pKey = &pKey;

@implementation testCategory

- (void)test {
    
    UIView *categoryView = [UIView new];
    categoryView.catStr = @"I am category property";
    NSLog(@">>> UIView catStr: %@ ", categoryView.catStr);
}


@end
