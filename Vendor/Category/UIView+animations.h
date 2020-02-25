//
//  UIView+animations.h
//  
//
//  Created by icash on 16-3-2.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (animations)
/**
 * 显示光晕效果
 * @param point : 点击处或从哪里开始
 * @param flashColor : 闪的颜色
 */
- (void)showFlashFromPoint:(CGPoint)point withColor:(UIColor *)flashColor;

@end
