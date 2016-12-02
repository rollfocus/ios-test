//
//  testTableViewCell.m
//  test-001
//
//  Created by lin zoup on 12/1/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "testTableViewCell.h"

@implementation testTableViewCell

- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 读取runtime属性
    // 在xib的 “User Defined Runtime Attributes” 中添加的改动的属性
    // 注意：改动的key是没有检查机制的，所以要保证key存在，否则会出现undefined key的crash
    NSString *value = [self valueForKey:@"rtProp"];
    NSLog(@"xib runtime property: rtProp:%@ is mazing?", value);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
