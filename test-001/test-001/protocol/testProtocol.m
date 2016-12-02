//
//  testProtocol.m
//  test-001
//
//  Created by lin zoup on 11/29/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testProtocol.h"


@implementation testProtocol {
    NSInteger _prop; //定义变量
}

//在协议中定义 需要手动使用synthesize生成setter与getter方法
//但是无法方位 _prop变量
@synthesize prop;

- (void)test {
    
    NSLog(@"%ld", self.prop);
    NSLog(@"%ld, %ld", _prop, self->_prop);
}

@end
