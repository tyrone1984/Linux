//
//  ViewController.m
//  ZJMenu
//
//  Created by ZJ on 3/15/17.
//  Copyright © 2017 HY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_cellTitles, *_vcNames;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *SystemTableViewCell = @"cell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettiing];
}

- (void)initAry {
    _cellTitles = @[@"抽屉式菜单"];
    
    _vcNames = @[@"Style1LeftPopViewController"];
}

- (void)initSettiing {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SystemTableViewCell];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    cell.textLabel.text = _cellTitles[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [NSClassFromString(_vcNames[indexPath.row]) new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
