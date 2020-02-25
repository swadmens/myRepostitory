//
//  UINavigationBar+Background.m
//  EpetV4
//
//  Created by icash on 16/9/12.
//  Copyright © 2016年 EPET. All rights reserved.
//

#import "UINavigationBar+Background.h"
#import <objc/runtime.h>
@implementation UINavigationBar (Background)

static char overlayKey;

- (UIImageView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)e_setBackgroundColor:(UIColor *)backgroundColor
{
    [self checkOverlayView];
    self.overlay.backgroundColor = backgroundColor;
}
- (void)e_setBackgroundImage:(UIImage *)image
{
    [self checkOverlayView];
    [self.overlay setImage:image];
}
- (void)e_setAlpha:(float)alpha
{
    [self checkOverlayView];
    self.overlay.alpha = alpha;
}
- (void)e_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}
#pragma mark - 设置相关view的透明度，如左右、titleView
/// 设置相关view的透明度，如左右、titleView
- (void)e_setElementsAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}
#pragma mark -
- (void)checkOverlayView
{
    if (!self.overlay) {
        // insert an overlay into the view hierarchy
        self.overlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
    }
}
@end
