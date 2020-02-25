//
//  LGXThirdEngine.m
//  
//
//  Created by icash on 15-10-17.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import "LGXThirdEngine.h"
#import "LGXHudManager.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKExtension/SSEBaseUser.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>

#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UploadEngine.h"
#import "LGXDatePicker.h"
#import "WWPublicMethod.h"
#import "TargetEngine.h"

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


@implementation LGXShareParams

/**
 * 获取自定义SSUIShareActionSheetCustomItem类型按钮
 * image 图标，建议大小58*58
 * title 提示标题
 * clickHandler 点击时回调
 */
+ (id)customItemByIcon:(UIImage *)image withTitle:(NSString *)title onClicked:(void(^)())clickHandler
{
    //添加一个自定义的平台（非必要）
    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:image
                                                                                  label:title
                                                                                onClick:^{
                                                                                    if (clickHandler) {
                                                                                        clickHandler();
                                                                                    }
                                                                                }];
    return item;
}

- (NSArray *)images
{
    if (!_images) {
        _images = @[];
    }
    return _images;
}
- (NSString *)title
{
    if (!_title) {
        _title = [WWPhoneInfo getAPPName];
    }
    return _title;
}
- (void)makeShreParamsByData:(id)data
{
    self.title = [data objectForKey:@"share_title"];
    self.content = [data objectForKey:@"share_content"];
    //http://sucai.qqjay.com/qqjayxiaowo/201210/26/1.jpg
    NSString *image = [data objectForKey:@"share_img"];
    
    if (image == nil) {
        image = @"";
    }
    self.images = @[image];
    self.url = [data objectForKey:@"share_url"];
    self.eventData = [data objectForKey:@"event"]; // 分享完成的事件
    NSString *share_platform = [data objectForKey:@"share_platform"];
    NSArray *platArr = [share_platform componentsSeparatedByString:@","];
    self.platformList = [_kThirdManager getSharePlatfomsByJsonData:platArr];
    
}

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
@implementation LGXThirdEngine



+ (instancetype)sharedInstance
{
    static LGXThirdEngine *_engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _engine = [[LGXThirdEngine alloc] init];
    });
    return _engine;
}
/// 允许哪些平台
- (NSArray *)allowedPlatforms
{
    return @[
             @(SSDKPlatformTypeSinaWeibo), // 新浪微博
             @(SSDKPlatformTypeWechat), // 微信
             @(SSDKPlatformTypeQQ), // QQ
             ];
}
- (void)setupShareSDK
{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:_ShareSDKAPPKey
          activePlatforms:[self allowedPlatforms]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:_SinaAPPID
                                           appSecret:_SinaAPPSecret
                                         redirectUri:_SinaRedirectURL
                                            authType:SSDKAuthTypeSSO];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:_WeiXinAPPID
                                       appSecret:_WeiXinAPPSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:_QQAPPID
                                      appKey:_QQAPPSecret
                                    authType:SSDKAuthTypeSSO]; // 只准SSO
                 break;
             default:
                 break;
         }
     }];
}
/**
 * 获取平台用户信息
 * completionBlock 返回user nil时失败
 */
- (void)getUserInfoByPlatform:(SSDKPlatformType)platform whenSuccessed:(void(^)(SSDKUser *user))completionBlock
{
    [ShareSDK getUserInfo:platform onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (completionBlock) {
            if (error) {
                user = nil;
            }
            completionBlock(user);
        }
    }];
}

/**
 * 保存授权凭证
 *
 */
- (void)saveAuthUser:(NSDictionary *)authInfo toPlatform:(SSDKPlatformType)platform completion:(authDidSavedBlock)finishedBlock
{
    if (authInfo == nil || authInfo.count <=0) {
        if (finishedBlock) {
            finishedBlock(nil);
        }
        return;
    }
    
    // authInfo 后台返回的信息
    SSDKCredential *credential = [[SSDKCredential alloc] init];
    credential.uid = [NSString stringWithFormat:@"%@",[authInfo objectForKey:@"code"]];
    credential.token = [NSString stringWithFormat:@"%@",[authInfo objectForKey:@"access_token"]];
    NSString *expires_in = [NSString stringWithFormat:@"%@",[authInfo objectForKey:@"expires_in"]];
    credential.expired = [_kDatePicker dateTranslateFromTimeInterval:expires_in];
    
    SSDKUser *user = [[SSDKUser alloc] init];
    user.credential = credential;
    user.platformType = platform;
    /// 更新信息
    SSEBaseUser *baseUser = [[SSEBaseUser alloc] init];
    [baseUser updateInfo:user];
    if (finishedBlock) {
        finishedBlock(user);
    }
}
/**
 * 对某个平台进行授权
 */

- (void)authByPlatform:(SSDKPlatformType)platform completion:(void(^)(BOOL success, SSDKUser *user))finishedBlock
{
    [ShareSDK authorize:platform settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (finishedBlock) {
            if (state == SSDKResponseStateSuccess) {
                finishedBlock(YES,user);
            }else{
                if (state == SSDKResponseStateFail ) {
                    [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"privilegeFailed", nil) isSuccess:NO];
                } else if (state == SSDKResponseStateCancel){
                    [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"cancelPrivilege", nil) isSuccess:NO];
                }
                
                finishedBlock(NO,user);
            }
        }
    }];
}

/**
 * 清除平台授权
 */
- (void)cancelAuthByPlatform:(SSDKPlatformType)platform
{
    [ShareSDK cancelAuthorize:platform];
}
/**
 * 得到某个平台是否被安装了，
 * 整个APP中，如果没有被安装，应该隐藏图标,这个跟苹果的审核机制有关
 */
- (BOOL)isInstalledPlatform:(SSDKPlatformType)platform
{
    BOOL isInstalled = NO;
    switch (platform) {
        case SSDKPlatformTypeQQ:
            isInstalled = [QQApiInterface isQQInstalled];
            break;
        case SSDKPlatformTypeWechat:
            isInstalled = [WXApi isWXAppInstalled];
            break;
        case SSDKPlatformTypeSinaWeibo:
            isInstalled = [WeiboSDK isWeiboAppInstalled];
            break;
        default:
            break;
    }
    return isInstalled;
}
/// 根据json来的列表，转sharesdk的平台
- (NSArray *)getSharePlatfomsByJsonData:(NSArray *)platArr
{
    NSMutableArray *platforms = [NSMutableArray array];
    for (int i =0; i<platArr.count; i++) {
        NSString *onePalt = [platArr objectAtIndex:i];
        SSDKPlatformType pType = SSDKPlatformTypeAny;
        if ([onePalt isEqual:@"QQ"]) {
            pType = SSDKPlatformSubTypeQQFriend;
            
        } else if ([onePalt isEqual:@"QZone"]) {
            pType = SSDKPlatformSubTypeQZone;
            
        } else if ([onePalt isEqual:@"Wechat"]) { // 聊天
            pType = SSDKPlatformSubTypeWechatSession;
            
        } else if ([onePalt isEqual:@"SinaWeibo"]) {
            pType = SSDKPlatformTypeSinaWeibo;
            
        } else if ([onePalt isEqual:@"WechatMoments"]) { // 朋友圈
            pType = SSDKPlatformSubTypeWechatTimeline;
            
        }
        
        
        if (pType != SSDKPlatformTypeAny) {
            [platforms addObject:[NSNumber numberWithInteger:pType]];
        }
    }
    if (platforms.count <=0) {
        platforms = nil; // 取所有
    }
    
    return platforms;
}
/**
 * 分享shareTarget
 */
- (void)share:(NSString *)shareTarget
{
    /**
     {
     "type": "share",
     "share_content": "分享内容",
     "share_title": "分享标题",
     "share_img":"分享图片",
     "share_url":"分享链接地址",
     "share_platform": "QQ,QZone,Wechat,SinaWeibo,WechatMoments",
     "event": "分享完成操作"
     }
     
     shareTarget = @"{\"msg_type\":\"share\",\"share_content\":\"经鉴定，我竟然是贱萌毛球控！\",\"share_img\":\"http://img1.epetbar.com/2016-02/26/10/ca081e151c638b2c0f032a20305baea0.jpg@!200w-c\",\"share_title\":\"宠物控等级测试\",\"share_url\":\"http://m.gutou.com/v3/exam.html?do=results&id=1&code=kcNZpOSSIW&s=0\",\"share_platform\":\"WechatMoments\",\"event\":{\"msg_type\":\"http\",\"cmd\":\"http://api.gutou.com/v3/common.html?do=examshare&id=1&code=kcNZpOSSIW\",\"method\":\"POST\",\"show_hud\":0}}";
     */
    
    NSDictionary *data = [WWPublicMethod objectTransFromJson:shareTarget];
    if (data) {
        
        LGXShareParams *param = [[LGXShareParams alloc] init];
        [param makeShreParamsByData:data];
        
        [self shareToPlatforms:param.platformList withParam:param];
    }
}
/**
 * 显示分享菜单的分享
 *
 */
- (void)shareParam:(LGXShareParams *)params
{
    [self shareToPlatforms:nil withParam:params];
}
/// 原来是要单独写，貌似后面的sharesdk不需要了
- (void)setupWechatTimeLineInfo:(LGXShareParams *)params toData:(NSMutableDictionary *)shareParams
{
    [shareParams SSDKSetupWeChatParamsByText:params.title
                                       title:params.content
                                         url:[NSURL URLWithString:params.url]
                                  thumbImage:params.images.firstObject
                                       image:params.images.firstObject
                                musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
}
/// 组装平台
- (NSMutableArray *)getRealPlatforms:(NSArray *)platforms
{
    NSMutableArray *items;
    if (!platforms || platforms.count==0){ // 如果是nil，则把允许的评台都添加一次
        platforms = [self allowedPlatforms];
    }
    items = [NSMutableArray array];
    for (int i =0; i<platforms.count; i++) {
        SSDKPlatformType pType = [[platforms objectAtIndex:i] integerValue];
        
        if (pType != SSDKPlatformTypeAny) {
            [items addObject:@(pType)];
        }
    }
    
    return items;
}
/**
 * 分享到某个平台
 * platforms  :  SSDKPlatformType 。nil时为所有信成的项目
 */
- (void)shareToPlatforms:(NSArray *)platforms withParam:(LGXShareParams *)params
{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:params.content
                                     images:params.images
                                        url:[NSURL URLWithString:params.url]
                                      title:params.title
                                       type:SSDKContentTypeAuto];
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self getRealPlatforms:platforms]];
    
    if (params.otherItems.count >0) {
        [items addObjectsFromArray:params.otherItems];
    }

    if (items.count == 0) {
        items = nil;
    } else if (items.count == 1) { // 如果只有一个,不显示菜单
        SSDKPlatformType pType = [platforms.firstObject integerValue];
        [self shareTo:pType withParam:params];
        return;
    }
    
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
    // 设置菜单风格
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSystem];
    [ShareSDK showShareActionSheet:nil
                             items:items // items
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   DLog(@"\n ~~~~~~~! error=%@ \n",error);
                   [self didShareFinished:state userData:userData contentEntity:contentEntity withError:error fromParams:params];
               }];
    
}

/**
 * 分享到某个平台
 * platforms  :  SSDKPlatformType
 */
- (void)shareTo:(SSDKPlatformType)platform withParam:(LGXShareParams *)params
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:params.content
                                     images:params.images
                                        url:[NSURL URLWithString:params.url]
                                      title:params.url
                                       type:SSDKContentTypeAuto];
    /*
    if (platform == SSDKPlatformSubTypeWechatTimeline) {
        [self setupWechatTimeLineInfo:params toData:shareParams];
    }
    */
    //进行分享
    [ShareSDK share:platform
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         [self didShareFinished:state userData:userData contentEntity:contentEntity withError:error fromParams:params];
     }];
}
- (void)didShareFinished:(SSDKResponseState)state  userData:(NSDictionary *)userData contentEntity:(SSDKContentEntity *)contentEntity withError:(NSError *)error fromParams:(LGXShareParams *)params
{
    switch (state) {
        case SSDKResponseStateSuccess:
        {
            [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"sharaSuccess", nil) isSuccess:YES];
            if (params.eventData) { // 如果有分享事件
                
                [TargetEngine pushViewController:nil fromController:nil withTarget:params.eventData];
                
            }
            
            break;
        }
        case SSDKResponseStateFail:
        {
            [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"sharaFailed", nil) isSuccess:NO];
            break;
        }
        case SSDKResponseStateCancel:
        {
            
            break;
        }
            
        default:
            break;
    }
}

@end





