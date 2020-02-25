//
//  LGXHorizontalButton.m
//  TaoChongYouPin
//
//  Created by icash on 16/8/20.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "LGXHorizontalButton.h"

@implementation LGXHorizontalButton

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
//    //
//    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width-offset, 0, 0);
//    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
//    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
//    self.imageEdgeInsets = UIEdgeInsetsMake(0, -self.titleLabel.intrinsicContentSize.width-offset, 0, 0);
//    // -self.titleLabel.intrinsicContentSize.width
    
    
    self.imageEdgeInsets  = UIEdgeInsetsMake(0, -offset/2.0, 0, offset/2.0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, offset/2.0, 0, -offset/2.0);
    
}

@end
