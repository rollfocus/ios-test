//
//  UIView+ca.m
//  test-001
//
//  Created by lin zoup on 11/2/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "UIView+ca.h"

@implementation UIView (ca)

- (void)init:(NSInteger)index name:(NSString *)name {
    NSLog(@">>>>> test override: %ld,%@", index, name);
}


@end
