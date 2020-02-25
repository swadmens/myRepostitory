//
//  UITabBar+badgeView.h
//  TaPinCaiXiaoAPP
//
//  Created by icash on 16/8/5.
//  Copyright © 2016年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface UITabBar (badgeView)

- (LGXBadgeView *)getBadgeViewAtItem:(int)index;
- (void)setBadgeString:(NSString *)string atItem:(int)index;


@end
