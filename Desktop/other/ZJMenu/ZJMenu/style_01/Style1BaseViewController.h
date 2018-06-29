//
//  Style1BaseViewController.h
//  Menu
//
//  Created by YunTu on 15/2/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kSidebarWidth
#define kSidebarWidth 240.0 // 侧栏宽度，设屏宽为320，右侧留一条空白可以看到背后页面内容
#endif

@interface Style1BaseViewController : UIViewController

@property (nonatomic, retain) UIView *contentView;   // 所有要显示的子控件全添加到这里

/**
 * @brief 执行显示/隐藏侧边菜单
 */
- (void)showOrHideSideMenu;

@property (nonatomic, strong, readonly) UIViewController *rootViewController;

@end
