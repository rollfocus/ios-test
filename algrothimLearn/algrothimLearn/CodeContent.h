//
//  CodeContent.h
//  algrothimLearn
//
//  Created by lin zoup on 12/9/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import <Foundation/Foundation.h>

//算法类别及题目数据结构定义
typedef struct {
    char *title;
} AGCategory;

typedef struct{
    char **content;
    unsigned int count;
} AGItem;


@interface CodeContent : NSObject

@end
