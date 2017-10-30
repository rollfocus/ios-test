//
//  testRuntime.m
//  test-001
//
//  Created by lin zoup on 11/29/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testRuntime.h"

#import <objc/message.h>
#import <objc/runtime.h>


// To explore more about runtime programming, there’s no better place than Apple’s documentation
// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008048

// 动态添加的函数
void testW(id self, SEL _cmd) {
    
    NSLog(@"Here is the testW function");
}

void testV(id self, SEL _cmd) {
    
    NSLog(@"Here is the testV function");
}



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
    
    NSLog(@"Here is the test function");
    
    [self testClass];
    [self testMethod];
    
    
    [self testRuntimeFun];
}

- (void)testT {
    
    NSLog(@"Here is the testT function");
}

- (void)testF {
    
    NSLog(@"Here is the testF function");
}


- (void)testClass {
    
    [self testClassIsa];

    //查看 [self class] 和 [testRuntime class]
    id cls = [self class]; //这个返回的也是class
    void *ojc = &cls;
    id clsC = [testRuntime class]; // clsC 是class对象  它的 isa 指针指向 meta class
    void *ojcC = &clsC;
    //地址并不同, 废话，取的是两个临时变量的地址 当然不同了 妹的
    NSLog(@">>> %d, %d", ojc, ojcC);
    // Class不是指针吗
    void *aa = (__bridge void *)([self class]);
    void *bb = (__bridge void *)([testRuntime class]);
    NSLog(@">>> %d, %d", aa, bb);//地址相同
    NSLog(@">>> %@, %@", aa, bb);//返回的是一个字符串???
    
    //pritn class 的 isa 走向
    Class currentClass = [self class];
    int i = 1;
    while (currentClass) {
        char * name = class_getName(currentClass);
        // class与meta-class名称是一致的，但是地址不一致，一致超照到NSObjec及其meta-class
        NSLog(@">> Following isa pointer %d, gieves %p %s",
              i++, currentClass, name);
        
        //获取对象isa指向
        Class oldClass = currentClass;
        currentClass = object_getClass(currentClass);
        // 两个class相同，说明已经走到NSObjec的meta-class，其isa指针指向自身，为终点
        if (oldClass == currentClass) {
            break;
        }
    }
    //isMemberOfClass实现方法？
    [((id)[NSObject class]) isMemberOfClass:[NSObject class]];
    
    //动态创建并注册一个类, 添加方法及成员
    Class newClass = objc_allocateClassPair([testRuntime class], "myNewClass", 0);
    class_addMethod(newClass, @selector(testV), (IMP)testV, "v@:");
    class_addIvar(newClass, "testIvar", sizeof(id), log2(sizeof(id)), "@");
    objc_registerClassPair(newClass);
    // call
    id clsInstance = [newClass new];
    [clsInstance setValue:@"Hi? runtime Ivar" forKey:@"testIvar"];
    NSString *value = [clsInstance valueForKey:@"testIvar"];
    NSLog(@">>>> testIvar:%@", value);
    // call method, use objc_msgSend
    // 参考：http://stackoverflow.com/questions/24922913/too-many-arguments-to-function-call-expected-0-have-3
    SEL selector = @selector(testV);
    [clsInstance performSelector:@selector(testV)];
    typedef void (*send_type)(id, SEL, void*);
    send_type methodIns = (send_type)[clsInstance methodForSelector:selector];
    methodIns(clsInstance, selector, nil);
    // call objc_msgSend
    send_type msgSend = (send_type)objc_msgSend;
    msgSend(clsInstance, selector, nil);
    
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
    
    // 动态添加的方法， 使用 [self class] 跟 [testRuntime class], 都是添加了实例方法
    class_addMethod([self class], @selector(testW), (IMP)testW, "v@:");
    // performSelector 调用动态加载的函数
    [self performSelector:@selector(testW) withObject:nil];
    [self testRuntimeFun];
    class_addMethod([testRuntime class], @selector(testP), (IMP)testW, "v@:");
    testRuntime *newR = [testRuntime new];
    [newR performSelector:@selector(testP) withObject:nil];
    [self testRuntimeFun];
    
    
    // test method enchange
    [self testExchangeMethod];
    
    [self testClassName];
}

- (void)testClassName {
    NSLog(@"%@, %@", [self class], [super class]);
}

- (void)testExchangeMethod {
    
    //获取类方法
    Method mtTestF = class_getInstanceMethod([self class], @selector(testF));
    Method mtTestT = class_getInstanceMethod([self class], @selector(testT));
    
    [self testT];
    method_exchangeImplementations(mtTestF, mtTestT);
    //执行testT 测试
    [self testT];
    
}


- (void)testClassIsa {
    
    // id是一个对象指针  typedef struct objc_object *id;
    // struct objc_object {
    //     Class isa  OBJC_ISA_AVAILABILITY;
    // };

    // typedef struct objc_class *Class; class isa实际上也是一个实例对象
    id cls = [testRuntime class];// class
    void *obj = &cls; // 实际相当于ojc是class 实例了
    // 相当于将obj的isa指向 [testRuntime class], 那么系统把obj当做一个testRuntime的实例
    [(__bridge id)obj methodOne]; //输出正常, id类型可直接调用
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
    NSLog(@"****** instance class methods *********");
    // method 打印所有函数
    Method *methods = class_copyMethodList([self class], &mCount);
    for (i = 0; i < mCount; i++) {
        // SEL 类型其实就是一个字符串
        NSLog(@"** %s", sel_getName(method_getName(methods[i])));
    }
    // method 打印所有类函数
    NSLog(@"****** class class methods *********");
    methods = class_copyMethodList([testRuntime class], &mCount);
    for (i = 0; i < mCount; i++) {
        // SEL 类型其实就是一个字符串
        NSLog(@"** %s", sel_getName(method_getName(methods[i])));
    }


    NSLog(@"test end");
}


#pragma mark - ** _objc_msgForward **
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
