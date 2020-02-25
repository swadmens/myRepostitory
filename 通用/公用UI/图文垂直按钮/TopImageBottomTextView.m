//
//  TopImageBottomTextView.m
//  TaoChongYouPin
//
//  Created by icash on 16/8/19.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "TopImageBottomTextView.h"

@interface TopImageBottomTextView ()

@property (nonatomic, strong) NSLayoutConstraint *constraint_labelTop;

@end

@implementation TopImageBottomTextView

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
    _offsetBetweenImageAndTitle = 0.0;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
    [self.imageView leftToView:self withSpace:0];
    [self.imageView rightToView:self withSpace:0];
    [self.imageView topToView:self withSpace:0];
    [self.imageView addHeight:0 withPriority:252.0];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel addHeight:0 withPriority:249.0];
    [self.titleLabel leftToView:self withSpace:0];
    [self.titleLabel rightToView:self withSpace:0];
    [self.titleLabel bottomToView:self withSpace:0];
    
    self.constraint_labelTop = [self.titleLabel topToView:self.imageView withSpace:_offsetBetweenImageAndTitle];
}

- (void)setOffsetBetweenImageAndTitle:(CGFloat)offsetBetweenImageAndTitle
{
    
    if (offsetBetweenImageAndTitle == _offsetBetweenImageAndTitle) {
        return;
    }
    _offsetBetweenImageAndTitle = offsetBetweenImageAndTitle;
    self.constraint_labelTop.constant = _offsetBetweenImageAndTitle;
    [self layoutIfNeeded];
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











