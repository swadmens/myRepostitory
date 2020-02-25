//
//  UIColor+custom.m
//  
//
//  Created by icash on 16-3-2.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "UIColor+custom.h"

@implementation UIColor (custom)

/// #ffffff 转color
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

@end
