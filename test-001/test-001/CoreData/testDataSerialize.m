//
//  testDataSerialize.m
//  test-001
//
//  Created by lin zoup on 11/22/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testDataSerialize.h"

@implementation testDataSerialize

- (instancetype)init {
    if (self = [super init]) {
        self.name = [NSString stringWithFormat:@"linc.lin"];
        self.ok = YES;
    }
    return self;
}

// nscoding 实现
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.ok = [aDecoder decodeBoolForKey:@"ok"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeBool:self.ok forKey:@"ok"];
}

- (void)test {
    [self testSerialize];
}

- (void)testSerialize {
    // core data
    NSData *nData = [NSKeyedArchiver archivedDataWithRootObject:self];
    testDataSerialize *obj = [NSKeyedUnarchiver unarchiveObjectWithData:nData];
    NSLog(@">> name:%@, ok:%d", obj.name, obj.ok);
    //    [NSKeyedArchiver archiveRootObject:self toFile:@"file-path"];
    // 偏好设置
    [[NSUserDefaults standardUserDefaults] setObject:nData forKey:@"testPreference"];
    int num = 3;
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"num"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 剪切板
    [[UIPasteboard generalPasteboard] setData:nData forPasteboardType:@"testS"];
    nData = [[UIPasteboard generalPasteboard] dataForPasteboardType:@"testS"];
    obj = [NSKeyedUnarchiver unarchiveObjectWithData:nData];
}

@end
