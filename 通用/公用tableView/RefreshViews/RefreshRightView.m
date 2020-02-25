//
//  RefreshRightView.m
//  UIBezierPath和CAShapeLayer画图
//
//  Created by icash on 16/5/19.
//  Copyright © 2016年 long. All rights reserved.
//

#import "RefreshRightView.h"

@interface RefreshRightView ()
{
    UIColor *_useColor;
}

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation RefreshRightView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self dosetup];
    }
    return self;
}
- (void)dosetup
{
    _useColor = [UIColor colorWithRed:191/255.0 green:36/255.0 blue:129/255.0 alpha:1];
}
- (void)setupBesier
{
    if (self.shapeLayer) {
        return;
    }
    /**
     左边的从右下角开始，向左上方画，最后到右下角
     右边的从左下解开始，向右上方画，最后到左下角
     两个一起画，看起来像在画个心
     */
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 0.5;
    // 初始化该path到一个初始点
    [path moveToPoint:CGPointMake(0, height)];
    [path addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:CGPointMake(0, 0)];
    [path addQuadCurveToPoint:CGPointMake(0, height) controlPoint:CGPointMake(width, height)];
    
    self.shapeLayer = [[CAShapeLayer alloc] init];
    self.shapeLayer.strokeColor = _useColor.CGColor; //渲染曲线颜色
    self.shapeLayer.fillColor = nil;
    self.shapeLayer.lineWidth = 1.0;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    
    self.shapeLayer.path = path.CGPath;
    [self.layer addSublayer:self.shapeLayer];
    
}
- (void)setOffsetY:(CGFloat)offsetY
{
    _offsetY = offsetY;

    [self setupBesier];
    [self drawAnimationLayer];
}
- (void)drawAnimationLayer
{
    CGFloat height = self.triggerHeight;
    CGFloat oper = self.offsetY / height;
    
    UIColor *fillColor;
    
    if (oper >=1 ) { // 填充
        fillColor = _useColor;
    } else { // 取消填充
        fillColor = [UIColor clearColor];
    }
    self.shapeLayer.fillColor = fillColor.CGColor;
    self.shapeLayer.strokeEnd = oper;
}

@end






