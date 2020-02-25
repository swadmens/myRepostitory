//
//  YYButton.m
//  YaYaGongShe
//
//  Created by icash on 16-3-2.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "LGXButton.h"
#import "UIView+animations.h"


@interface LGXButton ()
{
    BOOL _hadSetup;
}


@end

@implementation LGXButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self dosetup];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self dosetup];
}

- (void)dosetup
{
    if (_hadSetup)
        return;
    _hadSetup = YES;
}
- (void)setHighlighted:(BOOL)highlighted
{
    if (self.useAlphaWhenHighlighted) {
        if (highlighted) {
            self.alpha = 0.5;
        }else{
            self.alpha = 1;
        }
    }
    else{
        [super setHighlighted:highlighted];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.showFlashAnimation) {
        UITouch *touch = touches.anyObject;
        CGPoint point = [touch locationInView:self];
        [self showFlashFromPoint:point withColor:self.flashColor];
    }
}
@end









