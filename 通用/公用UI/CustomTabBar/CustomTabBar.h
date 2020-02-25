//
//  CustomTabBar.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^plusBtnClick)();

@interface CustomTabBar : UITabBar

@property (nonatomic, copy) plusBtnClick clickBlock;

@end
