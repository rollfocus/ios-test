//
//  testBasic.m
//  test-001
//
//  Created by lin zoup on 12/1/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testBasic.h"

static NSString *pKey = @"ulProp";
static NSString *pKeyUL = @"_ulProp";

struct key {
    int a;
    BOOL b;
};


@implementation testBasic

- (instancetype)init {

    if (self = [super init]) {
        // kvo 支持观察变量及属性
        [self addObserver:self forKeyPath:pKey
                  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                  context:nil];
        [self addObserver:self forKeyPath:pKeyUL
                  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                  context:nil];
        [self addObserver:self forKeyPath:@"arrT"
                  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                  context:nil];
        [self addObserver:self forKeyPath:@"strT"
                  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                  context:nil];



        _arrT = [NSMutableArray new];        //不会触发kvo
        self.arrT = [NSMutableArray new];   //会触发kvo
        
        _strT = [NSMutableString new];
    }
    return self;
}

- (void)dealloc {
    // 注意添加的observe要在对象释放时移除
    [self removeObserver:self forKeyPath:pKey];
    [self removeObserver:self forKeyPath:pKeyUL];
    [self removeObserver:self forKeyPath:@"arrT"];
    [self removeObserver:self forKeyPath:@"strT"];
}

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age {
    if (self = [self init]) {
        _name = name;
        _age = age;
    }
    return self;
}

- (void)test {

    [self testTypeEncode];

    [self testSetValue];
    [self testKVO];
}

- (void)testTypeEncode {
    
    // 参考：https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    // type encode, 对应的运用时runtime参数类型表示
    // 可用于 NSMethodSignature 的 signatureWithObjCTypes 方法参数
    char *buf = @encode(int);
    char *buf1 = @encode(int **);
    char *buf2 = @encode(NSString);
    char *buf3 = @encode(void);
    char *buf4 = @encode(SEL);
    char *buf5 = @encode(NSObject);
    NSLog(@">>> type encode: %s", buf);
    NSLog(@">>> type encode: %s", buf1);
    NSLog(@">>> type encode: %s", buf2);
    NSLog(@">>> type encode: %s", buf3);
    NSLog(@">>> type encode: %s", buf4);
    NSLog(@">>> type encode: %s", buf5);
}

- (void)testSetValue {
    
    // it is all the same
    // use key as _urProp or ulProp
    [self setValue:@"11" forKey:pKey];  //会触发KVO key:@"urlProp"
    NSLog(@"_urlProp: %@ equal 11?", _ulProp);
    [self setValue:@"22" forKey:pKeyUL]; // 会触发KVO key:@"_urlProp"
    NSLog(@"_urlProp: %@ equal 22?", _ulProp);
    
}

- (void)testKVO {
    
    //手动触发kvo
    [self willChangeValueForKey:pKey];
    //    [self setValue:@"33" forKey:pKey];
    _ulProp = @"33";
    [self didChangeValueForKey:pKey];
    
    //测试kvo的集合使用
    testBasic *b1 = [[testBasic alloc] initWithName:@"11" age:11];
    testBasic *b2 = [[testBasic alloc] initWithName:@"12" age:12];
    testBasic *b3 = [[testBasic alloc] initWithName:@"13" age:13];
    NSArray *arr = @[b1, b2, b3];
    // 数目 平均值 总和 最大 最小
    NSInteger count = [[arr valueForKeyPath:@"@count.age"] integerValue];
    NSInteger avg = [[arr valueForKeyPath:@"@avg.age"] integerValue];
    NSInteger sum = [[arr valueForKeyPath:@"@sum.age"] integerValue];
    NSInteger max = [[arr valueForKeyPath:@"@max.age"] integerValue];
    NSInteger min = [[arr valueForKeyPath:@"@min.age"] integerValue];
    NSLog(@"coutn:%ld, avg:%ld, sum:%ld, max:%ld, min:%ld", count, avg, sum, max, min);
    
    // 测试NSMutableArray的KVO
    [self.arrT addObject:@"00"]; //不会触发kvo
    // 需要手动触发arrT的内容变化通知
    [self willChangeValueForKey:@"arrT"];
    [self.arrT addObject:@"11"];
    [self didChangeValueForKey:@"arrT"];
    
    // 测试NSMutableString的KVO
    [self.strT appendString:@"aaa"]; //内容变化不会触发
    self.strT = nil; // 指针变化会触发
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@">> keypath:%@", keyPath);
}

@end
