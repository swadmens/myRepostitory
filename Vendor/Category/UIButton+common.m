//
//  UIButton+common.m
//  TaoChongYouPin
//
//  Created by icash on 16/8/30.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "UIButton+common.h"
#import <objc/runtime.h>

NSString const *UIButton_textKey = @"UIButton_textKey";

@implementation UIButton (common)
@dynamic text;

- (NSString *)text
{
    return self.currentTitle;
}
- (void)setText:(NSString *)text
{
    [self setTitle:text forState:UIControlStateNormal];
}

@end
