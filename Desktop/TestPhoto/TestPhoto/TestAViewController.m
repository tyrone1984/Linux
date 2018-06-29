//
//  TestAViewController.m
//  TestPhoto
//
//  Created by ZJ on 14/07/2017.
//  Copyright © 2017 HY. All rights reserved.
//

#import "TestAViewController.h"

@interface TestAViewController ()

@end

@implementation TestAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testClass = [ASingletonClass shareManager];
    self.testClass.value = @"hahha";
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
