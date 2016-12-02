//
//  testBasic.h
//  test-001
//
//  Created by lin zoup on 12/1/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface testBasic : NSObject {
    
    NSString *_ulProp;
}

@property (nonatomic, strong) NSMutableArray *arrT;
@property (nonatomic, strong) NSMutableString *strT;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;


- (void)testSetValue;
- (void)testKVO;

@end
