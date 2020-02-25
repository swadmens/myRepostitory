//
//  LGXThirdEngine.h
//  
//
//  Created by icash on 15-10-17.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApiManager.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

static NSString * _ShareSDKAPPKey = @"2768662617159";

static NSString * _SinaAPPID = @"152484837";
static NSString * _SinaAPPSecret = @"50172ee9ad8481a278b83177edb1c226";
static NSString * _SinaRedirectURL = @"https://www.weibo.com";


static NSString * _WeiXinAPPID = @"wxb0e62a6c897a45ed";
static NSString * _WeiXinAPPSecret = @"0af590772a0cc9416d67bba195952918";

static NSString * _QQAPPID = @"1107155759"; // 41FDDB2F  APPID转16进制
static NSString * _QQAPPSecret = @"aZBM0Js8tHZX74cM";


#define _kThirdManager [LGXThirdEngine sharedInstance]

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LGXShareParams : NSObject
// ：
/**
 * ShareSDK规定
 * 图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://xxxx"]
 * 默认显示app图标
 */
@property (nonatomic, strong) NSArray *images;
/// 分享标题,如果为nil,会显示APP名称
@property (nonatomic, strong) NSString *title;
/// 分享内容,如果为nil,会显示
@property (nonatomic, strong) NSString *content;
/// 分享URL,
@property (nonatomic, strong) NSString *url;
/// 分享成功后的target
@property (nonatomic) id eventData;
/// 平台列表
@property (nonatomic, strong) NSArray *platformList;
/**
 * 其他自定义的按钮 SSUIShareActionSheetCustomItem 类型
 * 通过[LGXShareParams customItemByIcon:]方法获取按钮
 */
@property (nonatomic, strong) NSArray *otherItems;
/**
 * 获取自定义SSUIShareActionSheetCustomItem类型按钮
 * image 图标，建议大小58*58
 * title 提示标题
 * clickHandler 点击时回调
 */
+ (id)customItemByIcon:(UIImage *)image withTitle:(NSString *)title onClicked:(void(^)())clickHandler;

- (void)makeShreParamsByData:(id)data;

@end


typedef void(^authDidSavedBlock)(SSDKUser *user);

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LGXThirdEngine : NSObject

/// 初始化
+ (instancetype)sharedInstance;
/// 配置
- (void)setupShareSDK;
/**
 * 得到某个平台是否被安装了，
 * 整个APP中，如果没有被安装，应该隐藏图标,这个跟苹果的审核机制有关
 */
- (BOOL)isInstalledPlatform:(SSDKPlatformType)platform;

/**
 * 获取平台用户信息
 * completionBlock 返回user nil时失败
 */
- (void)getUserInfoByPlatform:(SSDKPlatformType)platform whenSuccessed:(void(^)(SSDKUser *user))completionBlock;

/**
 * 对某个平台进行授权
 */
- (void)authByPlatform:(SSDKPlatformType)platform completion:(void(^)(BOOL success, SSDKUser *user))finishedBlock;

/**
 * 保存授权凭证
 *
 */
- (void)saveAuthUser:(NSDictionary *)authInfo toPlatform:(SSDKPlatformType)platform completion:(authDidSavedBlock)finishedBlock;

/**
 * 清除平台授权
 */
- (void)cancelAuthByPlatform:(SSDKPlatformType)platform;
/// 根据json来的列表，转sharesdk的平台
- (NSArray *)getSharePlatfomsByJsonData:(NSArray *)platArr;
/**
 * 分享shareTarget
 */
- (void)share:(NSString *)shareTarget;
/**
 * 显示分享菜单的分享
 */
- (void)shareParam:(LGXShareParams *)params;
/**
 * 分享到某些平台
 * platforms  :  SSDKPlatformType的NSNumber的集合 。nil时为所有集成的项目
 */
- (void)shareToPlatforms:(NSArray *)platforms withParam:(LGXShareParams *)params;
/**
 * 分享到某个平台
 * platforms  :  SSDKPlatformType
 */
- (void)shareTo:(SSDKPlatformType)platform withParam:(LGXShareParams *)params;


@end



