//
//  UINavigationBar+Background.h
//  EpetV4
//
//  Created by icash on 16/9/12.
//  Copyright © 2016年 EPET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Background)

/// 设置背景色
- (void)e_setBackgroundColor:(UIColor *)backgroundColor;
/// 设置背景图
- (void)e_setBackgroundImage:(UIImage *)image;
/// 设置alpha
- (void)e_setAlpha:(float)alpha;
/// 设置偏移
- (void)e_setTranslationY:(CGFloat)translationY;
#pragma mark - 设置相关view的透明度，如左右、titleView
/// 设置相关view的透明度，如左右、titleView
- (void)e_setElementsAlpha:(CGFloat)alpha;
@end
