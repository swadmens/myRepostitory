//
//  LGXBadgeManager.h
//
//
//  Created by icash on 15-12-15.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P_Badge.h"

#define _kBadgeManager [LGXBadgeManager sharedInstance]

static NSString *const kBadgeValueChangedHandle = @"badge.valueChanged";

typedef enum : NSUInteger {
    LGXPointMainFollow = 11, // 首页-关注
    LGXPointMsgAboutMe, // 消息-与我相关
    LGXPointMsgFriendsDongTai, // 消息-好友动态
    LGXPointMsgNotication, // 消息-通知
    
/// tabbar上面的徽标是比较特殊的，以9开始
    LGXPointTabbarHome = 90, // tabbar - 首页
    LGXPointTabbarNear = 91, // tabbar - 身边
    LGXPointTabbarMsg = 92,  // tabbar - 消息
    LGXPointTabbarMine = 94, // tabbar - 我的
    
    LGXPointTabbarAll = 100, // tabbar - 所有
} LGXPointType;

@interface LGXBadgeManager : NSObject

+ (instancetype)sharedInstance;
/// 获取消息徽标
- (void)loadMessageValues;
/// 向服务器请求，更新徽标
- (void)updateBadgeValues;
/// 根据类型读徽标信息
- (P_Badge *)badgeInfoWithPosition:(LGXPointType)pointType;
/// 检查消息的数量
- (void)checkMessageBadgeValues;
/**
 * 更新某个位置上的徽标
 * 更新后，会发送通知，object : P_Badge类
 */
- (void)updateBadgeIcon:(NSString *)icon andText:(NSString *)text toPosition:(LGXPointType)pointType;

/**
 * 得到以下tab中某一个下面的徽标数量 其他的将不返回
 * LGXPointTabbarHome = 90, // tabbar - 首页
 * LGXPointTabbarNear = 91, // tabbar - 身边
 * LGXPointTabbarMsg = 92,  // tabbar - 消息
 * LGXPointTabbarMine = 94, // tabbar - 我的
 
 * LGXPointTabbarAll = 100, // tabbar - 所有
 */
- (int)getBadgeNumberFrom:(LGXPointType)pointType;
/// 更新logo徽标
- (void)updateIconBadgeNumber;
@end
