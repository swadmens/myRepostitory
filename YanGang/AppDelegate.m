//
//  AppDelegate.m
//  YanGang
//
//  Created by 汪伟 on 2018/11/6.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h" // 引导页
#import "GuideNewController.h"//新的引导页


@interface AppDelegate ()
{
    GuideViewController *_guideController;
    GuideNewController *_guideNewController;
    BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate

//- (MainViewController *)tabBarController
//{
//    if (_tabBarController == nil) {
//        _tabBarController = (MainViewController *)self.window.rootViewController;
//    }
//    return _tabBarController;
//}
+ (instancetype)sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (void)showGuideView
{
        @autoreleasepool {
            _guideController = [[GuideViewController alloc] init];
            _guideController.view.frame = self.window.bounds;
            [self.window addSubview:_guideController.view];
        }
    
//    @autoreleasepool {
//        _guideNewController = [[GuideNewController alloc] init];
//        _guideNewController.view.frame = self.window.bounds;
//        [self.window addSubview:_guideNewController.view];
//    }
    
    
}
- (void)setupGuideView
{
    BOOL isused = [[NSUserDefaults standardUserDefaults] boolForKey:(NSString *)_USEDKEY];
    
    if (!isused) {
        [self showGuideView];
    }else{
        
        NSString *oldversionstring = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)_VERSIONKEY]; //
        NSString *versionstring = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        if (oldversionstring) {
            if (![versionstring isEqualToString:oldversionstring]) {
                
                // 重新开启打分
                //                [GTOthersMananger openNewVersionScore];
                
                //欢迎界面
                //                _guideController = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
                //                _guideController.view.frame = self.window.bounds;
                //                [self.window addSubview:_guideController.view];
            }
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:versionstring forKey:(NSString *)_VERSIONKEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    MainViewController *mvc=[[MainViewController alloc]init];
//    self.window.rootViewController = mvc;
    
    [self.window makeKeyAndVisible];
    
    /// 引导页，判断是否是第一次
//    [self setupGuideView];
    
    
    _mapManager = [[BMKMapManager alloc]init];
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    //    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
    //        NSLog(@"经纬度类型设置成功");
    //    } else {
    //        NSLog(@"经纬度类型设置失败");
    //    }
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:KBaiduMapKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
//    // 如果登录了
//    if (_kUserModel.isLogined) {
//        // 每次进来，进行一次更新用户信息
//        [_kUserModel updateUserInfo];
//    }else{
//        [_kUserModel showLoginView];
//    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
