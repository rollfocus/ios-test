//
//  transferVIew.m
//  test-001
//
//  Created by lin zoup on 3/7/17.
//  Copyright © 2017 cDuozi. All rights reserved.
//

#import "transferVIew.h"

@interface transferVIew ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation transferVIew

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

- (void) initSubViews {
    // add label
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    textF.backgroundColor = [UIColor whiteColor];
    textF.textColor = [UIColor blackColor];
    [self addSubview:textF];
    _textField = textF;
    // add button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 100, 30)];
//    btn.view
    btn.titleLabel.font = [UIFont systemFontOfSize:9.0];
    [btn setTitle:@"tranform" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doTransfer) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
//    self.layer.transform = CATransform3DMakeScale(-1.0, -1.0, 1.0);
    self.layer.transform = CATransform3DMakeScale(2.0, 0.8, 1.0);//缩放处理
    self.backgroundColor = [UIColor orangeColor];
    
    
}

- (void) doTransfer {
    CGFloat scale = _textField.text.floatValue;
//    self.layer.transform = CATransform3DMakeScale(0, 0, scale);
    
    
    
    self.layer.affineTransform = CGAffineTransformMakeRotation(45.0);
    
    //        [self setNeedsDisplay];
}

@end
