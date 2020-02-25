//
//  UIColor+_Hex.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (_Hex)

+ (UIColor *)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(float)alpha;

- (NSString *)hexString;
@end
