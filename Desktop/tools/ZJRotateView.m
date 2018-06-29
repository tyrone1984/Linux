//
//  ZJRotateView.m
//  ZJFramework
//
//  Created by ZJ on 6/15/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJRotateView.h"

@implementation ZJRotateView {
    CAReplicatorLayer *_replicatorLayer;
    CAShapeLayer *_arcLayer, *_arrowLayer;
    
    UIBezierPath *_arrowStartPath, *_arrowEndPath;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initLayerAndProperty];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayerAndProperty];
    }
    return self;
}

- (void)initLayerAndProperty {
    self.backgroundColor = [UIColor colorWithRed:34/255.0 green:233/255.0 blue:123/255.0 alpha:1];
    [self setLayers];
    [self setPaths];
}

- (void)setLayers {
    _replicatorLayer = [CAReplicatorLayer layer];
    _replicatorLayer.frame = self.bounds;
    _replicatorLayer.instanceCount = 2;
    _replicatorLayer.instanceTransform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    [self.layer addSublayer:_replicatorLayer];
    
    _arcLayer = [self createLayerWithLineWidth:3];
    _arrowLayer = [self createLayerWithLineWidth:3];
    [_replicatorLayer addSublayer:_arcLayer];
    [_replicatorLayer addSublayer:_arrowLayer];
}

- (CAShapeLayer *)createLayerWithLineWidth:(CGFloat)lineWidth {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = lineWidth;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.lineCap = kCALineCapRound;
    
    return layer;
}

- (void)setPaths {
    UIBezierPath *path =[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:40 startAngle:0 endAngle:M_PI_2*7/4 clockwise:YES];
    _arcLayer.path = path.CGPath;
    
    _arrowStartPath = [UIBezierPath bezierPath];
    [_arrowStartPath moveToPoint:CGPointMake(80, 54)];
    [_arrowStartPath addLineToPoint:CGPointMake(90, 50)];
    [_arrowStartPath addLineToPoint:CGPointMake(99, 56.5)];
    _arrowLayer.path = _arrowStartPath.CGPath;
    
    _arrowEndPath = [UIBezierPath bezierPath];
    [_arrowEndPath moveToPoint:CGPointMake(80, 42.5)];
    [_arrowEndPath addLineToPoint:CGPointMake(90, 50)];
    [_arrowEndPath addLineToPoint:CGPointMake(99, 44.5)];
}

- (void)beganAnimation {
    _animating = YES;
    
    CABasicAnimation *baseAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    baseAni.fromValue = @(M_PI*2);
    baseAni.toValue = @(0);
    baseAni.duration = 2;
    baseAni.repeatCount = NSIntegerMax;
    [_replicatorLayer addAnimation:baseAni forKey:@"arcAnimation"];

    CAKeyframeAnimation *arrowKeyAni = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    arrowKeyAni.values = @[(__bridge id)_arrowStartPath.CGPath,(__bridge id)_arrowEndPath.CGPath,(__bridge id)_arrowEndPath.CGPath];
    arrowKeyAni.keyTimes = @[@(0.45),@.75,@.95];
    arrowKeyAni.autoreverses = YES;
    arrowKeyAni.repeatCount = NSIntegerMax;
    arrowKeyAni.duration = 1;
    [_arrowLayer addAnimation:arrowKeyAni forKey:@"arrowAnimation"];
}

- (void)removeAnimation {
    _animating = NO;
    [_replicatorLayer removeAnimationForKey:@"arcAnimation"];
    [_arrowLayer removeAnimationForKey:@"arrowAnimation"];
}

- (void)pauseAnimation {
    _animating = NO;
    
    CFTimeInterval pauseTime = [_replicatorLayer convertTime:CACurrentMediaTime() toLayer:nil];
    _replicatorLayer.speed = 0;
    NSLog(@"timeOffset1 = %f, %f, %f", _replicatorLayer.timeOffset, _replicatorLayer.beginTime, [_replicatorLayer convertTime:CACurrentMediaTime() fromLayer:nil]);

    _replicatorLayer.timeOffset = pauseTime;

    NSLog(@"timeOffset1 = %f, %f, %f", _replicatorLayer.timeOffset, _replicatorLayer.beginTime, [_replicatorLayer convertTime:CACurrentMediaTime() fromLayer:nil]);
}
/**
 *    
 layer的speed属性默认值是1，如果设置为2的话，那么动画的速度会提高一倍，如果设置为0的话，动画不会进行，处于停止状态。
 
   layer还有一个属性，timeOffset，用来控制当前视图的状态处于动画的什么位置。举个例子：如果我们的speed设置为0，timeOffset设置为0.5，当前的视图就会呈现动画执行到一半的时候的视图状态。
 
   这样，我们只需要在前期设置好各个视图的动画，把layer的speed设置为0，在根据手势的进度，设置layer的timeOffset。
 
   不过我们需要注意两个问题，一个是手势结束我们需要在设置speed为1的时候，需要获取当前的视图Presentation tree的transform，并且更新到model tree，很简单，代码如下：
 */

- (void)resumeAnimation {
    _animating = YES;
    
    CFTimeInterval pausedTime = [_replicatorLayer timeOffset];
    NSLog(@"timeOffset2 = %f, %f, %f", _replicatorLayer.timeOffset, _replicatorLayer.beginTime, [_replicatorLayer convertTime:CACurrentMediaTime() fromLayer:nil]);
    _replicatorLayer.speed = 1.0;
    _replicatorLayer.timeOffset = 0.0;
    _replicatorLayer.beginTime = 0.0;
    NSLog(@"timeOffset2 = %f, %f, %f", _replicatorLayer.timeOffset, _replicatorLayer.beginTime, [_replicatorLayer convertTime:CACurrentMediaTime() fromLayer:nil]);
    CFTimeInterval timeSincePause = [_replicatorLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    _replicatorLayer.beginTime = timeSincePause;
    

//    _replicatorLayer.speed = 1.0;
//    _replicatorLayer.timeOffset = 0.0;
//    _replicatorLayer.beginTime = 0.0;
//    CFTimeInterval pausedTime = [_replicatorLayer convertTime:CACurrentMediaTime() toLayer:nil];
//    _replicatorLayer.beginTime = pausedTime;
}

@end
