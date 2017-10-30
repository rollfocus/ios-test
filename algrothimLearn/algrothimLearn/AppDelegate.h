//
//  AppDelegate.h
//  algrothimLearn
//
//  Created by lin zoup on 12/9/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

