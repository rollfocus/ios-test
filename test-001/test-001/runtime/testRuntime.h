//
//  testRuntime.h
//  test-001
//
//  Created by lin zoup on 11/29/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface testRuntime : NSObject {
    NSInteger varT;
}

@property (nonatomic, assign) NSInteger propInt;
@property (nonatomic, copy) NSString *propStr;


- (void)test;

- (void)methodOne;
- (void)methodTwo:(BOOL)sw;


@end
