//
//  ThemeEngine.h
//  YaYaGongShe
//
//  Created by icash on 16-3-2.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ThemeEngine : NSObject


+ (ThemeEngine *)sharedInstance;

/// 059dfe 主色系 紫色
@property (nonatomic, strong) UIColor *mainColor;

/// 585755 tabbar 普通色
@property (nonatomic, strong) UIColor *tabbarNormalColor;
/// 059dfe tabbar 选中色
@property (nonatomic, strong) UIColor *tabbarChosedColor;
/// f2f2f2 tabbar 背景色
@property (nonatomic, strong) UIColor *tabbarBGColor;
/// ffffff 导航字体色
@property (nonatomic, strong) UIColor *navTitleColor;
/// ebebeb 线条颜色
@property (nonatomic, strong) UIColor *lineColor;
/// fafafa 背景颜色
@property (nonatomic, strong) UIColor *backgroundColor;
/// f5f5f5 背景颜色
@property (nonatomic, strong) UIColor *backSecondColor;


/// b10101 商品页面商品价格字体颜色和提醒字体的颜色
@property (nonatomic, strong) UIColor *redTextColor;
/// fdd702 提醒字体的颜色
@property (nonatomic, strong) UIColor *yellowTextColor;
/// fc6222 购物车橙色
@property (nonatomic, strong) UIColor *orangeTextColor;
/// 333333 正文的标题颜色，其他列表标题颜色
@property (nonatomic, strong) UIColor *mainTextColor;
/// 8e8e93 副文本标题颜色
@property (nonatomic, strong) UIColor *mainViceTextColor;
/// 666666 说明文文字颜色
@property (nonatomic, strong) UIColor *secondTextColor;
/// 999999 说明文文字颜色
@property (nonatomic, strong) UIColor *thirdTextColor;


#pragma mark - 读图片 

- (UIImage *)readImageWithFileName:(NSString *)file atTheme:(NSString *)themeName;
/// #ffffff 转color
+ (UIColor *)colorWithColorString:(NSString *)colorString andAlphaValue:(float)alphaValue;
@end

/**
 * 38 - 对应 19.0 .
 * 如 导航栏字体大小
 */
static float const kFontSizeNineTeen = 19.0;

static float const kFontSizeEighTeen = 18.0;
/**
 * 30 - 对应 16.0 .
 * 如 正文标题字体
 */
static float const kFontSizeSixteen = 16.0;
/**
 * 30 - 对应 15.0 .
 * 如 次文标题字体
 */
static float const kFontSizeFifty = 15.0;

/**
 * 30 - 对应 14.0 .
 * 如 某些副标题字体
 */
static float const kFontSizeFourteen = 14.0;
/**
 * 26 - 对应 13.0 .
 * 如 首页正文文本
 */
static float const kFontSizeThirteen = 13.0;
/**
 * 24 - 对应 12 .
 * 如 首页用户信息的地址
 */
static float const kFontSizeTwelve = 12.0;
/**
 * 22 - 对应 10 .
 * 如 首页用户信息字体
 */
static float const kFontSizeTen = 10.0;
/**
 *  - 对应 8 .
 * 如 首页用户信息字体
 */
static float const kFontSizeEight = 8.0;






