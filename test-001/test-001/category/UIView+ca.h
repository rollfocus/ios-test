//
//  UIView+ca.h
//  test-001
//
//  Created by lin zoup on 11/2/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ca)

//添加属性测试, 不会生成变量，只会生成属性方法；
@property (nonatomic, strong) NSString *catStr;

- (void)init:(NSInteger)index name:(NSString *)name;



@end
