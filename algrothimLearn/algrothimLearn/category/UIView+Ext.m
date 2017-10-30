//
//  UIView+Ext.m
//  algrothimLearn
//
//  Created by lin zoup on 12/9/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "UIView+Ext.h"

@implementation UIView (frame)

- (void)setTop:(CGFloat)top {
    // category 不支持属性的
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

@end
