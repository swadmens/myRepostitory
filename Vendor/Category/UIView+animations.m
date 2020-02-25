//
//  UIView+animations.m
//  
//
//  Created by icash on 16-3-2.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "UIView+animations.h"
#import <objc/runtime.h>
const CGFloat WZFlashInnerCircleInitialRaius = 20;

@interface UIView () <CAAnimationDelegate>
@property (nonatomic, strong) UIColor *flashColor;
@end

@implementation UIView (animations)

#pragma mark - Private
- (void)setFlashColor:(UIColor *)flashColor
{
    objc_setAssociatedObject(self,
                             "flashColor",
                             flashColor,
                             OBJC_ASSOCIATION_COPY);
}

- (UIColor *)flashColor
{
    UIColor *nameObject = objc_getAssociatedObject(self, "flashColor");
    return nameObject;
}
- (void)showFlashFromPoint:(CGPoint)point withColor:(UIColor *)flashColor
{
    self.clipsToBounds = YES;
    if (flashColor == nil) {
        flashColor = [UIColor whiteColor];
    }
    self.flashColor = flashColor;
    
    CAShapeLayer *circleShape = nil;
    CGFloat scale = 1.0f;
    
    CGFloat width = self.bounds.size.width, height = self.bounds.size.height;
    
    CGFloat biggerEdge = width > height ? width : height, smallerEdge = width > height ? height : width;
    CGFloat radius = smallerEdge / 2 > WZFlashInnerCircleInitialRaius ? WZFlashInnerCircleInitialRaius : smallerEdge / 2;
    
    scale = biggerEdge / radius + 0.5;
    circleShape = [self createCircleShapeWithPosition:CGPointMake(point.x - radius, point.y - radius)
                                             pathRect:CGRectMake(0, 0, radius * 2, radius * 2)
                                               radius:radius];
    
    [self.layer addSublayer:circleShape];
    
    CAAnimationGroup *groupAnimation = [self createFlashAnimationWithScale:scale duration:0.5f];
    
    /* Use KVC to remove layer to avoid memory leak */
//    [groupAnimation setValue:circleShape forKey:@"circleShaperLayer"];
//    [circleShape setDelegate:self];
    [circleShape addAnimation:groupAnimation forKey:@"circleShaperLayer"];
    
}

- (CAShapeLayer *)createCircleShapeWithPosition:(CGPoint)position pathRect:(CGRect)rect radius:(CGFloat)radius
{
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = [self createCirclePathWithRadius:rect radius:radius];
    circleShape.position = position;
    
    circleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
    circleShape.fillColor = self.flashColor ? self.flashColor.CGColor : [UIColor whiteColor].CGColor;
    
    
    circleShape.opacity = 0;
    circleShape.lineWidth = 1;
    
    return circleShape;
}

- (CAAnimationGroup *)createFlashAnimationWithScale:(CGFloat)scale duration:(CGFloat)duration
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.delegate = self;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return animation;
}

- (CGPathRef)createCirclePathWithRadius:(CGRect)frame radius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CALayer *layer = [anim valueForKey:@"circleShaperLayer"];
    if (layer) {
        [layer removeFromSuperlayer];
    }
}

@end
