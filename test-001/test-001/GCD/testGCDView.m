//
//  testGCDView.m
//  test-001
//
//  Created by lin zoup on 11/22/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testGCDView.h"
#import "caHeader.h"

@implementation testGCDView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        [self beginTest];
    }
    return self;
}

- (void)beginTest {
    [self testDSPAsync];
    [self testPerformSelector];
}

- (void)testPerformSelector {
    //waitUntilDone指定是否要阻塞当前线程，直到代码块执行完；当前线程为主线程的话该参数无效；
    //该方法主要用于主线程修改页面UI的状态
    [self performSelectorOnMainThread:@selector(addAWin) withObject:nil waitUntilDone:NO];
}

- (void)addAWin
{
    UIView *titleView = [[UIView alloc] init];
    CGRect rect = CGRectMake((screenWidth - 100 )/2, 0, 100, 20);
    titleView.frame = rect;
    titleView.backgroundColor = [UIColor orangeColor];
    [self addSubview:titleView];
}


- (void)testDSPAsync {
    [self addVeryMuchButtons];
}

- (void) addVeryMuchButtons
{
    //需要在异步中处理，因为添加按钮太多会阻塞主线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^() {
                       //属于在异步线程中retain self，只是单向引用，不是循环引用
                       [self refreshBtns];
                   });
}


- (void)refreshBtns
{
    @autoreleasepool {
        CGFloat posX = 0;
        CGFloat posY = 30;
        CGFloat buttonWid = 80;
        CGFloat buttonHei = 25;
        for (NSInteger i = 0; i < 100; i ++)
        {
            //循环快内使用autoreleasepool加快不再需要内存的释放
            @autoreleasepool {
                //即时释放内存
                UIButton *btn = [[UIButton alloc] init];
                btn.backgroundColor = [UIColor purpleColor];
                
                if ((posX + buttonWid) > screenWidth) {
                    posX = posX + buttonWid - screenWidth;
                    posX = 0;
                    posY += buttonHei + 5;
                }
                
                btn.frame = CGRectMake(posX, posY, buttonWid, buttonHei);
                posX += buttonWid + 5;
                
                //需要在这 main queue 中刷新显示，否则要等到runloop结束才显示
                dispatch_async(dispatch_get_main_queue(), ^() {
                    [btn setTitle:[NSString stringWithFormat:@"btn%ld", i]
                         forState:UIControlStateNormal];
                    [self addSubview:btn];
                });
            }
            
            usleep(100);
        }
    }
}


@end
