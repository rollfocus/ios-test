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


// load and initialize
+ (void)load {
    NSLog(@">> when to load? it will execute before main function");
}

+ (void)initialize {
    NSLog(@"invoke when first message will execute");
}


- (void)test {
    
    [self testMethod];
    [self testClassIsa];
    
    [self testRuntimeFun];
}

- (void)testMethod {
    
    // 直接使用函数指针变量
    void (*setter)(id, SEL, BOOL);
    // 返回IMP
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
    NSLog(@">> %ld, %@", self.propInt, self.propStr);
}

- (void)addVars {
    //不能向编译后的类中添加实例变量，能向运行时创建的类中添加实例变量
}


- (void)testRuntimeFun {
    
    // relative function
    const char *className = object_getClassName(self);
    NSLog(@">>> class name:%s", className);
    
    unsigned int i, vCount, pCount, mCount;
    // 复制方法及变量、协议
    // 变量
    Ivar *vars = class_copyIvarList([self class], &vCount);
    for (i = 0; i < vCount; i++) {
        NSLog(@"$$ %s", ivar_getName(vars[i]));
    }
    // 属性
    // 属性的类型编码参考 https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
    objc_property_t *propes = class_copyPropertyList([self class], &pCount);
    for (i = 0; i < pCount; i++) {
        NSLog(@">> %s, %s", property_getName(propes[i]), property_getAttributes(propes[i]));
    }
    // method 打印所有函数
    Method *methods = class_copyMethodList([self class], &mCount);
    for (i = 0; i < mCount; i++) {
        // SEL 类型其实就是一个字符串
        NSLog(@"** %s", sel_getName(method_getName(methods[i])));
    }

    NSLog(@"test end");
}


// 消息发送前的三个处理函数
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    //在这里可以添加一个函数实现，如果添加了，系统会重新启动一次消息发送过程
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    // 在这里可以把消息转发给其他对象, 如果返回的不是nil或者self，那么消息会被重新发送到新对象
    id someOtherObject;
    if ([someOtherObject respondsToSelector:aSelector]) {
        return someOtherObject;
    }
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    // 为另一个类实现的消息创建一个有效的方法签名，必须实现！
    // 并且，必须返回不为空的methodSignature，否则会crash
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        // create one
        // 如果函数类型是 (void)setName:(NSString)name, 那么需要用 "v@:@" 参数
        // v代表void，@:@代表self,_cmd,函数para，的参数类型为id，SEL，NString
        // self, _cmd 是函数默认隐藏的两个类型， _cmd指向方法本身；
        // 参见工程中 testBasic 中 testTypeEncode 中的参数编码测试
        // 类型编码参见：https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
        signature = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    id someOtherObject;
    if ([someOtherObject respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:someOtherObject];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    //如果selector未被实现 默认是抛出异常
}

// 测试函数
- (void)methodOne {
    NSLog(@" %s: I am methodOne and excceted!!!", __func__);
}

- (void)methodTwo:(BOOL)sw {
    NSLog(@">>> %s: I am method 2!", __func__);
}

- (void)methodPrivate {
    NSLog(@">>> I am %s!", __func__);
}

@end
