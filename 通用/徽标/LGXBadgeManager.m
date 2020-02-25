//
//  LGXBadgeManager.m
//
//
//  Created by icash on 15-12-15.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import "LGXBadgeManager.h"
#import "LGXBadgeRequestSence.h"

#define IS_SUPPORT_IOS8  1

@interface LGXBadgeManager ()

@property (nonatomic, strong) LGXBadgeRequestSence *requestSence;
@property (nonatomic, strong) NSDictionary *serverToLocalDic;
@property (nonatomic, strong) NSDictionary *localToServerDic;

@property (nonatomic, strong) NSMutableDictionary *badgeRecords;
@end

@implementation LGXBadgeManager

+ (instancetype)sharedInstance
{
    static LGXBadgeManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[LGXBadgeManager alloc] init];
    });
    return _manager;
}

- (NSDictionary *)localToServerDic
{
    if (!_localToServerDic) {
        _localToServerDic = @{};
    }
    return _localToServerDic;
}
- (NSDictionary *)serverToLocalDic
{
    if (!_serverToLocalDic) {
        _serverToLocalDic = @{
                              @"main_follow" : @(LGXPointMainFollow),
                              @"msg_about_me" : @(LGXPointMsgAboutMe),
                              @"msg_friend_dt" : @(LGXPointMsgFriendsDongTai),
                              @"msg_notify" : @(LGXPointMsgNotication),
                              @"tab_my" : @(LGXPointTabbarMine),
                              @"tab_near" : @(LGXPointTabbarNear),
                              };
    }
    return _serverToLocalDic;
}
- (NSMutableDictionary *)badgeRecords
{
    if (!_badgeRecords) {
        _badgeRecords = [NSMutableDictionary dictionary];
    }
    return _badgeRecords;
}
/// 加载的数据更新
- (void)updateBadgeWithData:(NSDictionary *)data atPosition:(NSString *)position
{
    LGXPointType pointType = [[self.serverToLocalDic objectForKey:position] integerValue];
    NSString *icon = [data objectForKey:@"point_icon"];
    NSString *text = [data objectForKey:@"point_txt"];
    
    [self updateBadgeIcon:icon andText:text toPosition:pointType];
}
/// 根据类型读
- (P_Badge *)badgeInfoWithPosition:(LGXPointType)pointType
{
    id key = @(pointType);
    P_Badge *oneBadge = [self.badgeRecords objectForKey:key];
    if (oneBadge == nil) {
        oneBadge = [[P_Badge alloc] init];
        [self.badgeRecords setObject:oneBadge forKey:key];
    }
    return oneBadge;
}
/**
 * 更新某个位置上的徽标
 * 更新后，会发送通知，object : P_Badge类
 */
- (void)updateBadgeIcon:(NSString *)icon andText:(NSString *)text toPosition:(LGXPointType)pointType
{
    BOOL shouldNotice = NO;
    id key = @(pointType);
    P_Badge *oneBadge = [self.badgeRecords objectForKey:key];
    if (oneBadge == nil) {
        oneBadge = [[P_Badge alloc] init];
        [self.badgeRecords setObject:oneBadge forKey:key];
        shouldNotice = YES;
    }
    oneBadge.badge_position = pointType;
    if ([icon isEqual:oneBadge.badge_icon] == NO) {
        oneBadge.badge_icon = icon;
        shouldNotice = YES;
    }
    if ([text isEqual:oneBadge.badge_text] == NO) {
        oneBadge.badge_text = text;
        shouldNotice = YES;
    }
    /// 消息检测
    switch (pointType) {
        case LGXPointMsgAboutMe:
            [self checkMessageBadgeValues];
            break;
        case LGXPointMsgFriendsDongTai:
            [self checkMessageBadgeValues];
            break;
        case LGXPointMsgNotication:
            [self checkMessageBadgeValues];
            break;
        default:
            break;
    }
    if (shouldNotice) {
        /*
        /// 发送通知
        [[GCDQueue mainQueue] queueBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kBadgeValueChangedHandle object:oneBadge userInfo:nil];
        }];
        */
    }
}
/**
 * 得到以下tab中某一个下面的徽标数量 其他的将不返回
 * LGXPointTabbarHome = 90, // tabbar - 首页
 * LGXPointTabbarNear = 91, // tabbar - 身边
 * LGXPointTabbarMsg = 92,  // tabbar - 消息
 * LGXPointTabbarMine = 94, // tabbar - 我的
 
 * LGXPointTabbarAll = 100, // tabbar - 所有
 */
- (int)getBadgeNumberFrom:(LGXPointType)pointType
{
    int num = 0;
    
    switch (pointType) {
        case LGXPointTabbarHome:
        {
            P_Badge *oneBadge = [self badgeInfoWithPosition:pointType];
            num = [oneBadge.badge_text intValue];
        }
            break;
        case LGXPointTabbarNear:
        {
            P_Badge *oneBadge = [self badgeInfoWithPosition:pointType];
            num = [oneBadge.badge_text intValue];
        }
            break;
        case LGXPointTabbarMsg:
        {
            P_Badge *oneBadge = [self badgeInfoWithPosition:pointType];
            num = [oneBadge.badge_text intValue];
        }
            break;
        case LGXPointTabbarMine:
        {
            P_Badge *oneBadge = [self badgeInfoWithPosition:pointType];
            num = [oneBadge.badge_text intValue];
        }
            break;
        case LGXPointTabbarAll:
        {
            NSArray *tmpArr = @[
                                @(LGXPointTabbarHome),
                                @(LGXPointTabbarNear),
                                @(LGXPointTabbarMsg),
                                @(LGXPointTabbarMine),
                                ];
            for (int i =0; i<tmpArr.count; i++) {
                LGXPointType ptype = [[tmpArr objectAtIndex:i] integerValue];
                num = num + [self getBadgeNumberFrom:ptype];
            }
        }
            break;
        default:
            
            break;
    }
    return num;
}
/// 更新logo徽标
- (void)updateIconBadgeNumber
{
    BOOL needCount = YES;
#if IS_SUPPORT_IOS8
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending) {
        UIUserNotificationSettings *asettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        UIUserNotificationType types = [asettings types];
        if (types == UIUserNotificationTypeNone) {
            needCount = NO;
        }
    }
#endif
    
    if (needCount == NO) {
        return;
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSInteger number = [self getBadgeNumberFrom:LGXPointTabbarAll];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
}
@end
















