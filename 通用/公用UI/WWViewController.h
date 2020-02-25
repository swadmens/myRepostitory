//
//  WWViewController.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGXHudManager.h"
#import "LGXNavigationController.h"
#import "AFNetworkReachabilityManager.h"
#import "MainViewController.h"

@interface WWViewController : UIViewController
/// 统一方法，重新加载数据
- (void)reloadDatasIfNeeded;
/**
 * 更改当前nav的属性
 * key                  value
 * backgroundImage      背景图
 * titleColor           标题色
 * barTintColor         像返回一样的tintcolor
 * shadow               阴影图片
 */
- (void)setupNavProperties:(NSDictionary *)properties;
/// 没有数据的View
@property (nonatomic, strong) UIView *noDataContentView;
- (UIImageView *)getNoDataTipImageView;
- (UILabel *)getNoDataTipLabel;
- (UIView *)setupnoDataContentViewWithTitle:(NSString *)title andImageNamed:(NSString *)name andTop:(NSString*)top;
/// 第一次viewDidAppear
- (void)firstDidAppear;
/// 隐藏导航条
@property (nonatomic) BOOL FDPrefersNavigationBarHidden;

/// 设置导航栏透明度
- (void)setNavigationBarAlpha:(float)alpha;

/// 隐藏导航栏
- (void)setNavigationBarHidden:(BOOL)hidden;

/**
 * 按偏移隐藏导航
 * @param offsetY 偏移
 * @param baseOffset 基准
 */
- (void)setNavigationBarHiddenWithOffset:(CGFloat)offsetY baseOffset:(CGFloat)baseOffset;

@property (nonatomic, strong) MainViewController *customTabBarController;
@property (nonatomic, strong) LGXNavigationController *customNavigationController;

/// 登录状态改变了
- (void)loginStatusChanged;
/// 将要返回
- (void)navigationControllerWillPop;
-(void)action_goback;
/// 将要返回
- (void)navigationControllerWillPush;
/// 网络改变了
- (void)networkDidChanged:(AFNetworkReachabilityStatus)status;

@end
