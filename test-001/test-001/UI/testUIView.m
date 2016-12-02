//
//  testUIView.m
//  test-001
//
//  Created by lin zoup on 12/1/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testUIView.h"
#import "testTableViewCell.h"

@implementation testUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)test {
    // 使用 initWithStyle 将调用 awakeFromXib？
    [[NSBundle mainBundle] loadNibNamed:@"testTableViewCell" owner:self options:nil];
//    [testTableViewCell alloc] initi
    
//    testTableViewCell *tCell = [[testTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
}

@end
