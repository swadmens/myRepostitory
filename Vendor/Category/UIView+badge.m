//
//  UIView+badge.m
//  TaoChongYouPin
//
//  Created by icash on 16/8/19.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "UIView+badge.h"
#import <objc/runtime.h>

NSString const *UIButton_badgeViewKey = @"UIButton_badgeViewKey";

@implementation UIView (badge)
@dynamic showBadgeView,badgeView;

- (void)setShowBadgeView:(BOOL)showBadgeView
{
    if (showBadgeView) {
        if (self.badgeView) {
            return;
        }
        [self setupBadgeView];
    } else {
        [self.badgeView.badgeValueView removeFromSuperview];
        self.badgeView = nil;
    }
}
- (void)setupBadgeView
{
    self.badgeView = [[LGXBadgeView alloc] initWithSuperView:self alignment:LGXBadgeViewAlignmentTopRight];
//    self.badgeView.badgeTextFont = [UIFont customFontWithSize:kFontSizeTwelve];
}

// Badge font
- (LGXBadgeView *)badgeView
{
    return objc_getAssociatedObject(self, &UIButton_badgeViewKey);
}
- (void)setBadgeView:(LGXBadgeView *)badgeView
{
    objc_setAssociatedObject(self, &UIButton_badgeViewKey, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
