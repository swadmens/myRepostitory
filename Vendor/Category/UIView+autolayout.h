//
//  UIView+autolayout.h
//  
//
//  Created by icash on 15-8-20.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AttributeWidth @"width"
#define AttributeHeight @"height"

@interface UIView (autolayout)
/**
 * 自动 self.superview addto sub constraints toView  ,全部传正值，下跟右会自动转负
 * top ,left ,bottom ,right 为nil时，不添加该项
 */
- (void)alignTop:(NSString *)top leading:(NSString *)left bottom:(NSString *)bottom trailing:(NSString *)right toView:(UIView *)toView;


- (NSLayoutConstraint *)addPercentWidth:(float)percent toView:(UIView *)toView offset:(float)offset;
- (NSLayoutConstraint *)addPercentWidth:(float)percent toView:(UIView *)toView offset:(float)offset withPriority:(float)priority;

- (NSLayoutConstraint *)addPercentHeight:(float)percent toView:(UIView *)toView offset:(float)offset;
- (NSLayoutConstraint *)addPercentHeight:(float)percent toView:(UIView *)toView offset:(float)offset withPriority:(float)priority;

/// 增加高
- (NSLayoutConstraint *)addHeight:(CGFloat)height;
- (NSLayoutConstraint *)addHeight:(CGFloat)height withPriority:(float)priority;

/// 宽
- (NSLayoutConstraint *)addWidth:(CGFloat)width;
- (NSLayoutConstraint *)addWidth:(CGFloat)width withPriority:(float)priority;

/// 横向居中
- (NSLayoutConstraint *)addCenterX:(CGFloat)center toView:(UIView *)toView;
- (NSLayoutConstraint *)addCenterX:(CGFloat)center toView:(UIView *)toView withPriority:(float)priority;

/// 纵向居中
- (NSLayoutConstraint *)addCenterY:(CGFloat)center toView:(UIView *)toView;
- (NSLayoutConstraint *)addCenterY:(CGFloat)center toView:(UIView *)toView withPriority:(float)priority;

/// 宽高属性
- (NSLayoutConstraint *)setAttribute:(NSString *)att toView:(UIView *)toView byAttribute:(NSString *)byAtt multiplier:(CGFloat)multiplier offset:(float)offset;
- (NSLayoutConstraint *)setAttribute:(NSString *)att toView:(UIView *)toView byAttribute:(NSString *)byAtt multiplier:(CGFloat)multiplier offset:(float)offset withPriority:(float)priority;

/// 增加一根线
- (UIView *)addLineViewToTop:(BOOL)onTop WithColor:(UIColor *)color andHeight:(CGFloat)height toLeft:(NSString *)left andRight:(NSString *)right;
/// 左或右增加一根线
- (UIView *)addLineViewToRight:(BOOL)onRight WithColor:(UIColor *)color andWidth:(CGFloat)width toTop:(NSString *)top andBottom:(NSString *)bottom;
@end
