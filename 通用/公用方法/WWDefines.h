//
//  WWDefines.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//


#ifndef Header_h
#define Header_h

#define kTabbarDoubleTapped @"tabbar.doubleTapped"
#define kTabbarTappedAgain @"tabbar.tappedAgain"
#define _AlipayHandleAppPay @"alipay.apphandle"
#define kAPPWillEnterForeground @"app.willEnterForeground"

#define kAPPID @"1415690821"
#define kMovieAPPID 1252853230

#define APPVersion @"1.3"


//百度地图key
#define KBaiduMapKey @"lFFGk9QPGvUZTEuq7T6IAEV42j52lHMw"


/**
 *判断是否是iPhoneX及以上版本
 */
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/**
 *导航栏高度
 */
#define SafeAreaTopHeight (IPHONE_X ? 88 : 64)
 
/**
 *tabbar高度
 */
#define SafeAreaBottomHeight (IPHONE_X ? (49 + 34) : 49)


#define kSignKey @"sign"//请求的签名
/// app 的apple store 地址
#define kAPPStoreURL @"https://itunes.apple.com/cn/app/tao-chong-you-pin/id1415690821?mt=8"//更新地址
/// 头像裁减大小
#define kHeaderPhotoSize @"100"

/// 贴纸最小缩放到多少
#define kMiniStickerScaleSize 30.0
/// 导航一般的空隙
#define kNavigationSpace 20.0
/// 导航上搜索的高度
#define kNavigationSearchHeight 32.0
/// 默认按钮的圆角
#define kButtonCornerRadius 5.0
#define kUploadScale 0.6

#define kDataModelName @"TaPinCaiXiaoAPP"
// 字体
#define FontName @"FZLanTingHei-EL-GBK"

// window任何事件按下通知
#define iScreenTouchEventHandle @"ScreenisTouched"
// 传送的userInfoKey
#define iTouchEventUserInfoKey @"ScreenUserInfokey"

/// viewcontroller 将要离开界面时，发送通知
#define kControllerWillDisappearHandle @"kControllerWillDisappearHandle"
/// 打印
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
// #   define PLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#else
#   define DLog(...)
#endif
// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

/// 加载主文程序内图片
#define UIImageNamed(file) [UIImage imageNamed:file]
#define UIImageWithFileName(file) [[ThemeEngine sharedInstance] readImageWithFileName:file atTheme:nil]
///
//#define UIImageWithFile(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]

/// 16进制转color 0x000000
#define UIColorFromRGB(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
/// #ffffff 转color
#define UIColorWithString(str,alphaValue) [ThemeEngine colorWithColorString:str andAlphaValue:alphaValue]
/// 透明色
#define UIColorClearColor [UIColor clearColor]
/// 主界面大小
#define kMainScreenSize [UIScreen mainScreen].bounds.size
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kMainCellColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:255/255.0 alpha:1]
#define kInputViewHeight 50

//手机系统是否是iOS11
#define KphoneVersion11 [[WWPhoneInfo getSystemVersion] integerValue]


/// 缩放系数
#define kMainScreenScale [UIScreen mainScreen].scale
/// 上传文件的压缩比例
#define kUploadPhotoScale 0.6

#define iWEAK @weakify(self);
#define iSTRONG @strongify(self);
/// 屏蔽 perform selector warning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)



#define IS_UNDER_IOS_8    floorf([[UIDevice currentDevice].systemVersion floatValue]) <= 8.0 ? 1 : 0
#define IS_UNDER_IOS_10    floorf([[UIDevice currentDevice].systemVersion floatValue]) < 10.0 ? 1 : 0

#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)
#define kMainScreenSizeHeight (IS_IPHONEX ? ([[UIScreen mainScreen] bounds].size.height-20):([[UIScreen mainScreen] bounds].size.height))




#ifdef DEBUG

#define kTestSdkAppId       @"1400094895"//测试下的正式ID
#define kSdkAppId       @"1400094851"

#else

#define kSdkAppId       @"1400094895"//正式

#endif


#define kSdkAccountType @"27297"
#define kQQAccountType  1
#define kWXAccountType  2


#define kSupportCustomConversation 1

#define kAppStoreVersion 0

#define kDefaultSubGroupIcon        [UIImage imageWithColor:kOrangeColor size:CGSizeMake(32, 32)]


#define kAppLargeTextFont       [UIFont customFontWithSize:16]
#define kAppMiddleTextFont      [UIFont customFontWithSize:15]
#define kAppSmallTextFont       [UIFont customFontWithSize:12]

#define kDefaultSilentUntil     100

#define kSaftyWordsCode 80001


#ifndef POD_PITU
#define POD_PITU 0

/**
 * QQ和微信sdk参数配置
 */

#define QQ_APP_ID @"222222"
#define QQ_OPEN_SCHEMA @"tencent222222"

#define WX_APP_ID @"wx65f71c2ea2b122da"
#define WX_OPEN_KEY @"69aed8b3fd41ed72efcfbdbca1e99a27"


// 最大昵称UTF8字符串长度
#define kNicknameMaxLength  64
// 好友分组UTF8字符串长度
#define kSubGroupMaxLength  30

#define kDefaultUserIcon            [UIImage imageNamed:@"icon_header"]
#define kDefaultGroupIcon           [UIImage imageNamed:@"default_yb_group"]
#define kDefaultSystemIcon          [UIImage imageNamed:@"default_yb_system"]


//==============================
// 聊天图片缩约图最大高度
#define kChatPicThumbMaxHeight 190.f
// 聊天图片缩约图最大宽度
#define kChatPicThumbMaxWidth 66.f

//==============================

// IMAMsg扩展参数的键
#define kIMAMSG_Image_ThumbWidth    @"kIMA_yb_ThumbWidth"
#define kIMAMSG_Image_ThumbHeight   @"kIMA_yb_ThumbHeight"
#define kIMAMSG_Image_OrignalPath   @"kIMA_yb_OrignalPath"
#define kIMAMSG_Image_ThumbPath     @"kIMA_yb_ThumbPath"

//==============================

// IMA中用到的消息相关通知
#define kIMAMSG_RevokeNotification @"kIMAMSG_yb_RevokeNotification"
#define kIMAMSG_DeleteNotification @"kIMAMSG_yb_DeleteNotification"
#define kIMAMSG_ResendNotification @"kIMAMSG_yb_ResendNotification"
#define kIMAMSG_ChangedNotification @"kIMAMSG_yb_ChangedNotification"
#define kIMAMSG_ListsNumberNotification @"kIMAMSG_yb_ListsNumberNotification"


//==============================

#define IMALocalizedError(intCode, enStr) NSLocalizedString(([NSString stringWithFormat:@"%d", (int)intCode]), enStr)

//==============================
// IMA内部使用的字休
#define kIMALargeTextFont       [UIFont customFontWithSize:16]
#define kIMAMiddleTextFont      [UIFont customFontWithSize:15]
#define kIMASmallTextFont       [UIFont customFontWithSize:12]


// 暂未用到
#define kAppBakgroundColor          RGBOF(0xF9F7F8)
#define kAppModalBackgroundColor    [kBlackColor colorWithAlphaComponent:0.6]
#define kAppModalDimbackgroundColor [RGB(16, 16, 16) colorWithAlphaComponent:0.3]

// TIMChat没有在此处设置
// 主色调
// 导航按钮
#define kNavBarThemeColor             RGB(128, 64, 122)
#define kNavBarHighlightThemeColor    RGB(161, 92, 154)

// 默认TableViewCell高度
#define kDefaultCellHeight 50
// 默认界面之间的间距
#define kDefaultMargin     10

// 默认的字体颜色
#define kMainTextColor                kBlackColor

#define kDetailTextColor              RGB(145, 145, 145)


#define kDownRefreshLoadOver    @"没有更多了"

#define kDownReleaseToRefresh   @"松开即可更新..."

#define kDownDragUpToRefresh    @"上拉即可更新..."

#define kDownRefreshLoading     @"加载中..."

// CommonLibrary中常用的字体
#define kCommonLargeTextFont       [UIFont systemFontOfSize:16]
#define kCommonMiddleTextFont      [UIFont systemFontOfSize:14]
#define kCommonSmallTextFont       [UIFont systemFontOfSize:12]

#if ! __has_feature(objc_arc)
#define CommonAutoRelease(__v) ([__v autorelease])
#define CommonReturnAutoReleased Autorelease

#define CommonRetain(__v) ([__v retain])
#define CommonReturnRetained Retain

#define CommonRelease(__v) ([__v release])

#define CommonDispatchQueueRelease(__v) (dispatch_release(__v))

#define PropertyRetain retain
// 在括号内声明时使用
#define CommonDelegateAssign
// 在property中使用
#define DelegateAssign assign
#define CommonSuperDealloc()  [super dealloc]
#else
// -fobjc-arc
#define CommonAutoRelease(__v)
#define CommonReturnAutoReleased(__v) (__v)

#define CommonRetain(__v)
#define CommonReturnRetained(__v) (__v)

#define CommonRelease(__v)

#define PropertyRetain strong
#define CommonDelegateAssign __unsafe_unretained
#define DelegateAssign unsafe_unretained
#define CommonSuperDealloc()

#if TARGET_OS_IPHONE
// Compiling for iOS
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
// iOS 6.0 or later
#define CommonDispatchQueueRelease(__v)
#else
// iOS 5.X or earlier
#define CommonDispatchQueueRelease(__v) (dispatch_release(__v))
#endif
#else
// Compiling for Mac OS X
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080
// Mac OS X 10.8 or later
#define CommonDispatchQueueRelease(__v)
#else
// Mac OS X 10.7 or earlier
#define CommonDispatchQueueRelease(__v) (dispatch_release(__v))
#endif
#endif
#endif



#endif /* Header_h */
#endif



