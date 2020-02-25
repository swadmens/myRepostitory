//
//  ThemeEngine.m
//  YaYaGongShe
//
//  Created by icash on 16-3-2.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "ThemeEngine.h"

@implementation ThemeEngine

+ (ThemeEngine *)sharedInstance
{
    static ThemeEngine *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ThemeEngine alloc] init];
        
    });
    return _manager;
}
#pragma mark - 图片读取
- (UIImage *)readImageWithFileName:(NSString *)file atTheme:(NSString *)themeName
{
    UIImage *image = [UIImage imageNamed:file];
    return image;
}
+ (UIColor *)colorWithColorString:(NSString *)colorString andAlphaValue:(float)alphaValue
{
    if (colorString == nil || [colorString hasPrefix:@"#"]==NO) {
        return nil;
    }
    
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    unsigned long rgbValue = strtoul([colorString UTF8String],0,16);
    UIColor *color = [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue];
    return color;
}
#pragma mark - 颜色

/// 第一主色系
- (UIColor *)mainColor
{
    if (!_mainColor) {
        _mainColor = UIColorFromRGB(0x059dfe, 1);
    }
    return _mainColor;
}
/// ebebeb 线条颜色
- (UIColor *)lineColor
{
    if (!_lineColor) {
        _lineColor = UIColorFromRGB(0xebebeb, 1);
    }
    return _lineColor;
}
- (UIColor *)backgroundColor
{
    if (!_backgroundColor) {
        _backgroundColor = UIColorFromRGB(0xfafafa, 1);
    }
    return _backgroundColor;
}
- (UIColor *)backSecondColor
{
    if (!_backSecondColor) {
        _backSecondColor = UIColorFromRGB(0xf5f5f5, 1);
    }
    return _backSecondColor;
}
/// tabbar 普通色
- (UIColor *)tabbarNormalColor
{
    if (!_tabbarNormalColor) {
        _tabbarNormalColor = UIColorFromRGB(0x585755, 1);
    }
    return _tabbarNormalColor;
}
/// tabbar 选中
- (UIColor *)tabbarChosedColor
{
    if (!_tabbarChosedColor) {
        _tabbarChosedColor = UIColorFromRGB(0x059dfe, 1);
    }
    return _tabbarChosedColor;
}
/// tabbar 背景色
- (UIColor *)tabbarBGColor
{
    if (!_tabbarBGColor) {
        _tabbarBGColor = UIColorFromRGB(0xffffff, 1);
    }
    return _tabbarBGColor;
}
/// 导航字体色
- (UIColor *)navTitleColor
{
    if (!_navTitleColor) {
        _navTitleColor = UIColorFromRGB(0xffffff, 1);
    }
    return _navTitleColor;
}

/// b10101 商品页面商品价格字体颜色和提醒字体的颜色
- (UIColor *)redTextColor
{
    if (!_redTextColor) {
        _redTextColor = UIColorFromRGB(0xf55a52, 1);
    }
    return _redTextColor;
}
/// fdd702 提醒字体的颜色
- (UIColor *)yellowTextColor
{
    if (!_yellowTextColor) {
        _yellowTextColor = UIColorFromRGB(0xfdd702, 1);
    }
    return _yellowTextColor;
}
/// f6594f 徽标红色
- (UIColor *)orangeTextColor
{
    if (!_orangeTextColor) {
        _orangeTextColor = UIColorFromRGB(0xf6594f, 1);
    }
    return _orangeTextColor;
}

/// 333333 正文的标题颜色，其他列表标题颜色
- (UIColor *)mainTextColor
{
    if (!_mainTextColor) {
        _mainTextColor = UIColorFromRGB(0x333333, 1);
    }
    return _mainTextColor;
}
/// 0x666666 说明文文字颜色
- (UIColor *)secondTextColor
{
    if (!_secondTextColor) {
        _secondTextColor = UIColorFromRGB(0x666666, 1);
    }
    return _secondTextColor;
}
/// 0x999999 说明文文字颜色
- (UIColor *)thirdTextColor
{
    if (!_thirdTextColor) {
        _thirdTextColor = UIColorFromRGB(0x999999, 1);
    }
    return _thirdTextColor;
}
/// 8e8e93
- (UIColor *)mainViceTextColor
{
    if (!_mainViceTextColor) {
        _mainViceTextColor = UIColorFromRGB(0x8e8e93, 1);
    }
    return _mainViceTextColor;
}
-(void)zitikuwenjian
{
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        DLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            DLog(@"\tfont:'%@'",fontName);
        }
        DLog(@"-------------");
    }
}

@end




