//
//  AppDelegate.h
//  YanGang
//
//  Created by 汪伟 on 2018/11/6.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (instancetype)sharedDelegate;
@property (strong, nonatomic) MainViewController *tabBarController;
- (void)showGuideView;

@end

