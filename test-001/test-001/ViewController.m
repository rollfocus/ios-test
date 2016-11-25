//
//  ViewController.m
//  test-001
//
//  Created by lin zoup on 11/2/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ca.h"
#import "NSString+reverse.h"
#import "caHeader.h"
#import "AppDelegate.h"

#import "HMCoreDataManager.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *peopleArr;
@property (strong, nonatomic) NSMutableArray *names;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"test Core Data";
    _peopleArr = [NSMutableArray new];
    _names = [NSMutableArray new];
    
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [self fetchNameFromDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchNameFromDB {
    NSFetchRequest *request =  [NSFetchRequest fetchRequestWithEntityName:@"Person"];
//    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", nil];
    NSArray *objects = [kHMCoreDataManager.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *object in objects) {
        [_peopleArr addObject:object];
//        [kHMCoreDataManager.managedObjectContext deleteObject:object];
    }
//    [kHMCoreDataManager.managedObjectContext save:nil];
    
    [self.mainTableView reloadData];
}

- (void)resetDB {
    [kHMCoreDataManager.managedObjectContext reset];
}

- (void)deleteItem:(NSManagedObject *)object {
    //删除一个
    [kHMCoreDataManager.managedObjectContext deleteObject:object];
}

- (void)saveName:(NSString *)name {
    
    NSManagedObjectContext *managedContext = kHMCoreDataManager.managedObjectContext;
    if (!managedContext) {
        NSLog(@">>>>>>> Get managedContext Faild");
        return;
    }
    
    //插入另一个元素
    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:managedContext];
    [person setValue:name forKey:@"name"];
    
    //save
    [managedContext save:nil];
    
    [_peopleArr addObject:person];

    [self.mainTableView reloadData];
}

- (IBAction)addPeople:(id)sender {
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"New"
                                                                      message:@"add a new"
                                                               preferredStyle:UIAlertControllerStyleAlert];
    //添加一个textfield
    [alertCtl addTextFieldWithConfigurationHandler: ^(UITextField *textField) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler: ^(UIAlertAction *action) {
    }];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"save" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
        UITextField *textF = alertCtl.textFields.firstObject;
        if (textF) {
            [self saveName:textF.text];
            [self.mainTableView reloadData];
        } else {
            NSLog(@">>>> add noting, No TextField");
        }
    }];
    
    [alertCtl addAction:cancelAction];
    [alertCtl addAction:saveAction];
    
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _peopleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *name = [_peopleArr[indexPath.row] valueForKey:@"name"];
    cell.textLabel.text = name;
    
    return cell;
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@">>>>> touch began");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //触控压力的改变也会触发touch move事件
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
