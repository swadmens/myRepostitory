//
//  WWTableViewCell.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

@interface WWTableViewCell ()

@property (nonatomic, strong) UIView *lineView;

@end
@implementation WWTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    [self dosetup];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self dosetup];
        
    }
    return self;
}
- (void)dosetup
{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
 * @param isTop : 是不是顶部，默认是底部
 * @param color : 默认不用管
 * @param left : 距左多少(默认0) right : 距右多少(默认0)
 */
- (void)showLineAtTop:(BOOL)isTop
            WithColor:(UIColor *)color
                 left:(CGFloat)leftPoint
             andRight:(CGFloat)rightPoint
{
    [[GCDQueue mainQueue] queueBlock:^{
        if (color) {
            self.lineView.backgroundColor = color;
        }
        if (self.lineView.superview) {
            return;
        }
        [self addSubview:self.lineView];
        self.lineView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.lineView leftToView:self withSpace:leftPoint];
        [self.lineView rightToView:self withSpace:rightPoint];
        if (isTop) {
            [self.lineView topToView:self];
        }else{
            [self.lineView bottomToView:self];
        }
        [self.lineView addHeight:0.5];
        [self layoutIfNeeded];
        
    }];
    
}
- (void)setLineHidden:(BOOL)lineHidden
{
    _lineHidden = lineHidden;
    if (_lineHidden) {
        if (_lineView) {
            self.lineView.hidden = YES;
        }
    }else{
        [self showLineAtTop:NO WithColor:nil left:0 andRight:0];
        self.lineView.hidden = NO;
    }
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}
+ (NSString *)getCellIDStr
{
    return NSStringFromClass([self class]);
}

@end
