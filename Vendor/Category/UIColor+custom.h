//
//  UIColor+custom.h
//  
//
//  Created by icash on 16-3-2.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (custom)
/// #ffffff 转color
+ (UIColor *)colorWithColorString:(NSString *)colorString andAlphaValue:(float)alphaValue;

@end
