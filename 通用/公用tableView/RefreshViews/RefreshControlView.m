//
//  RefreshControlView.m
//  
//
//  Created by icash on 16/5/19.
//  Copyright © 2016年 long. All rights reserved.
//

#import "RefreshControlView.h"
#import "RefreshLeftView.h"
#import "RefreshRightView.h"
#import "RefreshGradientView.h"

@interface RefreshControlView ()
{
    BOOL _isAnimation;
}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) RefreshLeftView *leftView;
@property (nonatomic, strong) RefreshRightView *rightView;

@property (nonatomic, strong) RefreshGradientView *gradientView;

@end


@implementation RefreshControlView

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
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    ///
    CGFloat height = self.bounds.size.height;
    CGFloat width = height;

    self.gradientView = [[RefreshGradientView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.gradientView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.gradientView];
    [self.gradientView addWidth:width];
    [self.gradientView addHeight:height];
    [self.gradientView addCenterX:0 toView:self.contentView];
    [self.gradientView addCenterY:0 toView:self.contentView];
}
- (void)setOffsetY:(CGFloat)offsetY
{
    if (offsetY >0) {
        offsetY = 0;
    }
    if (_isAnimation || self.isLoading) {
        return;
    }
    self.isLoading = NO;
    _offsetY = fabs(offsetY);
    
    self.gradientView.offsetY = _offsetY;
}
- (void)setTriggerHeight:(CGFloat)triggerHeight
{
    _triggerHeight = triggerHeight;
    
    self.gradientView.triggerHeight = _triggerHeight;
}

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    if (_isLoading) {
        if (self.gradientView.offsetY < self.gradientView.triggerHeight) {
            self.gradientView.offsetY = self.gradientView.triggerHeight;
        }
    }
    if (_isAnimation && _isLoading) {
        return;
    }
    
    NSString *animationKey = @"roateAnimaiton";
    if (_isLoading) {
        float time = 0.6;
        [self.gradientView.layer addAnimation:[self aroundForever_Animation:time] forKey:animationKey];
        _isAnimation = YES;
    } else {
        
        [self.gradientView.layer removeAnimationForKey:animationKey];
        _isAnimation = NO;
    }

}
/// 不停的转动
- (CAAnimation *)aroundForever_Animation:(double)time
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = time;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = FLT_MAX;
    
    return rotationAnimation;
}
/// 永久闪烁的动画
- (CAAnimation *)opacityForever_Animation:(float)time
{
 
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode=kCAFillModeForwards;
    
    
    CABasicAnimation *animation_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation_scale.fromValue = [NSNumber numberWithFloat:1.0];
    animation_scale.toValue = [NSNumber numberWithFloat:0.8];
    animation_scale.autoreverses = YES;
    animation_scale.duration = time;
    animation_scale.repeatCount = FLT_MAX;
    animation_scale.removedOnCompletion = NO;
    animation_scale.fillMode=kCAFillModeForwards;
    
    CAAnimationGroup *animation_group = [[CAAnimationGroup alloc] init];
    animation_group.animations = @[animation,animation_scale];
    
    animation_group.autoreverses = YES;
    animation_group.duration = time;
    animation_group.repeatCount = FLT_MAX;
    animation_group.removedOnCompletion = NO;
    animation_group.fillMode=kCAFillModeForwards;
    
    return animation_group;
}







@end
