//
//  HMCoreDataManager.h
//  test-001
//
//  Created by lin zoup on 11/25/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kHMCoreDataManager [HMCoreDataManager shareInstance]

@interface HMCoreDataManager : NSObject

//单利类
+(HMCoreDataManager*)shareInstance;


//保存到数据库
- (void)save;

//管理对象上下文
//这里声明为readonly的目的主要是重写get方法使其成为计算型属性
@property (nonatomic,strong,readonly) NSManagedObjectContext *managedObjectContext;

//通过方法返回iOS10的NSPersistentContainer
//如果是iOS9，则返回nil
//该方法的目的主要是便于使用ios10的多线程操作数据库
- (NSPersistentContainer *)getCurrentPersistentContainer;

@end
