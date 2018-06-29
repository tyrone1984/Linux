//
//  ZJDoubleButonView.m
//  CanShengHealth
//
//  Created by ZJ on 01/02/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJDoubleButonView.h"

@interface ZJDoubleButonView()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;

@end

@implementation ZJDoubleButonView

- (IBAction)btnEvent:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(doubleButonView:didClickButtonAtIndex:)]) {
        [self.delegate doubleButonView:self didClickButtonAtIndex:sender.tag];
    }
}

#pragma mark - setter

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    for (UIButton *btn in self.btns) {
        [btn setTitle:_titles[btn.tag] forState:UIControlStateNormal];
    }
}

- (void)setTitleColors:(NSArray *)titleColors {
    _titleColors = titleColors;
    
    for (UIButton *btn in self.btns) {
        [btn setTitleColor:_titleColors[btn.tag] forState:UIControlStateNormal];
    }
}

- (void)setBgColors:(NSArray *)bgColors {
    _bgColors = bgColors;
    
    for (UIButton *btn in self.btns) {
        btn.backgroundColor = _bgColors[btn.tag];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (UIButton *btn in self.btns) {
        btn.layer.cornerRadius = 8.0;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
