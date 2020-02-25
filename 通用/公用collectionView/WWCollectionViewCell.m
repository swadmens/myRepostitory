//
//  WWCollectionViewCell.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWCollectionViewCell.h"

@interface WWCollectionViewCell ()

@property (nonatomic, strong) UIView *lineView;

@end
@implementation WWCollectionViewCell
- (void)awakeFromNib {
    // Initialization code
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
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kColorLineColor;
    }
    return _lineView;
}
/**
 * 请关闭 tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
 * @param isTop:是不是顶部，默认是底部
 * @param color:默认不用管
 * @param left:距左多少(默认0) right:距右多少(默认0)
 */
- (void)showLineAt:(BOOL)isTop
         WithColor:(UIColor *)color
              left:(CGFloat)leftPoint
          andRight:(CGFloat)rightPoint
{
    if (color) {
        self.lineView.backgroundColor = color;
    }
    if (self.lineView.superview) {
        return;
    }
    [self addSubview:self.lineView];
    self.lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:leftPoint]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-1*rightPoint]];
    if (isTop) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    }else{
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];
}
- (void)setLineHidden:(BOOL)lineHidden
{
    _lineHidden = lineHidden;
    if (_lineHidden) {
        if (_lineView) {
            self.lineView.hidden = YES;
        }
    }else{
        [self showLineAt:NO WithColor:nil left:0 andRight:0];
        self.lineView.hidden = NO;
    }
}
+ (NSString *)getCellIDStr
{
    return NSStringFromClass([self class]);
}

@end
