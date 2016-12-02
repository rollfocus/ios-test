//
//  testRuntime.m
//  test-001
//
//  Created by lin zoup on 11/29/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testRuntime.h"
#import <objc/runtime.h>

@implementation testRuntime

@synthesize propInt; //这样会生成propInt变量而不是_propInt变量
@synthesize propStr = _myPropStr;

- (void)test {
    
    [self testMethod];
    [self testClassIsa];
}

- (void)testMethod {
    
    // 直接使用函数指针变量
    void (*setter)(id, SEL, BOOL);
    //返回IMP
    setter = (void (*)(id, SEL, BOOL))[self methodForSelector:@selector(methodTwo:)];
    // 执行了method2
    setter(self, @selector(methodTwo:), YES);
    
    
    //定义一个函数指针类型
    typedef void (*SETTER)(id, SEL, BOOL);
    SETTER tSetter = (SETTER)[self methodForSelector:@selector(methodTwo:)];
    tSetter(self, @selector(methodTwo:), YES);
}

- (void)testClassIsa {
    
    id ins = [[NSString alloc] init];
    NSString *str = [NSString new];
    
    // id是一个对象指针
    // typedef struct objc_class *Class; class实际上也是一个实例对象
    id cls = [testRuntime class];
    void *obj = &cls;
    // 相当于将obj的isa指向 [testRuntime class], 那么系统把obj当做一个testRuntime的实例
    [(__bridge id)obj methodOne]; //输出正常
}

- (void)testProperty {
    NSLog(@">> %ld, %@", propInt, _myPropStr);
    self.propInt;
    self.propStr;
}

- (void)addVars {
    //不能向编译后的类中添加实例变量，能向运行时创建的类中添加实例变量
}


- (void)testRuntimeFun {
    
    // relative function
    const char *className = object_getClassName(self);
    NSLog(@">>> class name:%s", className);
    
    unsigned int count;
    Method *methods = class_copyMethodList([self class], &count);
    Ivar *vars = class_copyIvarList([self class], &count);
    
    
//    objc_setAssociatedObject(self, <#const void *key#>, <#id value#>, <#objc_AssociationPolicy policy#>)
//    objc_getAssociatedObject(<#id object#>, const void *key)
    
//    objc_msgSend
}


// load and initialize
+ (void)load {
    NSLog(@">> when to load? it will execute before main function");
}

+ (void)initialize {
    NSLog(@"invoke when first message will execute");
}

// 消息发送前的三个处理函数
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    //在这里可以添加一个函数实现，如果添加了，系统会重新启动一次消息发送过程
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    // 在这里可以把消息转发给其他对象, 如果返回的不是nil或者self，那么消息会被重新发送到新对象
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    //如果selector未被实现 默认是抛出异常
}

// 测试函数
- (void)methodOne {
    NSLog(@"I am methodOne and excceted!!!");
}

- (void)methodTwo:(BOOL)sw {
    NSLog(@">>> I am method 2!");
}


@end
