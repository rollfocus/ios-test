//
//  testProtocol.h
//  test-001
//
//  Created by lin zoup on 11/29/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, aa) {
    a = 1,
    b,c
};

@protocol myProtocol <NSObject>

@required @property (nonatomic, assign) NSInteger prop;

@optional
- (void)testProtol;
- (NSString *)getDescription;

@end


@interface testProtocol : NSObject <myProtocol>

@property (nonatomic, weak) id <myProtocol> delegate; //delegate must use weak

@end
