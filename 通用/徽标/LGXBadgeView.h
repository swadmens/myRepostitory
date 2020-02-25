//
//  LGXBadgeView.h
//  
//
//  Created by icash on 15-12-14.
//  Copyright (c) 2015年 iCash. All rights reserved.
//


typedef NS_ENUM(NSUInteger, LGXBadgeViewAlignment)
{
    LGXBadgeViewAlignmentTopLeft = 1,
    LGXBadgeViewAlignmentTopRight,
    LGXBadgeViewAlignmentTopCenter,
    LGXBadgeViewAlignmentCenterLeft,
    LGXBadgeViewAlignmentCenterRight,
    LGXBadgeViewAlignmentBottomLeft,
    LGXBadgeViewAlignmentBottomRight,
    LGXBadgeViewAlignmentBottomCenter,
    LGXBadgeViewAlignmentCenter
};

@interface LGXBadgeView : NSObject

- (instancetype)initWithSuperView:(UIView *)sview alignment:(LGXBadgeViewAlignment)alignment;

- (void)layoutSubviews;

/// 值
@property (nonatomic, strong) NSString *badgeValue;
/// 当数字大于99时，显示+号 99+ 。 默认为NO
@property (nonatomic) BOOL showPlusWhenNumberMoreThan99;
/**
 * 是否始终是显示红点,默认是NO
 */
@property (nonatomic) BOOL alwaysShowPoint;
/**
 * 文本是0时，是否显示红点.，默认是YES
 * 红点是固定
 */
@property (nonatomic) BOOL showPointWhenZeroText;
/**
 * 当文本是0的时候，隐藏,默认是NO
 */
@property (nonatomic) BOOL hideWhenZeroText;
/**
 v设置红点大小,默认是 10
 */
@property (nonatomic) CGFloat pointSize;
/**
 * 文本颜色,默认是白色
 */
@property (nonatomic, strong) UIColor *badgeTextColor;
/**
 * 文本字体，customFont UIFont.systemfont
 */
@property (nonatomic, strong) UIFont *badgeTextFont;
/**
 * 颜色,默认是fd3422
 */
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
/**
 * 设定高度,默认是JSBadgeViewHeight
 */
@property (nonatomic) CGFloat badgeHeight;
/**
 * 外围边宽，默认是0
 */
@property (nonatomic, assign) CGFloat badgeStrokeWidth;

/**
 * 外围边颜色. 默认是白色
 */
@property (nonatomic, strong) UIColor *badgeStrokeColor;
/*
 * 文本距边界是多少，默认是JSBadgeViewTextSideMargin
 */
@property (nonatomic) CGFloat textSideMargin;

@property (nonatomic) BOOL hidden;
@property (nonatomic, readonly) UIView *badgeValueView;
@end
