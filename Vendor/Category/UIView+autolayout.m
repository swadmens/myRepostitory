//
//  UIView+autolayout.m
//  
//
//  Created by icash on 15-8-20.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import "UIView+autolayout.h"

@implementation UIView (autolayout)
- (void)alignTop:(NSString *)top leading:(NSString *)left bottom:(NSString *)bottom trailing:(NSString *)right toView:(UIView *)toView
{
    if (toView == nil || self.superview == nil) {
        return;
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (top) {
        CGFloat _top = [top floatValue];
        if (self.superview == toView) {
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeTop multiplier:1 constant:_top]];
        }else{
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeBottom multiplier:1 constant:_top]];
        }
        
    }
    if (left) {
        CGFloat _left = [left floatValue];
        if (self.superview == toView) {
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeLeft multiplier:1 constant:_left]];
        }else{
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeRight multiplier:1 constant:_left]];
        }
        
    }
    if (bottom) {
        CGFloat _bottom = [bottom floatValue];
        if (self.superview == toView) {
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1*_bottom]];
        }else{
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeTop multiplier:1 constant:-1*_bottom]];
        }
        
    }
    if (right) {
        CGFloat _right = [right floatValue];
        if (self.superview == toView) {
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeRight multiplier:1 constant:-1*_right]];
        }else{
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeLeft multiplier:1 constant:-1*_right]];
        }
        
    }
}
///
- (NSLayoutConstraint *)leftToView:(UIView *)view withSpace:(CGFloat)space
{
    return [self leftToView:view withSpace:space withPriority:UILayoutPriorityRequired];
}
- (NSLayoutConstraint *)leftToView:(UIView *)view withSpace:(CGFloat)space withPriority:(float)priority
{

    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraint = nil;
    if (view == self.superview) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:space];
    } else {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:space];
    }
    
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}

///
- (NSLayoutConstraint *)topToView:(UIView *)view withSpace:(CGFloat)space
{
    return [self topToView:view withSpace:space withPriority:UILayoutPriorityRequired];
}
- (NSLayoutConstraint *)topToView:(UIView *)view withSpace:(CGFloat)space withPriority:(float)priority
{

    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = nil;
    if (view == self.superview) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:space];
    } else {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:space];
    }
    
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}

///
- (NSLayoutConstraint *)bottomToView:(UIView *)view withSpace:(CGFloat)space
{
    return [self bottomToView:view withSpace:space withPriority:UILayoutPriorityRequired];
}
- (NSLayoutConstraint *)bottomToView:(UIView *)view withSpace:(CGFloat)space withPriority:(float)priority
{

    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = nil;
    if (view == self.superview) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:(-1*space)];
    } else {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:(-1*space)];
    }
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)rightToView:(UIView *)view withSpace:(CGFloat)space
{
    return [self rightToView:view withSpace:space withPriority:UILayoutPriorityRequired];
}
- (NSLayoutConstraint *)rightToView:(UIView *)view withSpace:(CGFloat)space withPriority:(float)priority
{

    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = nil;
    if (view == self.superview) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:(-1*space)];
    } else {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:(-1*space)];
    }
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)addHeight:(CGFloat)height
{
    return [self addHeight:height withPriority:UILayoutPriorityRequired];
}
- (NSLayoutConstraint *)addHeight:(CGFloat)height withPriority:(float)priority
{
    if (self.superview == nil) {
        return nil;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)addWidth:(CGFloat)width
{
    return [self addWidth:width withPriority:UILayoutPriorityRequired];
}
- (NSLayoutConstraint *)addWidth:(CGFloat)width withPriority:(float)priority
{
    if (self.superview == nil) {
        return nil;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}

///
- (NSLayoutConstraint *)addPercentWidth:(float)percent toView:(UIView *)toView offset:(float)offset
{
    return [self addPercentWidth:percent toView:toView offset:offset withPriority:UILayoutPriorityRequired];
}
- (NSLayoutConstraint *)addPercentWidth:(float)percent toView:(UIView *)toView offset:(float)offset withPriority:(float)priority
{

    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeWidth multiplier:percent constant:offset];
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}
///
- (NSLayoutConstraint *)addPercentHeight:(float)percent toView:(UIView *)toView offset:(float)offset
{
    return [self addPercentHeight:percent toView:toView offset:offset withPriority:UILayoutPriorityRequired];
}
- (NSLayoutConstraint *)addPercentHeight:(float)percent toView:(UIView *)toView offset:(float)offset withPriority:(float)priority
{

    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeHeight multiplier:percent constant:offset];
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}


- (NSLayoutConstraint *)addCenterX:(CGFloat)center toView:(UIView *)toView
{
    return [self addCenterX:center toView:toView withPriority:UILayoutPriorityRequired];
}
- (NSLayoutConstraint *)addCenterX:(CGFloat)center toView:(UIView *)toView withPriority:(float)priority
{

    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeCenterX multiplier:1 constant:center];
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}

///
- (NSLayoutConstraint *)addCenterY:(CGFloat)center toView:(UIView *)toView
{
    return [self addCenterY:center toView:toView withPriority:UILayoutPriorityRequired];
}
- (NSLayoutConstraint *)addCenterY:(CGFloat)center toView:(UIView *)toView withPriority:(float)priority
{

    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeCenterY multiplier:1 constant:center];
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}

/// 宽高属性
- (NSLayoutConstraint *)setAttribute:(NSString *)att toView:(UIView *)toView byAttribute:(NSString *)byAtt multiplier:(CGFloat)multiplier offset:(float)offset
{
    return [self setAttribute:att toView:toView byAttribute:byAtt multiplier:multiplier offset:offset withPriority:UILayoutPriorityRequired];
    
    
}
- (NSLayoutConstraint *)setAttribute:(NSString *)att toView:(UIView *)toView byAttribute:(NSString *)byAtt multiplier:(CGFloat)multiplier offset:(float)offset withPriority:(float)priority
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutAttribute layoutAttribute;
    if ([att isEqual:AttributeHeight]) {
        layoutAttribute = NSLayoutAttributeHeight;
    } else if ([att isEqual:AttributeWidth]) {
        layoutAttribute = NSLayoutAttributeWidth;
    }
    
    NSLayoutAttribute byLayoutAttribute;
    if ([byAtt isEqual:AttributeHeight]) {
        byLayoutAttribute = NSLayoutAttributeHeight;
    } else if ([byAtt isEqual:AttributeWidth]) {
        byLayoutAttribute = NSLayoutAttributeWidth;
    }
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:toView attribute:byLayoutAttribute multiplier:multiplier constant:offset];
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    
    return constraint;
}
/// 增加一根线
- (UIView *)addLineViewToTop:(BOOL)onTop WithColor:(UIColor *)color andHeight:(CGFloat)height toLeft:(NSString *)left andRight:(NSString *)right
{
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    if (color == nil) {
        color = [UIColor lightGrayColor];
    }
    lineView.backgroundColor = color;
    [lineView addHeight:height];
    if (onTop) {
        [lineView topToView:self withSpace:0];
        [lineView alignTop:@"0" leading:left bottom:nil trailing:right toView:self];
    } else {
        [lineView alignTop:nil leading:left bottom:@"0" trailing:right toView:self];
    }
    
    return lineView;
}
/// 左或右增加一根线
- (UIView *)addLineViewToRight:(BOOL)onRight WithColor:(UIColor *)color andWidth:(CGFloat)width toTop:(NSString *)top andBottom:(NSString *)bottom
{
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    if (color == nil) {
        color = [UIColor lightGrayColor];
    }
    lineView.backgroundColor = color;
    [lineView addWidth:width];
    
    if (onRight) {
        [lineView topToView:self withSpace:0];
        [lineView alignTop:top leading:nil bottom:bottom trailing:@"0" toView:self];
    } else {
        [lineView alignTop:top leading:@"0" bottom:bottom trailing:nil toView:self];
    }
    
    return lineView;
}
@end
