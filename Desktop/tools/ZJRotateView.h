//
//  ZJRotateView.h
//  ZJFramework
//
//  Created by ZJ on 6/15/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJRotateView : UIView

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

- (void)beganAnimation;
- (void)pauseAnimation;
- (void)resumeAnimation;
- (void)removeAnimation;

@end
