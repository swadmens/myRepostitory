//
//
//
//  Created by icash on 15-8-17.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import "LGXVerticalButton.h"

@implementation LGXVerticalButton
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self doSetup];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}
- (void)doSetup
{
    self.imageView.clipsToBounds = NO;
    
    self.offsetBetweenImageAndTitle = 4.0;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updatePosition];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self updatePosition];
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self updatePosition];
}
- (void)setOffsetBetweenImageAndTitle:(CGFloat)offsetBetweenImageAndTitle
{
    _offsetBetweenImageAndTitle = offsetBetweenImageAndTitle;
    [self updatePosition];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updatePosition];
}
- (void)updatePosition
{
    CGFloat offset = self.offsetBetweenImageAndTitle;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height-offset, 0);
    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height-offset, 0, 0, -self.titleLabel.intrinsicContentSize.width);
}
#pragma mark - 徽标
- (void)showBadgeViewOnImageView
{
    self.imageView.showBadgeView = YES;
    LGXBadgeView *badgeView = self.imageView.badgeView;
    badgeView.showPointWhenZeroText = NO;
}
- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    self.imageView.badgeView.badgeValue = _badgeValue;
}


@end
