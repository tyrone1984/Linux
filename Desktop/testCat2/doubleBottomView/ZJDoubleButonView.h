//
//  ZJDoubleButonView.h
//  CanShengHealth
//
//  Created by ZJ on 01/02/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJDoubleButonView;

@protocol ZJDoubleButonViewDelegate <NSObject>

- (void)doubleButonView:(ZJDoubleButonView *)view didClickButtonAtIndex:(NSInteger)index;

@end

@interface ZJDoubleButonView : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *titleColors;
@property (nonatomic, strong) NSArray *bgColors;
@property (nonatomic, weak) id<ZJDoubleButonViewDelegate> delegate;

@end
