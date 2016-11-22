//
//  test_001Tests.m
//  test-001Tests
//
//  Created by lin zoup on 11/2/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+reverse.h"
#import "UIView+ca.h"

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

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
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
