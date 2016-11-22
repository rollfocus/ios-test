//
//  testDataSerialize.m
//  test-001
//
//  Created by lin zoup on 11/22/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testDataSerialize.h"

@implementation testDataSerialize


- (void)testSerialize {
    // core data
    NSData *nData = [NSKeyedArchiver archivedDataWithRootObject:self];
    //    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:nData];
    //    [NSKeyedArchiver archiveRootObject:self toFile:@"file-path"];
    // 偏好设置
    [[NSUserDefaults standardUserDefaults] setObject:nData forKey:@"testPreference"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 剪切板
    [[UIPasteboard generalPasteboard] setData:nData forPasteboardType:@"testView"];
}

@end
