//
//  EPPageControl.m
//  EpetMallV3
//
//  Created by icash on 16/9/27.
//  Copyright © 2016年 com.epetbar.deals. All rights reserved.
//

#import "EPPageControl.h"

@interface EPPageControl ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong, readwrite) NSArray *constraintArray;
@property (nonatomic, strong, readwrite) NSArray *viewsArray;


@end

@implementation EPPageControl

- (CGFloat)selectedBallDiameter
{
    if (_selectedBallDiameter == 0) {
        _selectedBallDiameter = 10;
    }
    return _selectedBallDiameter;
}
- (void)setCurrentPage:(NSInteger)currentPage {
    
    if (currentPage > (self.numberOfPages-1)) {
        return;
    }
    if (_currentPage != currentPage) {
        // 执行动画
        [self animationSubViewsFrom:_currentPage to:currentPage];
        _currentPage = currentPage;
    }
}

- (void)setContentOffset_x:(CGFloat)contentOffset_x {
    
    if (_contentOffset_x != contentOffset_x) {
        
        _contentOffset_x = contentOffset_x;
        [self calculateProgress];
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (numberOfPages == _numberOfPages) {
        return;
    }
    if (numberOfPages <=1) {
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    _numberOfPages = numberOfPages;
    [self setupPageViews];
}

- (void)setLastContentOffset_x:(CGFloat)lastContentOffset_x {
    
    _lastContentOffset_x = lastContentOffset_x;
}

- (void)calculateProgress {
    
    CGFloat pageWidth = self.bindingScrollView.frame.size.width;
    
    int currentPage = floor((self.contentOffset_x - pageWidth * .5) / pageWidth) + 2;
    self.currentPage = currentPage;
}

- (void)setBindingScrollView:(UIScrollView *)bindingScrollView {
    
    _bindingScrollView = bindingScrollView;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    if (selectedColor == _selectedColor) {
        return;
    }
    _selectedColor = selectedColor;
    if (self.viewsArray.count > self.currentPage) {
        UIView *view = [self.viewsArray objectAtIndex:self.currentPage];
        view.backgroundColor = _selectedColor;
    }
}

- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    
    if (unSelectedColor == _unSelectedColor) {
        return;
    }
    _unSelectedColor = unSelectedColor;
    for (int i =0; i<self.viewsArray.count; i++) {
        if (i != self.currentPage) {
            UIView *view = [self.viewsArray objectAtIndex:i];
            view.backgroundColor = _unSelectedColor;
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.ballDiameter = 5.0;
        self.selectedColor = [UIColor whiteColor];
        self.unSelectedColor = [UIColor colorWithWhite:1 alpha:0.6];
    }
    return self;
}

- (void)setupPageViews
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.contentView == nil) {
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        [self.contentView addCenterX:0 toView:self];
        [self.contentView addCenterY:0 toView:self];
        [self.contentView addHeight:self.ballDiameter];
    }
    
    CGFloat hspace = 7.0;
    UIView *exView = nil;
    
    NSMutableArray *temp_cons = [NSMutableArray arrayWithCapacity:self.numberOfPages];
    NSMutableArray *temp_views = [NSMutableArray arrayWithCapacity:self.numberOfPages];
    /// 循环添加
    for (int i =0; i<self.numberOfPages; i++) {
        UIView *oneView = [[UIView alloc] init];
        [self.contentView addSubview:oneView];
        
//        oneView.layer.cornerRadius = self.ballDiameter / 2.0;
//        oneView.clipsToBounds = YES;
        
        CGFloat offset = 0;
        if (i == self.currentPage) {
            offset = self.selectedBallDiameter;
            oneView.backgroundColor = self.selectedColor;
        } else {
            oneView.backgroundColor = self.unSelectedColor;
        }
        NSLayoutConstraint *constraint_width = [oneView setAttribute:AttributeWidth toView:oneView byAttribute:AttributeHeight multiplier:1 offset:offset];
        [oneView topToView:self.contentView withSpace:0];
        [oneView bottomToView:self.contentView withSpace:0];
        
        CGFloat space = hspace;
        if (i == 0) {
            space = 0;
            exView = self.contentView;
        }
        
        [oneView leftToView:exView withSpace:space];
        exView = oneView;
        
        //
        [temp_cons addObject:constraint_width];
        [temp_views addObject:oneView];
    }
    self.viewsArray = [NSArray arrayWithArray:temp_views];
    self.constraintArray = [NSArray arrayWithArray:temp_cons];
    
    // 最后一个，右贴紧
    [exView rightToView:self.contentView withSpace:0];
    
    /// 选中当前选中的
}
#pragma mark - 动画效果
- (void)animationSubViewsFrom:(NSInteger)fromIndex to:(NSInteger)toIndex withProgress:(CGFloat)progress
{
    fromIndex = MAX(0, fromIndex); fromIndex = MIN(self.numberOfPages, fromIndex);
    toIndex = MAX(0, toIndex); toIndex = MIN(self.numberOfPages, toIndex);
    
    progress = MIN(1, progress);
    
    NSLayoutConstraint *constraint_from = [self.constraintArray objectAtIndex:fromIndex];
    NSLayoutConstraint *constraint_to = [self.constraintArray objectAtIndex:toIndex];
    
    UIView *view_from = [self.viewsArray objectAtIndex:fromIndex];
    UIView *view_to = [self.viewsArray objectAtIndex:toIndex];
    
    constraint_from.constant = 0;
    constraint_to.constant = self.selectedBallDiameter * progress;
    
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:0 animations:^{
        
        [self.contentView layoutIfNeeded];
        
        view_from.backgroundColor = self.unSelectedColor;
        view_to.backgroundColor = self.selectedColor;
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)animationSubViewsFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    [self animationSubViewsFrom:fromIndex to:toIndex withProgress:1];
}
@end







