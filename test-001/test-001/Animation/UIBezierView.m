//
//  UIBezierView.m
//  test-001
//
//  Created by lin zoup on 3/21/17.
//  Copyright © 2017 cDuozi. All rights reserved.
//

#import "UIBezierView.h"

@implementation UIBezierView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        [self addBezierLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addBezierLayer];
    }
    return self;
}


- (void)addBezierLayer {
    // 圆角
    CAShapeLayer *layer1 = [CAShapeLayer new];
    UIBezierPath * roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 40, 40, 40) cornerRadius:6];
    layer1.path = roundPath.CGPath;
    layer1.fillColor = [UIColor yellowColor].CGColor;
    layer1.strokeColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:layer1];
    
    //曲线
    CAShapeLayer *layer2 = [CAShapeLayer new];
    CGPoint p1 = CGPointMake(10, 200);
    CGPoint p2 = CGPointMake(100, 100);
    CGPoint p3 = CGPointMake(190, 200);
    UIBezierPath *curvePath= [UIBezierPath new];
    [curvePath moveToPoint:p1];
    [curvePath addQuadCurveToPoint:p3 controlPoint:p2];
    layer2.path = curvePath.CGPath;
    layer2.fillColor = [UIColor clearColor].CGColor;
    layer2.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:layer2];
}

@end
