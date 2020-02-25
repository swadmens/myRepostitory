//
//  TwoLineLabelView.m
//  TaoChongYouPin
//
//  Created by icash on 16/8/19.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "TwoLineLabelView.h"

@interface TwoLineLabelView ()

@property (nonatomic, strong) NSLayoutConstraint *constraint_labelTop;
@property (nonatomic, strong) UIButton *corverButton;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation TwoLineLabelView

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
    _offsetBetweenImageAndTitle = 4.0;
    
    //
    self.corverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.corverButton.backgroundColor = [UIColor clearColor];
    [self.corverButton setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:self.corverButton];
    [self.corverButton alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self];
    
    //
    //
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.userInteractionEnabled = NO;
    [self addSubview:self.contentView];
    [self.contentView leftToView:self withSpace:0];
    [self.contentView rightToView:self withSpace:0];
    [self.contentView addHeight:0 withPriority:249];
    [self.contentView addCenterY:0 toView:self];
    
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.backgroundColor = [UIColor clearColor];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    self.bottomLabel.userInteractionEnabled = NO;
    self.bottomLabel.textColor = kColorMainTextColor;
    
    [self.contentView addSubview:self.bottomLabel];
    [self.bottomLabel addHeight:0 withPriority:249.0];
    [self.bottomLabel leftToView:self.contentView withSpace:0];
    [self.bottomLabel rightToView:self.contentView withSpace:0];
    [self.bottomLabel bottomToView:self.contentView withSpace:0];
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = [UIFont customBoldFontWithSize:kFontSizeThirteen];
    self.topLabel.userInteractionEnabled = NO;
    self.topLabel.textColor = kColorMainColor;
    
    [self.contentView addSubview:self.topLabel];
    [self.topLabel leftToView:self.contentView withSpace:0];
    [self.topLabel rightToView:self.contentView withSpace:0];
    [self.topLabel topToView:self.contentView withSpace:0];
    [self.topLabel addHeight:0 withPriority:249.0];
    
    self.constraint_labelTop = [self.topLabel bottomToView:self.bottomLabel withSpace:self.offsetBetweenImageAndTitle withPriority:252];
    
    
    
}

- (void)setOffsetBetweenImageAndTitle:(CGFloat)offsetBetweenImageAndTitle
{
    
    if (offsetBetweenImageAndTitle == _offsetBetweenImageAndTitle) {
        return;
    }
    _offsetBetweenImageAndTitle = offsetBetweenImageAndTitle;
    self.constraint_labelTop.constant = -1*_offsetBetweenImageAndTitle;
    [self layoutIfNeeded];
}
///
- (void)setBGColor:(UIColor *)color forState:(UIControlState)state
{
    [self.corverButton setBGColor:color forState:state];
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.corverButton addTarget:target action:action forControlEvents:controlEvents];
}
@end
