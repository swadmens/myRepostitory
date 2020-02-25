//
//  ShareSDKMethod.h
//  QLYDPro
//
//  Created by QiLu on 2017/4/26.
//  Copyright © 2017年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import "LGXThirdEngine.h"

typedef void (^ReportBlock)(void);
typedef void (^BlackBlock)(void);
typedef void (^DeleteBlock)(void);
typedef void (^ResultBlock)(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error);
static NSMutableDictionary *_shareParams;
static ReportBlock myReportBlock;
static BlackBlock myBlackBlock;
static DeleteBlock myDeleteBlock;
static ResultBlock myResultBlock;
static BOOL myIsBlack;//是否有拉黑按钮
static BOOL myIsReport;//是否有举报按钮
static BOOL myIsDelete;//是否有删除按钮
@interface ShareSDKMethod : NSObject

+(void)ShareTextActionWithParams:(LGXShareParams*)shareParams IsBlack:(BOOL)isBlack IsReport:(BOOL)isReport IsDelete:(BOOL)isDelete Black:(BlackBlock)blackBlock Report:(ReportBlock)reportBlock Delete:(DeleteBlock)deleteBlock Result:(ResultBlock)resultBlock;

@end
