//
//  UIButton+BGColor.m
//  YY
//
//  Created by icash on 14-11-27.
//  Copyright (c) 2014年 iCash. All rights reserved.
//

#import "UIButton+BGColor.h"
#import "UIImage+custom.h"
@implementation UIButton (BGColor)

- (void)setBGColor:(UIColor *)color forState:(UIControlState)state
{
    UIImage *turnImage = [self createImageWithColor:color];
    [self setBackgroundImage:turnImage forState:state];
}
- (UIImage *)createImageWithColor: (UIColor *) color
{
    return [UIImage imageWithColor:color];
}
@end
