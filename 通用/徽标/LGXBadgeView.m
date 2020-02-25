//
//  LGXBadgeView.m
//  GutouV3
//
//  Created by icash on 15-12-14.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import "LGXBadgeView.h"
#import "JSBadgeView.h"

@interface LGXBadgeView ()

@property (nonatomic, strong) JSBadgeView *badgeView;

@end

@implementation LGXBadgeView

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    self.badgeView.badgeText = _badgeValue;
}
- (void)layoutSubviews
{
    [self.badgeView layoutSubviews];
}
- (instancetype)initWithSuperView:(UIView *)sview alignment:(LGXBadgeViewAlignment)alignment
{
    self = [super init];
    if (self) {
        JSBadgeViewAlignment Jalignment = JSBadgeViewAlignmentCenter;
        switch (alignment) {
            case LGXBadgeViewAlignmentTopLeft:
                Jalignment = JSBadgeViewAlignmentTopLeft;
                break;
            case LGXBadgeViewAlignmentTopRight:
                Jalignment = JSBadgeViewAlignmentTopRight;
                break;
            case LGXBadgeViewAlignmentTopCenter:
                Jalignment = JSBadgeViewAlignmentTopCenter;
                break;
            case LGXBadgeViewAlignmentCenterLeft:
                Jalignment = JSBadgeViewAlignmentCenterLeft;
                break;
            case LGXBadgeViewAlignmentCenterRight:
                Jalignment = JSBadgeViewAlignmentCenterRight;
                break;
            case LGXBadgeViewAlignmentBottomLeft:
                Jalignment = JSBadgeViewAlignmentBottomLeft;
                break;
            case LGXBadgeViewAlignmentBottomRight:
                Jalignment = JSBadgeViewAlignmentBottomRight;
                break;
            case LGXBadgeViewAlignmentBottomCenter:
                Jalignment = JSBadgeViewAlignmentBottomCenter;
                break;
            default:
                break;
        }
        self.badgeView = [[JSBadgeView alloc] initWithParentView:sview alignment:Jalignment];
        self.badgeBackgroundColor = kColorBageRedColor;//UIColorFromRGB(0xfd3422, 1);
        self.badgeTextColor = [UIColor whiteColor];
        self.badgeTextFont = [UIFont customFontWithSize:12];
        self.badgeStrokeColor = [UIColor clearColor];
        self.badgeStrokeWidth = 1.0;
        self.showPlusWhenNumberMoreThan99 = YES;
        self.badgeView.badgeHeight = 16.0;
        self.hideWhenZeroText = YES;
    }
    
    return self;
}
- (void)setShowPlusWhenNumberMoreThan99:(BOOL)showPlusWhenNumberMoreThan99
{
    _showPlusWhenNumberMoreThan99 = showPlusWhenNumberMoreThan99;
    self.badgeView.showPlusWhenNumberMoreThan99 = _showPlusWhenNumberMoreThan99;
}
- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    self.badgeView.hidden = _hidden;
}
- (void)setShowPointWhenZeroText:(BOOL)showPointWhenZeroText
{
    _showPointWhenZeroText = showPointWhenZeroText;
    self.badgeView.showPointWhenZeroText = _showPointWhenZeroText;
}
- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    self.badgeView.badgeTextColor = _badgeTextColor;
}
- (void)setBadgeTextFont:(UIFont *)badgeTextFont
{
    _badgeTextFont = badgeTextFont;
    self.badgeView.badgeTextFont = _badgeTextFont;
}
- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _badgeBackgroundColor = badgeBackgroundColor;
    self.badgeView.badgeBackgroundColor = _badgeBackgroundColor;
}
- (void)setHideWhenZeroText:(BOOL)hideWhenZeroText
{
    _hideWhenZeroText = hideWhenZeroText;
    self.badgeView.hideWhenZeroText = _hideWhenZeroText;
}
- (void)setBadgeHeight:(CGFloat)badgeHeight
{
    _badgeHeight = badgeHeight;
    self.badgeView.badgeHeight = _badgeHeight;
}
- (void)setBadgeStrokeColor:(UIColor *)badgeStrokeColor
{
    _badgeStrokeColor = badgeStrokeColor;
    self.badgeView.badgeStrokeColor = _badgeStrokeColor;
}
- (void)setBadgeStrokeWidth:(CGFloat)badgeStrokeWidth
{
    _badgeStrokeWidth = badgeStrokeWidth;
    self.badgeView.badgeStrokeWidth = _badgeStrokeWidth;
}
- (void)setTextSideMargin:(CGFloat)textSideMargin
{
    _textSideMargin = textSideMargin;
    self.badgeView.textSideMargin = _textSideMargin;
}
- (UIView *)badgeValueView
{
    return self.badgeView;
}
@end





