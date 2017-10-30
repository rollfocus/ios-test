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


@interface testBasic () {
 
    int structMem;
}

@end

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
    
    NSLog(@">>>>>>  testbasic dealloc ....");
}

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age {
    if (self = [self init]) {
        _name = name;
        _age = age;
    }
    return self;
}

- (void)test {
    
    // test struct member
    self->structMem = 10;

    [self testInvokeFunction];

    [self testTypeEncode];

    [self testSetValue];
    [self testKVO];
    
    [self testDataStruct];
}

- (void)testInvokeMethod {
    NSLog(@">> hi, i am testInvokeMethod");
}

- (void)bgMethod {
    
    // 因为是在背景线程中执行 需要内部建立自己的 Autorelease Pool
    @autoreleasepool {
        NSLog(@">> hi, i am bgMethod");

        //执行完毕通知主线程调用
        [self performSelectorOnMainThread:@selector(testInvokeMethod)
                               withObject:nil waitUntilDone:NO];
    }
}

- (void)testInvokeFunction {
    // check resonse
    NSLog(@"%d, %d",
          [self respondsToSelector:@selector(testKVO)],
          [self respondsToSelector:@selector(testHi)]);
    
    // test selector string
    NSLog(@">> selector actually is: %s",
          (char *)(@selector(observeValueForKeyPath:ofObject:change:context:)));
    // test call function
    [self testInvokeMethod];
    [self performSelector:@selector(testInvokeMethod)];
    [self performSelector:@selector(testInvokeMethod) withObject:nil];
    [self performSelector:@selector(testInvokeMethod) withObject:nil afterDelay:2];
    //背景执行，实际是另创建一条线程执行；注意，背景执行时要在method内部建立自己的 autorelease pool
    [self performSelectorInBackground:@selector(bgMethod) withObject:nil];
    //    [self performSelector:@selector(testNotExist)];// selector is not exist, will crash
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(testInvokeMethod)
                                               object:nil];
    
    //会一直执行
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                    selector:@selector(testInvokeMethod)
                                                    userInfo:nil repeats:NO];
    
    [NSString defaultCStringEncoding];//? ?
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
    
    [NSString string];
    [NSMutableArray array];
    NSStringFromClass([[NSMutableString string] class]);
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

- (void)testDataStruct {
    
    NSArray *newArr = @[@1,@4,@2,@5];
    // localizedCompare只适应于NSString
    // compare 是默认的比较方法
    NSArray *sortedArr = [newArr sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"sorted arr: %@", sortedArr);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@">> keypath:%@", keyPath);
}

@end
