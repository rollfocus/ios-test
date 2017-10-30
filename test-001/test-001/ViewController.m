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

#import "testTouchEvent.h"
#import "transferVIew.h"
#import "UIBezierView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *peopleArr;
@property (strong, nonatomic) NSMutableArray *names;

@property (strong, nonatomic) UIDynamicAnimator *dAnimator;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@" >>>> %s %s", object_getClassName(self), __func__);
    
    //测试view中autorelease
    __weak NSString *oStr;
    @autoreleasepool {
        NSString *str = [NSString stringWithFormat:@"auto relese test"];
        oStr = str;
    }
    //释放了
    NSLog(@"%@", oStr);

    
    self.title = @"test Core Data";
    _peopleArr = [NSMutableArray new];
    _names = [NSMutableArray new];
    
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [self fetchNameFromDB];
    
    NSMutableArray<NSString *> *arr = [NSMutableArray new];
    [arr addObject:@1];
    
    object_getClassName(self);
    
    // test hittest
//    [testTouchEvent showTouchView];
    
    // test tranform view
    transferVIew *tView = [[transferVIew alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    tView.backgroundColor = [UIColor orangeColor];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:tView];
    
    // add button to test present viewcontroller
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 100, 80)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"Click me" forState:UIControlStateNormal];
    //    btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mainTableView addSubview:btn];
    
    
    btn.transform = CGAffineTransformRotate(btn.transform, 45.0);
    
    UIDynamicAnimator *dA = [[UIDynamicAnimator alloc] initWithReferenceView:self.mainTableView];
    UIGravityBehavior *gB = [[UIGravityBehavior alloc] initWithItems:@[btn]];
    [dA addBehavior:gB];
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[btn]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [dA addBehavior:collisionBehavior];
    self.dAnimator = dA;
    
    
    [self performSelector:@selector(dropBtn:) withObject:btn afterDelay:2.0];
    
}

- (void) dropBtn:(UIButton *)btn {
    btn.frame = CGRectMake(200, 350, 100, 80);
}

- (void) btnClick {
    UIViewController *newCtl = [UIViewController new];
    newCtl.view.backgroundColor = [UIColor orangeColor];
    __weak UIViewController *weakCtl = newCtl;
    [self presentViewController:newCtl animated:YES completion:^{
//        sleep(1);
        usleep(200 * 1000); // 0.2s
        [weakCtl dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
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

#pragma mark - table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _peopleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *name = [_peopleArr[indexPath.row] valueForKey:@"name"];
    cell.textLabel.text = name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            UIViewController *vc = [UIViewController new];
            vc.view.backgroundColor= [UIColor whiteColor];
            UIBezierView *brView = [[UIBezierView alloc] init];
            brView.frame = CGRectMake(0, 0, 300, 400);
            [vc.view addSubview:brView];
            //add bezier view
            [self presentViewController:vc animated:YES completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)(3 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(),
                           ^{
                [vc dismissViewControllerAnimated:YES completion:nil];
            });
        }
            break;
            
        default:
            break;
    }
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
