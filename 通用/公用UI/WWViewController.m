//
//  WWViewController.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"
#import "SharedClient.h"
#import "AppDelegate.h"

@interface WWViewController ()<UINavigationControllerDelegate>
/// 是否第一次加载viewDidAppear
@property (nonatomic, assign) BOOL isHadAppear;

@end

@implementation WWViewController

#define tipImageViewTag 1001
#define tipLabelTag 1002
/// 统一方法，重新加载数据
- (void)reloadDatasIfNeeded
{
    
}
/**
 * 更改当前nav的属性
 * key                  value
 * backgroundImage      背景图
 * titleColor           标题色
 * barTintColor         像返回一样的tintcolor
 * shadow               阴影图片
 */
- (void)setupNavProperties:(NSDictionary *)properties
{
    UIImage *bimage = [properties objectForKey:@"backgroundImage"];
    bimage = bimage?bimage:[UIImage imageWithColor:kColorMainColor];
    
    [self.navigationController.navigationBar setBackgroundImage:bimage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    //
    UIColor *titleColor = [properties objectForKey:@"titleColor"];
    titleColor = titleColor?titleColor:kColorNavTitleColor;
    
    NSDictionary *navTitle = [NSDictionary dictionaryWithObjectsAndKeys:titleColor,NSForegroundColorAttributeName, [UIFont customFontWithSize:kFontSizeNineTeen],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:navTitle];
    
    // 返回按钮
    UIColor *barTintColor = [properties objectForKey:@"barTintColor"];
    barTintColor = barTintColor?barTintColor:kColorNavTitleColor;
    [self.navigationController.navigationBar setTintColor:barTintColor];
    
    
    // 阴影
    UIImage *shadow = [properties objectForKey:@"shadow"];
    UIImage *image = [UIImage new];
    //    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    shadow = shadow?shadow:image;
    [self.navigationController.navigationBar setShadowImage:shadow];
}
- (UIImageView *)getNoDataTipImageView
{
    return [self.noDataContentView viewWithTag:tipImageViewTag];
}
- (UILabel *)getNoDataTipLabel
{
    return [self.noDataContentView viewWithTag:tipLabelTag];
}
- (UIView *)setupnoDataContentViewWithTitle:(NSString *)title andImageNamed:(NSString *)name andTop:(NSString*)top
{
    // 没有的情况下
    self.noDataContentView = [[UIView alloc] init];
    self.noDataContentView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.noDataContentView];
    [self.noDataContentView alignTop:top leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    CGFloat space = 20.0;
    
    UIImage *iconImage = UIImageWithFileName(name);
    CGSize imageSize = iconImage.size;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:iconImage];
    imageView.tag = tipImageViewTag;
    
    [self.noDataContentView addSubview:imageView];
    [imageView addWidth:imageSize.width];
    [imageView addHeight:imageSize.height];
    [imageView topToView:self.noDataContentView withSpace:[top floatValue]];
    [imageView addCenterX:0 toView:self.noDataContentView];
//    [imageView addCenterY:-45 toView:self.noDataContentView];
    
    // label
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    tipLabel.textColor = kColorThirdTextColor;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = title;
    tipLabel.tag = tipLabelTag;
    
    [self.noDataContentView addSubview:tipLabel];
    [tipLabel addHeight:0 withPriority:249.0];
    [tipLabel addWidth:0 withPriority:249.0];
    [tipLabel addCenterX:0 toView:self.noDataContentView];
    [tipLabel topToView:imageView withSpace:space];
    
    self.noDataContentView.hidden = YES;
    
    return self.noDataContentView;
}


/**
 View controller-based status bar appearance
 为NO，则标示状态栏不受UIViewController的单独控制，
 而如果设置为YES，则状态栏会根据各个UIViewController的配置改变，
 UIViewController中如果需要改变状态栏则需要重载以下两个方法:
 之后如果需要刷新状态栏样式的时候，调用[self setNeedsStatusBarAppearanceUpdate]即可，系统会自动调用这两个方法。
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (void)setupDefaultNavTheme
{
    [self setupNavProperties:@{
                               @"backgroundImage" : [UIImage imageWithColor:kColorNavTitleColor],
                               @"titleColor" : kColorMainTextColor,
                               @"barTintColor" : kColorMainTextColor,
                               @"shadow" : [UIImage imageNamed:@"tabbar_shadow"],
                               }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    // 关闭透明,及上下延伸
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIImage *aimage = UIImageWithFileName(@"icon_back_gray");
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:aimage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 64.0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    [button addTarget:self action:@selector(action_goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
    /// 这句话用于解决。位于controller左边的控件不能响映问题。因为interactivePopGestureRecognizer截住了
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
    [[SharedClient sharedInstance] setNetworkStatusDidChanged:^(AFNetworkReachabilityStatus status) {
        [self networkDidChanged:status];
    }];
    
}
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}
//- (MainViewController *)customTabBarController
//{
//    AppDelegate *adelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    return (MainViewController *)adelegate.tabBarController;
//}
- (LGXNavigationController *)customNavigationController
{
    return (LGXNavigationController *)self.navigationController;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isHadAppear == NO) {
        self.isHadAppear = YES;
        [self firstDidAppear];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupDefaultNavTheme];
    /// 开启页面统计
    //    NSString *classname = NSStringFromClass([self class]);
    //    [LGXUmengManager beginLogPageView:classname];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navgationBarWillPopoutNoti:) name:kNavgationControllerWillPop object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navgationBarWillPushinNoti:) name:kNavgationControllerWillPush object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    /// 发送通知,
    [[NSNotificationCenter defaultCenter] postNotificationName:kControllerWillDisappearHandle object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNavgationControllerWillPop object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNavgationControllerWillPush object:nil];
    [super viewWillDisappear:animated];
    /// 开启页面统计
    //    NSString *classname = NSStringFromClass([self class]);
    //    [LGXUmengManager endLogPageView:classname];
}


-(void)action_goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 导航栏 推进 推出 通知
- (void)navgationBarWillPopoutNoti:(NSNotification *)noti
{
    [self navigationControllerWillPop];
}
- (void)navgationBarWillPushinNoti:(NSNotification *)noti
{
    [self navigationControllerWillPush];
}
- (void)navigationControllerWillPop
{
    DLog(@"\n ~~~~~~返回=%@ \n",self.navigationController.viewControllers);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginStatusChangedHandle object:nil];
}
- (void)navigationControllerWillPush
{
    
}

/// 登录状态改变了
- (void)loginStatusChanged
{
    
}
#pragma mark - 网络改变了
- (void)networkDidChanged:(AFNetworkReachabilityStatus)status
{
    
}
#pragma mark - 主宠改变了
/// 主宠改变了
- (void)mainPetDidChanged
{
    
}

//- (UIStoryboard *)storyboard
//{
//    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//}
- (void)setFDPrefersNavigationBarHidden:(BOOL)FDPrefersNavigationBarHidden
{
    _FDPrefersNavigationBarHidden = FDPrefersNavigationBarHidden;
    self.fd_prefersNavigationBarHidden = _FDPrefersNavigationBarHidden;
}
/// 第一次viewDidAppear
- (void)firstDidAppear
{
    
}

#pragma mark -
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark -
/// 设置导航栏透明度
- (void)setNavigationBarAlpha:(float)alpha
{
    //导航栏 navbar
    [self.navigationController.navigationBar e_setAlpha:alpha];
    
    /* 非自定义的，下面的方法就可以实现透明度的控制
     [self.navigationController.navigationBar setTranslucent:YES];
     
     UIImage *image = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]];
     [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
     
     [self.navigationController.navigationBar setShadowImage:[UIImage new]];
     [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
     */
}

/// 隐藏导航栏
- (void)setNavigationBarHidden:(BOOL)hidden
{
    self.fd_prefersNavigationBarHidden = hidden;
}

/// 按偏移隐藏导航
/**
 * 按偏移隐藏导航
 * @param offset 偏移
 * @param baseOffset 基准
 */
- (void)setNavigationBarHiddenWithOffset:(CGFloat)offsetY baseOffset:(CGFloat)baseOffset
{
    if (offsetY > 0) {
        if (offsetY >= baseOffset) {
            [self setNavigationBarTransformProgress:1 baseOffset:baseOffset];
        } else {
            [self setNavigationBarTransformProgress:(offsetY / baseOffset) baseOffset:baseOffset];
        }
    } else {
        [self setNavigationBarTransformProgress:0 baseOffset:baseOffset];
    }
}
- (void)setNavigationBarTransformProgress:(CGFloat)progress baseOffset:(CGFloat)baseOffset
{
    // nav bar 按偏移隐藏
    CGFloat offset = -1*baseOffset * progress;
    [self setNavigationBarHiddenWithOffset:offset];
}
- (void)setNavigationBarHiddenWithOffset:(CGFloat)offset
{
    [self.navigationController.navigationBar e_setTranslationY:offset];
    /*
     if (offset == -64) { // 要加隐藏，否则手势不能穿透。但是加了这个会有闪一下的感觉
     self.navigationController.navigationBar.hidden = YES;
     } else {
     self.navigationController.navigationBar.hidden = NO;
     }
     */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
