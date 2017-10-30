//
//  AGMainViewController.m
//  algrothimLearn
//
//  Created by lin zoup on 12/9/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "AGMainViewController.h"
#import "CodeContent.h"

@interface AGMainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CodeContent *cContent;

@end

@implementation AGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    self.navigationController.title = @"算法";
//    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor yellowColor];//bar背景色设置
    self.title = @"算法";

    [self initSubViews];
    _cContent = [CodeContent new];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    _tableView = nil;
}

- (void)initSubViews {
    
    _tableView = [[UITableView alloc] initWithFrame:screenBounds
                                              style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // iOS7.0后状态栏就属于view的一部分，所以对于7.0以后的版本做一些处理
//    if (!AG_IS_IOS7) {
//        //        _tableView.top += 20;
//        _tableView.top += 64;
//    }
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

#pragma mark - Table view datasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *identifier = @"AGCategoryHeader";
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [UIView new];
        headerView.backgroundColor = [UIColor orangeColor];
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, screenWidth, 30);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13.0];
        label.text = @"我是类别";
        [headerView addSubview:label];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell new];
    //    [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewCellAccessoryNone];
    //    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.selectedBackgroundView.backgroundColor = [UIColor yellowColor];//不奏效？
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, screenWidth, 30);
    label.text = @"我是具体题目";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12.0];
    [cell addSubview:label];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30 * AG_Factor_iPhone5s_320;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 * AG_Factor_iPhone5s_320;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//尽量不要这么操作
    //    cell.backgroundColor = [UIColor yellowColor];
    
    UIViewController *pushVC = [UIViewController new];
    pushVC.view.backgroundColor = [UIColor orangeColor];
    [self.navigationController pushViewController:pushVC animated:YES];
}

@end
