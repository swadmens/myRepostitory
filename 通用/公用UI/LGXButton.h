//
//  YYButton.h
//  YaYaGongShe
//
//  Created by icash on 16-3-2.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGXButton : UIButton

/// 显示光晕效果,默认是NO
@property (nonatomic) BOOL showFlashAnimation;
/// 光晕颜色
@property (nonatomic, strong) UIColor *flashColor;

/// 使用按下去的效果
@property (nonatomic) BOOL useAlphaWhenHighlighted;
@end
