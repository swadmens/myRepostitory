//
//  MainViewController.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "MainViewController.h"

#import "UIColor+_Hex.h"
#import "CustomTabBar.h"

#import "IndexViewController.h"
#import "DetailsViewController.h"
#import "DetailOtherViewController.h"
#import "MineViewController.h"
//
//#import "LGXBadgeView.h"
//#import "LGXBadgeManager.h"
//#import "UITabBar+badgeView.h"
//#import "MiddleAddItemsController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    CustomTabBar *tabBar = [[CustomTabBar alloc]initWithFrame:self.tabBar.frame];
//    [self setValue:tabBar forKeyPath:@"tabBar"];
//    tabBar.clickBlock = ^(){
//
//        MiddleAddItemsController *midVc = [MiddleAddItemsController new];
//
//        self.definesPresentationContext = YES;
//        midVc.view.backgroundColor = UIColorFromRGB(0xffffff, 0.97);
//
//        LGXNavigationController *nav = [[LGXNavigationController alloc]initWithRootViewController:midVc];
//
//        nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//
//        [self presentViewController:nav animated:YES completion:nil];
//    };
    
    
    IndexViewController *indexView=[[IndexViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:indexView];
    nav1.tabBarItem = [self createTabBarItem:@"听" image:@"Tabbar-1-normal" selectedImage:@"Tabbar-1-select"];

    DetailsViewController *secondView=[DetailsViewController new];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:secondView];
    nav2.tabBarItem = [self createTabBarItem:@"说" image:@"Tabbar-2-normal" selectedImage:@"Tabbar-2-select"];

    DetailOtherViewController *threeView=[DetailOtherViewController new];
    UINavigationController*nav3=[[UINavigationController alloc]initWithRootViewController:threeView];
    nav3.tabBarItem=[self createTabBarItem:@"广播" image:@"Tabbar-4-normal" selectedImage:@"Tabbar-4-select"];

    MineViewController *fourView=[MineViewController new];
    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:fourView];
    nav4.tabBarItem=[self createTabBarItem:@"我" image:@"Tabbar-5-normal" selectedImage:@"Tabbar-5-select"];


    NSLog(@"select = %lu",(unsigned long)self.selectedIndex);

//     1个app 只有一个 rootViewController,
    NSArray *arr = @[nav1,nav2,nav3,nav4];
    self.viewControllers = arr;

    self.tabBar.alpha=1;
    self.tabBar.backgroundColor=[UIColor whiteColor];


    //字体大小，颜色（未被选中时）
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColorSecondTextColor,NSForegroundColorAttributeName,[UIFont customFontWithSize:kFontSizeTen],NSFontAttributeName,nil]forState:UIControlStateNormal];
    //字体大小，颜色（被选中时）
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColorMainColor,NSForegroundColorAttributeName,[UIFont customFontWithSize:kFontSizeTen],NSFontAttributeName,nil]forState:UIControlStateSelected];


    self.tabBar.translucent = NO;


    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.tabBar addGestureRecognizer:tapGesture];
    tapGesture = nil;

    self.delegate = self;
//
//#define kTABBAR_HIDDEN_KEYPATH  @"tabBar.hidden"
//
//    [self addObserver:self forKeyPath:kTABBAR_HIDDEN_KEYPATH options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//
//    /// 徽标配置
//    int cartIndex = 1;
//    LGXBadgeView *cartBadgeView = [self.tabBar getBadgeViewAtItem:cartIndex]; // 消息的
//    cartBadgeView.hideWhenZeroText = YES; // 为0的时候隐藏
//
//    /// 消息徽标变化
//    iWEAK
//    [RACObserve(_kUserModel.userInfo, message_num) subscribeNext:^(id x) {
//        iSTRONG
//        [self setBadgeValue:_kUserModel.userInfo.message_num atItemIndex:cartIndex];
//    }];
//
//    DLog(@" 徽标  =======     %@",_kUserModel.userInfo.message_num)

    
    
}


- (UITabBarItem *) createTabBarItem:(NSString *)s image:(NSString *)imgPath selectedImage:(NSString *)selImgPath {
    
    UIImage *img1 = [UIImage imageNamed:imgPath];
    UIImage *img2 = [UIImage imageNamed:selImgPath];
    // 把img1使用原生处理 让UITabBarItem不要擅自处理img图片
    // Product Manager PM Pixel Manager.
    img1 = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    img2 = [img2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:s image:img1 selectedImage:img2];
    
    
    if (IS_IPHONEX) {
        [barItem setImageInsets:UIEdgeInsetsMake(-12, 0, 12, 0)];
        [barItem setTitlePositionAdjustment:UIOffsetMake(0, -28)];
    }
    
    
    return barItem;
}


// 隐藏不是继承于“CommonViewController”的导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)setSelectedIndexs:(NSUInteger)selectedIndex
{
    //判断是否相等,不同才设置
    if (self.selectedIndex != selectedIndex) {
        //设置最近一次
        _lastSelectedIndex = self.selectedIndex;
        NSLog(@"1 OLD:%lu , NEW:%lu",(unsigned long)self.lastSelectedIndex,(unsigned long)selectedIndex);
    }
    //调用父类的setSelectedIndex
    [super setSelectedIndex:selectedIndex];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex != self.selectedIndex) {
        //设置最近一次变更
        _lastSelectedIndex = self.selectedIndex;
        NSLog(@"2 OLD:%lu , NEW:%lu",(unsigned long)self.lastSelectedIndex,(unsigned long)tabIndex);
    }
    
}

/**
 *设置哪个item上的徽标
 *@param badgeValue : 0时显示红点，非0时显示全部，否则隐藏
 */
- (void)setBadgeValue:(NSString *)badgeValue atItemIndex:(int)index
{
//    [self.tabBar setBadgeString:badgeValue atItem:index];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    // 监听，tabbar的显示和隐藏，
//    if ([keyPath isEqualToString:kTABBAR_HIDDEN_KEYPATH]) {
//        //        DLog(@"\n self.tabBar.hidden = %@ \n",self.tabBar.hidden?@"YES":@"NO");
//        // 控制提示框的显示与隐藏
//    }
}
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        CGPoint touchPoint = [sender locationInView:self.view];
        CGRect tabbarRect = self.tabBar.frame;
        if (CGRectContainsPoint(tabbarRect, touchPoint) == NO) { // 如果不在tabbar上就不处理
            return;
        }
        // 判断是双击的哪个位置
        NSInteger count = self.viewControllers.count;
        CGFloat eachWidth = tabbarRect.size.width/count;
        float index = floorf(touchPoint.x / eachWidth); // 取整
        // handling code
        [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarDoubleTapped object:[NSNumber numberWithInt:(int)index]];
    }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    NSArray *controllers = tabBarController.viewControllers;
    UIViewController *svc = tabBarController.selectedViewController;
    if (svc == viewController) { // 如果已经选中了
        /// 说明是单击了
        [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarTappedAgain object:[NSNumber numberWithInteger:self.selectedIndex]];
        return NO;
    }
    /*
     if ([[controllers objectAtIndex:3] isEqual:viewController] || [[controllers objectAtIndex:4] isEqual:viewController]) { // 消息
     BOOL login = [_kUserInfo checkLoginStatus];
     if (login == NO) {
     return NO;
     }
     }
     */
    /*
     else if ([viewController isKindOfClass:NSClassFromString(@"MessageViewController")] ||
     [viewController isKindOfClass:NSClassFromString(@"MineViewController")]
     )
     {
     return [_kUserInfo checkLoginStatus];
     }
     */
    return YES;
}

//-(void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    if (self.tabBar.frame.size.height == 83) {
//        CGRect tabFrame = self.tabBar.frame;
//        tabFrame.size.height = 59;
//        self.tabBar.frame = tabFrame;
//        self.tabBar.barStyle = UIBarStyleDefault;
//    }
//}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (IS_IPHONEX) {
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                //此处注意设置 y的值 不要使用屏幕高度 - 49 ，因为还有tabbar的高度 ，用当前tabbarController的View的高度 - 49即可
                view.frame = CGRectMake(view.frame.origin.x, self.view.bounds.size.height-83, view.frame.size.width, 83);
            }
        }
    }
   
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
