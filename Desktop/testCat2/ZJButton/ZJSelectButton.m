//
//  ZJSelectButton.m
//  ButlerSugar
//
//  Created by ZJ on 2/26/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import "ZJSelectButton.h"

@implementation ZJSelectButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    }
    return self;
}

- (void)setSelect:(BOOL)select {
    _select = select;
    
    [self setImage:[_select ? self.selectImg : self.unSelectImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)setSelectImgName:(NSString *)selectImgName {
    _selectImgName = selectImgName;
    
    self.selectImg = [[UIImage imageNamed:_selectImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)setUnSelectImgName:(NSString *)unSelectImgName {
    _unSelectImgName = unSelectImgName;
    
    self.unSelectImg = [[UIImage imageNamed:_unSelectImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
