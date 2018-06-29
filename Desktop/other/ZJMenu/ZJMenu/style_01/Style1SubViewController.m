//
//  Style1SubViewController.m
//  Menu
//
//  Created by YunTu on 15/2/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "Style1SubViewController.h"

@interface Style1SubViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *_menuTableView;
}

@end

static NSString *sidebarMenuCellIdentifier = @"CellIdentifier";

@implementation Style1SubViewController

#pragma mark - View lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSettiing];
}

- (void)initSettiing {
    [self createTableView];
}

- (void)createTableView {
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 54, self.contentView.frame.size.width, self.contentView.frame.size.height-54) style:UITableViewStylePlain];
    _menuTableView.backgroundColor  = [UIColor clearColor];
    _menuTableView.delegate         = self;
    _menuTableView.dataSource       = self;
    _menuTableView.tableFooterView = [UIView new];
    [self.contentView addSubview:_menuTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sidebarMenuCellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sidebarMenuCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"menu%zd", indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.delegate respondsToSelector:@selector(style1BaseViewControllerEventWithIndex:)]) {
        [self.delegate style1BaseViewControllerEventWithIndex:indexPath];
    }
    
    [self showOrHideSideMenu];
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
