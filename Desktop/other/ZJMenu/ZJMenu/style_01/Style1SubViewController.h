//
//  Style1SubViewController.h
//  Menu
//
//  Created by YunTu on 15/2/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "Style1BaseViewController.h"

@protocol Style1BaseViewControllerDelegate <NSObject>

- (void)style1BaseViewControllerEventWithIndex:(NSIndexPath *)indexPath;

@end

@interface Style1SubViewController : Style1BaseViewController

@property (nonatomic, weak) id <Style1BaseViewControllerDelegate>delegate;

@end
