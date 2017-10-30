//
//  UIView+Ext.h
//  algrothimLearn
//
//  Created by lin zoup on 12/9/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

// 类别不支持属性的，需要动态添加
//@property (nonatomic, assign) CGFloat top;

// 只用于声明
@property CGFloat top;


- (CGFloat)top;

@end
