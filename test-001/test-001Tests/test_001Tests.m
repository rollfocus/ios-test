//
//  test_001Tests.m
//  test-001Tests
//
//  Created by lin zoup on 11/2/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "testCategory.h"
#import "NSString+reverse.h"
#import "UIView+ca.h"
#import "testRuntime.h"
#import "testClassMechanics.h"
#import "testBasic.h"
#import "testUIView.h"

#import <myFirstFrameWork/myFirstFrameWork.h>

#import <objc/runtime.h>

@interface test_001Tests : XCTestCase

@end

@implementation test_001Tests


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUI {
    [testUIView test];
}

- (void)testFrameWork {
    [[myFirstFrameWork new] sayHi];
}

- (void)testBasic {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    void *key;
    NSLog(@"%d", (int)(&key));
    key = &key;
    NSLog(@"%d", (int)(&key));
    key = key;
    NSLog(@"%d", (int)(&key));
    
    // set value for key
    [[testBasic new] testSetValue];
}

- (void)testRuntime {
    [[testRuntime new] test];
}

- (void)testKVO {
    [[testBasic new] testKVO];
}

- (void)testClassMech {
    
    NSInteger ret1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    NSInteger ret2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
 
    NSInteger ret3 = [(id)[testClassMechanics class] isKindOfClass:[testClassMechanics class]];
    NSInteger ret4 = [(id)[testClassMechanics class] isMemberOfClass:[testClassMechanics class]];
    
    NSLog(@"%ld %ld %ld %ld", ret1, ret2, ret3, (long)ret4);
    
    NSLog(@"%p", [NSObject class]);
    
    NSLog(@"%p", [testClassMechanics class]);
    NSLog(@"%p", [testClassMechanics superclass]);
    Class metaClass = objc_getMetaClass("testClassMechanics");
    NSLog(@"%p", metaClass);
}


- (void)testBlock {
    //在block之后a的内存转到了堆区，
    __block int a = 1;
//    int a = 1;
    NSLog(@"%p", &a);
    void (^foo)(void) = ^ {
        a = 2;
        NSLog(@"%p", &a);
    };
    NSLog(@"%p", &a);
    foo();
}

- (void)testCopy {
    // 对 immutable 对象进行 copy 操作，是指针复制，mutableCopy 操作时内容复制；
    // 对 mutable 对象进行 copy 和 mutableCopy 都是内容复制
    NSMutableString *str = [NSMutableString stringWithString:@"12345"];
    NSString *strCopy = [str copy];//copy的对象是NSString类型
    [str insertString:@"0" atIndex:2];
    NSLog(@">> end test: %@,%@", str, strCopy);
    
    // deep copy items
//    [[NSMutableSet alloc] initWithSet:nil copyItems:YES];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testCategory {
    //category添加属性
    testCategory *tc = [testCategory new];
    tc.catStr = @"hahah";
    NSLog(@"category property: %@", tc.catStr);
}

- (void)testOverRide {
    UIView *test = [[UIView alloc] init];
    [test init:12 name:@"test"];
}

- (void)testNSStringReverse {
    NSString *str = @"123456A哈";
    NSString *reverseStr = [str reverse];
    NSLog(@">>> %@", reverseStr);
    
    XCTAssertEqualObjects(reverseStr, @"哈A654321", @"must equal");
    XCTAssertNotEqual(reverseStr, @"哈A654321", @"must equal");
}

@end
