//
//  LGXHudManager.m
//  JGProgressHUD Tests
//
//  Created by icash on 16-3-26.
//  Copyright (c) 2016年 Jonas Gessner. All rights reserved.
//

#import "LGXHudManager.h"

@interface LGXHudManager ()
{
    JGProgressHUD *_HUD;
}

@end

@implementation LGXHudManager

/// 返回单例
+ (LGXHudManager *)sharedInstance
{
    static LGXHudManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[LGXHudManager alloc] init];
    });
    return _manager;
}

- (JGProgressHUD *)prototypeHUD {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    // JGProgressHUDInteractionTypeBlockAllTouches 屏蔽滑动
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    
    return HUD;
}
- (UIWindow *)window
{
    return [UIApplication sharedApplication].windows.firstObject;
}
- (void)hideAfter:(NSTimeInterval)delay onHide:(HUDHideBlock)block
{
    [_HUD dismissAfterDelay:delay];
    if (block) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            block();
            _HUD = nil;
        });
    }
}
- (BOOL)checkShouldTipWithMessage:(NSString *)title
{
    [self hideAfter:0 onHide:nil];
    if ([title isKindOfClass:[NSString class]] == NO || [title isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
/**
 成功
 @param inView 在哪个里在显示，如果为nil，则取windows[0]
 @param block
 */
- (void)showSuccessInView:(UIView *)inView
                withTitle:(NSString *)title
                hideAfter:(NSTimeInterval)delay
                   onHide:(HUDHideBlock)block
{
    if ([self checkShouldTipWithMessage:title] == NO) {
        return;
    }
    if (_HUD == nil) {
        _HUD = self.prototypeHUD;
    }
    _HUD.layoutChangeAnimationDuration = 0.3;
    _HUD.square = YES;
    _HUD.textLabel.text = title;
    _HUD.detailTextLabel.text = nil;
    _HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    
    if (inView == nil) {
        inView = self.window;
    }
    [_HUD showInView:inView];
    [self hideAfter:delay onHide:block];
}

/**
 失败
 @param inView 在哪个里在显示，如果为nil，则取windows[0]
 @param block
 */
- (void)showFailedInView:(UIView *)inView
               withTitle:(NSString *)title
               hideAfter:(NSTimeInterval)delay
                  onHide:(HUDHideBlock)block
{
    if ([self checkShouldTipWithMessage:title] == NO) {
        return;
    }
    if (_HUD == nil) {
        _HUD = self.prototypeHUD;
    }
    _HUD.layoutChangeAnimationDuration = 0.3;
    _HUD.square = YES;
    _HUD.detailTextLabel.text = nil;
    _HUD.textLabel.text = title;
    _HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    
    if (inView == nil) {
        inView = self.window;
    }
    [_HUD showInView:inView];
    [self hideAfter:delay onHide:block];
}

/**
 加载菊花显示
 */
- (void)showActivityInView:(UIView *)inView withTitle:(NSString *)title
{
    [self hideAfter:0 onHide:nil];
    _HUD = self.prototypeHUD;
    _HUD.textLabel.text = title;
    _HUD.detailTextLabel.text = nil;
    _HUD.square = YES;
    if (inView == nil) {
        inView = self.window;
    }
    [_HUD showInView:inView];
}

/**
 吐司
 */
- (void)showToastInView:(UIView *)inView
             atPosition:(JGProgressHUDPosition)position
              withTitle:(NSString *)title
              hideAfter:(NSTimeInterval)delay
                 onHide:(HUDHideBlock)block
{
    if ([self checkShouldTipWithMessage:title] == NO) {
        return;
    }
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
    HUD.backgroundColor = [UIColor clearColor];
    
    HUD.indicatorView = nil;
    HUD.textLabel.text = title;
    HUD.position = position;
    /*
    HUD.marginInsets = (UIEdgeInsets) {
        .top = 0.0f,
        .bottom = 20.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
    */
    
    [HUD showInView:inView?inView:self.window];
    _HUD = HUD;
    [self hideAfter:delay onHide:block];
}
/// 设置进度
- (void)setProgress:(float)progress animated:(BOOL)animated
{
    [_HUD setProgress:progress animated:animated];
}
/**
 显示下载
 */
- (JGProgressHUD *)showDownloadInView:(UIView *)inView
                            withTitle:(NSString *)title
                       andDetailTitle:(NSString *)dTitle
{
    [self hideAfter:0 onHide:nil];
    
    _HUD = self.prototypeHUD;
    _HUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:_HUD.style];
    
    _HUD.detailTextLabel.text = dTitle;
    _HUD.textLabel.text = title;
    [_HUD showInView:inView?inView:self.window];
    
    _HUD.layoutChangeAnimationDuration = 0.0;
    [self setProgress:0 animated:NO];
    
    return _HUD;
}

/**
 显示上传
 */
- (JGProgressHUD *)showUploadInView:(UIView *)inView
                          withTitle:(NSString *)title
                     andDetailTitle:(NSString *)dTitle
{
    [self hideAfter:0 onHide:nil];
    
    _HUD = self.prototypeHUD;
    _HUD.indicatorView = [[JGProgressHUDRingIndicatorView alloc] initWithHUDStyle:_HUD.style];
    
    _HUD.detailTextLabel.text = dTitle;
    _HUD.textLabel.text = title;
    [_HUD showInView:inView?inView:self.window];
    
    _HUD.layoutChangeAnimationDuration = 0.0;
    [self setProgress:0 animated:NO];
    
    return _HUD;
}

/**
 显示成功或失败的吐司,
 在底部显示的
 默认时间隐藏
 */
- (void)showMsgInView:(UIView *)inView withTitle:(NSString *)title isSuccess:(BOOL)isSuccess
{
    [[GCDQueue mainQueue] queueBlock:^{
       [self showToastInView:inView atPosition:JGProgressHUDPositionCenter withTitle:title hideAfter:_kHUDDefaultHideTime onHide:nil];
    }];
}

@end









