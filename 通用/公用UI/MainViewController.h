//
//  MainViewController.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController<UITabBarControllerDelegate>
{
    //最近一次选择的Index
    NSUInteger _lastSelectedIndex;
    
    UIView *v1;
    
}
@property(readonly, nonatomic) NSUInteger lastSelectedIndex;

-(void)setSelectedIndexs:(NSUInteger)selectedIndex;

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;

/**
 *设置哪个item上的徽标
 *@param badgeValue : 0时显示红点，非0时显示全部，否则隐藏
 */
- (void)setBadgeValue:(NSString *)badgeValue atItemIndex:(int)index;

@end
