//
//  NSString+reverse.m
//  test-001
//
//  Created by lin zoup on 11/2/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "NSString+reverse.h"

@implementation NSString (reverse)

- (NSString *)reverse
{
    NSMutableString *reverseStr = [[NSMutableString alloc] init];
    if (reverseStr)
    {
        for (NSInteger i = self.length - 1; i >= 0; i--) {
            //exchange charactor
            unichar ele = [self characterAtIndex:i];
            [reverseStr appendString:[NSString stringWithCharacters:&ele length:1]];
        }
    }
    
    return reverseStr;
}

@end
