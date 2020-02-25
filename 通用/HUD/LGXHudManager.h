//
//  LGXHudManager.h
//  JGProgressHUD Tests
//
//  Created by icash on 16-3-26.
//  Copyright (c) 2016年 Jonas Gessner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGProgressHUD.h"

#define _kHUDManager [LGXHudManager sharedInstance]

static float const _kHUDDefaultHideTime = 1.5;

typedef void(^HUDHideBlock)(void);
typedef float(^HUDGetProgressBlock)(void);
@interface LGXHudManager : NSObject

/// 返回单例
+ (LGXHudManager *)sharedInstance;
/**
 成功
 @param inView 在哪个里在显示，如果为nil，则取windows[0]
 @param block
 */
- (void)showSuccessInView:(UIView *)inView
                withTitle:(NSString *)title
                hideAfter:(NSTimeInterval)delay
                   onHide:(HUDHideBlock)block;

/**
 失败
 @param inView 在哪个里在显示，如果为nil，则取windows[0]
 @param block
 */
- (void)showFailedInView:(UIView *)inView
               withTitle:(NSString *)title
               hideAfter:(NSTimeInterval)delay
                  onHide:(HUDHideBlock)block;

/**
 加载菊花显示
 */
- (void)showActivityInView:(UIView *)inView
                 withTitle:(NSString *)title;

/**
 吐司
 */
- (void)showToastInView:(UIView *)inView
             atPosition:(JGProgressHUDPosition)position
              withTitle:(NSString *)title
              hideAfter:(NSTimeInterval)delay
                 onHide:(HUDHideBlock)block;
/// 设置进度
- (void)setProgress:(float)progress animated:(BOOL)animated;

/**
 显示下载
 */
- (JGProgressHUD *)showDownloadInView:(UIView *)inView
                            withTitle:(NSString *)title
                       andDetailTitle:(NSString *)dTitle;
/**
 显示上传
 */
- (JGProgressHUD *)showUploadInView:(UIView *)inView
                          withTitle:(NSString *)title
                     andDetailTitle:(NSString *)dTitle;
/**
 先加上，以备以后统一更改样式
 显示成功或失败的吐司,
 在底部显示的
 默认时间隐藏
 */
- (void)showMsgInView:(UIView *)inView
            withTitle:(NSString *)title
            isSuccess:(BOOL)isSuccess;
/// 隐藏
- (void)hideAfter:(NSTimeInterval)delay
           onHide:(HUDHideBlock)block;

@end




