//
//  animationView.m
//  test-001
//
//  Created by lin zoup on 3/8/17.
//  Copyright © 2017 cDuozi. All rights reserved.
//

#import "animationView.h"

@interface animationView ()

@property (strong, nonatomic) UIDynamicAnimator *dAnimator;

@end

@implementation animationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addAnimateBtn];
}

- (void)addGravityBtn {
    
    // add button to test present viewcontroller
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 100, 80)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"Click me" forState:UIControlStateNormal];
    //    btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self addSubview:btn];
    
    UIDynamicAnimator *dA = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    UIGravityBehavior *gB = [[UIGravityBehavior alloc] initWithItems:@[btn]];
    [dA addBehavior:gB];
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[btn]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [dA addBehavior:collisionBehavior];
    self.dAnimator = dA;
}

- (void)addAnimateBtn {
    //add a button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"Click me" forState:UIControlStateNormal];
    //    btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:2.0 animations:^{
        btn.backgroundColor = [UIColor greenColor];
        btn.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
    } completion:^(BOOL finished){
        //关键帧动画
        [UIView animateKeyframesWithDuration:3.0 delay:0
                                     options:UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionAutoreverse
                                  animations:^{
                                      //startTime durTime 都是相对比例时间
                                      [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
                                          btn.backgroundColor = [UIColor blackColor];
//                                          btn.frame = CGRectMake(50, 50, 100, 100);
                                      }];
                                      [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.3 animations:^{
                                          btn.backgroundColor = [UIColor orangeColor];
//                                          btn.frame = CGRectMake(150, 150, 100, 100);
                                      }];
                                      [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.4
                                                                    animations:^{
                                                                        
                                                                        btn.backgroundColor = [UIColor blueColor];
//                                                                        btn.frame = CGRectMake(50, 350, 100, 100);
                                                                        btn.transform = CGAffineTransformMakeRotation(45.0);
                                                                    }];
                                  } completion:nil];
        
    }];
    
    [self addSubview:btn];
}

@end
