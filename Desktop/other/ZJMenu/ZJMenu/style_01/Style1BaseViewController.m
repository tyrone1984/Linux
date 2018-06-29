//
//  Style1BaseViewController.m
//  Menu
//
//  Created by YunTu on 15/2/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "Style1BaseViewController.h"
#import <Accelerate/Accelerate.h>

@interface Style1BaseViewController ()<UIGestureRecognizerDelegate>{
//    AppDelegate *_appDelegate;
    
    UIView *_blurView;

    CGFloat _red, _green, _blue;
    
    CGPoint _startTouchPoint;        // 手指按下时的坐标
    CGFloat _startContentOriginX;    // 移动前的窗口位置
    
    BOOL _isMoving;
}

@property (nonatomic, assign) BOOL isSideMenuShown;

@end

#define duration 0.3

@implementation Style1BaseViewController

#pragma mark - View lifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setBgRGB:0x000000];
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        [window addSubview:self.view];
        //手势
        UIPanGestureRecognizer *_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        
        [window addGestureRecognizer:_panGestureRecognizer];   // 有点不合理
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"stouchP = %f", _startTouchPoint.x);
    [self initSetting];
}

- (void)initSetting {
    self.view.backgroundColor = [UIColor clearColor];
    
    _blurView = [[UIView alloc] initWithFrame:self.view.bounds];
    _blurView.alpha = 0.0;
    [self.view addSubview:_blurView];
    
    //手势
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
    //contentView
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(-kSidebarWidth, 0, kSidebarWidth, self.view.bounds.size.height)];
    self.contentView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.contentView];
    
    self.view.hidden = YES;
}

- (void)showOrHideSideMenu {
    if (self.isSideMenuShown == NO) {   //x = -240
        [self showMenuAnimation];
    }else{                              //x > -240  //  x == 0
        [self hidenMenuAnimation];
    }
}

#pragma mark - private method

- (BOOL)isSideMenuShown {
    return self.contentView.frame.origin.x > -kSidebarWidth ? YES : NO;
}

/**
 * @brief 设置侧栏的背景色，参数为16进制0xffffff的形式
 */
- (void)setBgRGB:(long)rgb{
    _red    = ((float)((rgb & 0xFF0000) >> 16)) / 255.0;
    _green  = ((float)((rgb & 0xFF00) >> 8)) / 255.0;
    _blue   = ((float)(rgb & 0xFF)) / 255.0;
}

/*
 * 设置侧栏相对于开始点击时的偏移
 * offset >= 0 向右，offset < 0向左
 */
- (void)setSideMenuOffsetX:(CGFloat)offset {
    CGRect rect = self.contentView.frame;
    
    if (offset >= 0) { // 右滑
        if (rect.origin.x < 0) {                // 如果不在最右
            rect.origin.x = _startContentOriginX + offset;  //直接向右偏移这么多
            if (rect.origin.x > 0) {
                rect.origin.x = 0;
            }
        }
    }else {            // 左滑
        if (rect.origin.x > -kSidebarWidth) {   // 如果不在最左
            rect.origin.x = _startContentOriginX + offset;
            if (rect.origin.x < -kSidebarWidth) {
                rect.origin.x = -kSidebarWidth;
            }
        }
    }
    
    [self changeContentViewAndBlueViewBgEffect];
    
    [self.contentView setFrame:rect];
}

/*
 * 设置侧栏位置
 * 完全不显示时为x = -kSidebarWidth, 显示到最右时x = 0
 */
- (void)setSideMenuOriginX:(CGFloat)x {
    _isMoving = YES;
    CGRect rect = self.contentView.frame;
    rect.origin.x = x;
    [self.contentView setFrame:rect];
    
    [self changeContentViewAndBlueViewBgEffect];
}

- (void)showMenuAnimation {
    if (self.contentView.frame.origin.x == -kSidebarWidth) {
        [self beginShowBlurEffect];
    }
    self.view.hidden = NO;
    [UIView animateWithDuration:duration animations:^{
        [self setSideMenuOriginX:0];
    } completion:^(BOOL finished) {
        _isMoving = NO;
    }];
}

- (void)hidenMenuAnimation {
    [UIView animateWithDuration:duration animations:^{
        [self setSideMenuOriginX:-kSidebarWidth];
    } completion:^(BOOL finished) {
        _isMoving = NO;
        self.view.hidden = YES;
    }];
}

//添加模糊效果

- (void)changeContentViewAndBlueViewBgEffect {
    CGRect rect     = self.contentView.frame;
    float percent   = (kSidebarWidth + rect.origin.x) / kSidebarWidth;      // 渐变效果
    _blurView.alpha = 0.2 + (1-0.2)*(percent);                              // 不从0开始，效果更明显

    percent = 0.7 + (0.8-0.7) * percent;
    
    self.contentView.backgroundColor = [UIColor colorWithRed:_red green:_green blue:_blue alpha:percent];
}

#pragma mark - Blur Effect

- (void)beginShowBlurEffect {
    if (self.contentView.frame.origin.x < 0) { //self.blurView.alpha < 0.5 &&
        // 截图
        UIImage *image = [self imageFromView:self.view.superview];
        
        dispatch_queue_t queue = dispatch_queue_create("cn.lugede.LLBlurSidebar", NULL);
        dispatch_async(queue, ^ {
            UIImage *blurImage = [self blurryImage:image withBlurLevel:0.2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _blurView.layer.contents = (id)blurImage.CGImage;
            });
        });
    }
}

- (UIImage *)imageFromView:(UIView *)baseView {
    UIGraphicsBeginImageContext(baseView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [baseView.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

#pragma mark - gestureRecognizer
- (void)tap {
    if (!_isMoving) {
        [self showOrHideSideMenu];
    }
}

- (void)panDetected:(UIPanGestureRecognizer *)sender {
    CGPoint touchPoint  = [sender locationInView:sender.view];
    CGFloat offSetX     = touchPoint.x - _startTouchPoint.x;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{            
            _isMoving = YES;
            self.view.hidden = NO;
            _startTouchPoint = touchPoint;  // 手势开始的x坐标, 在一次手势事件中保持不变
            _startContentOriginX = self.contentView.frame.origin.x;
            
            [self beginShowBlurEffect];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            [self setSideMenuOffsetX:offSetX];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (offSetX > 75 || (offSetX > -60 && offSetX < 70 && _startContentOriginX == 0)) { /* 1.滑动偏移量大于75时显示 2.显示的时候，滑动范围在-60~70中间，不改变显示状态 */
                [self showMenuAnimation];
            }else{
                [self hidenMenuAnimation];
            }
            break;
        }
        default:
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self.view];
    if (point.x < kSidebarWidth) {      //在contentView值内就无响应，之外就有响应
        return NO;
    }
    return  YES;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
//    _appDelegate.style1RootVC = nil;
    
//    for (UIGestureRecognizer *gesture in _appDelegate.window.gestureRecognizers) {
//        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
//            [_appDelegate.window removeGestureRecognizer:gesture];
//            break;
//        }
//    }
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
