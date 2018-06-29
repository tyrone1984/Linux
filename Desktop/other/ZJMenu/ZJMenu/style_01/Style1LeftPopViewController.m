//
//  Style1LeftPopViewController.m
//  Menu
//
//  Created by YunTu on 15/2/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "Style1LeftPopViewController.h"
#import "Style1SubViewController.h"

@interface Style1LeftPopViewController ()<Style1BaseViewControllerDelegate>{
    Style1SubViewController *_style1LeftPopMenuVC;
}

@property (nonatomic, strong) UIImageView *bgIV;
@property (nonatomic, strong) NSMutableArray *images;

@end

#ifndef kScreenW

#define kScreenW    ([UIScreen mainScreen].bounds.size.width)
#define kScreenH    ([UIScreen mainScreen].bounds.size.height)

#endif

@implementation Style1LeftPopViewController

#pragma mark - View lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSettiing];
}

- (void)initSettiing {
    [self initItem];
    
    _style1LeftPopMenuVC = [[Style1SubViewController alloc] init];
    _style1LeftPopMenuVC.delegate = self;
}

- (void)initItem {
    self.bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64)];
    self.bgIV.image = [UIImage imageNamed:@"img4.jpg"];
    self.bgIV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.bgIV];
    
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                    };
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    // leftItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"PopItem"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(leftItemAction)];
    // rightItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Back"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(rightItemAction)];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)leftItemAction {
    [_style1LeftPopMenuVC showOrHideSideMenu];
}

 /**
 *  pop
 */
- (void)rightItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Style1BaseViewControllerDelegate

- (void)style1BaseViewControllerEventWithIndex:(NSIndexPath *)indexPath {
    self.bgIV.image = self.images[indexPath.row];
}

- (NSArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
        
        for (int i = 0; i < 5; i++) {
            [_images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"img%d.jpg", i]]];
        }
    }
    
    return _images;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [_style1LeftPopMenuVC.view removeFromSuperview];
    _style1LeftPopMenuVC = nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
