//
//  LGXNavigationController.m
//  
//
//  Created by icash on 15-7-24.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import "LGXNavigationController.h"

@interface LGXNavigationController ()


@end

@implementation LGXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /**
     [[UINavigationBar appearance] setTranslucent:NO]; // 这个要放在前面，否则颜色会被淡化
     IOS8会报错。
     */
    
    self.navigationBar.translucent = NO;
}
#pragma mark - 重写 push & pop 两个方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNavgationControllerWillPush object:self];
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNavgationControllerWillPop object:self];
    return [super popViewControllerAnimated:animated];
}
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return [super popToViewController:viewController animated:animated];
}
/// 这样preferredStatusBarStyle 才能起作用
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}
- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/



@end
