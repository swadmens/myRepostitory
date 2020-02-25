//
// UIScrollView+SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//


//static NSString *const _refreshTipOfNormal = NSLocalizedString(@"DropdownRefresh", nil);
//static NSString *const _refreshTipOfLoading = NSLocalizedString(@"lifeLoading", nil);
//static NSString *const _refreshTipOfGo = NSLocalizedString(@"flushRefresh", nil);

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVPullToRefresh.h"
#import "RefreshControlView.h"


//fequal() and fequalzro() from http://stackoverflow.com/a/1614761/184130
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)

/// 刷新的view的高
static CGFloat const SVPullToRefreshViewHeight = 60;

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*/

@interface SVPullToRefreshView ()
{
    /// 用于全局控制几个状态
    int _stateCount;
}
@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
/// 真正的Y
@property (nonatomic) CGFloat realY;
/// 容器
@property (nonatomic, strong) UIView *contentView;
/// 左边图片
@property (nonatomic, strong, readwrite) UIImageView *iconImageView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *subtitleLabel;

@property (nonatomic, readwrite) SVPullToRefreshState state;
@property (nonatomic, readwrite) SVPullToRefreshPosition position;
/// 所有的标题
@property (nonatomic, strong) NSMutableArray *titles;
/// 所有的副标题
@property (nonatomic, strong) NSMutableArray *subtitles;
/// 所有的状态
@property (nonatomic, strong) NSMutableArray *viewForState;

@property (nonatomic, weak) UIScrollView *scrollView;
/// contentInset.top
@property (nonatomic, readwrite) CGFloat originalTopInset;
/// contentInset.bottom
@property (nonatomic, readwrite) CGFloat originalBottomInset;

@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property (nonatomic, assign) BOOL showsDateLabel;
@property(nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
/// isHidden == YES时，动画效果时间要慢一点
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset isHidden:(BOOL)isHidden;
//- (void)rotateArrow:(float)degrees hide:(BOOL)hide;


/// 自定的一个
@property (nonatomic, strong) RefreshControlView *yyView;


@end

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*/

#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;
static char UICTopView;
static char UICBottomView;

@interface UIScrollView ()
/// 下拉顶部自定view
@property (nonatomic, strong) UIView *CTopView;
/// 下拉底部自定view
@property (nonatomic, strong) UIView *CBottomView;

@end

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView, showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(SVPullToRefreshPosition)position {
    
    if(!self.pullToRefreshView) {
        CGFloat yOrigin;
        switch (position) {
            case SVPullToRefreshPositionTop:
                yOrigin = -SVPullToRefreshViewHeight;
                break;
            case SVPullToRefreshPositionBottom:
                yOrigin = self.contentSize.height;
                break;
            default:
                return;
        }
        /// 设定刷新的VIEW
        SVPullToRefreshView *view = [[SVPullToRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight)];
        view.realY = yOrigin;
        view.pullToRefreshActionHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalTopInset = self.contentInset.top;
        view.originalBottomInset = self.contentInset.bottom;
        view.position = position;
        self.pullToRefreshView = view;
        self.showsPullToRefresh = YES; // 显示下拉刷新界面
    }
    
}

/**
 * 增加下拉刷新下面的，自定view
 * @param cview 必须提前设定好高度,cview = nil时移除相应位置的view
 * @param position 0:上，1:下。添加到下拉刷新view的顶还是底
 */
- (void)addCustomView:(UIView *)cview atPosition:(NSInteger)position
{
    if (position == 0) { // 在顶部的话，无伤大雅
        
        if (self.CTopView.superview) {
            [self.CTopView removeFromSuperview];
            self.CTopView = nil;
        }
        self.CTopView = cview;
        if (self.CTopView.superview == nil) {
            self.CTopView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self addSubview:self.CTopView];
        }
    } else {
        /// 改变frame
        if (self.CBottomView.superview) {
            [self.CBottomView removeFromSuperview];
            self.CBottomView = nil;
        }
        self.CBottomView = cview;
        if (self.CBottomView.superview == nil) {
            self.CBottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self addSubview:self.CBottomView];
        }
    }
    /// 重设frame
    [self resetViewFrames];
}
- (void)setCTopView:(UIView *)CTopView
{
    [self willChangeValueForKey:@"CTopView"];
    objc_setAssociatedObject(self, &UICTopView,
                             CTopView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"CTopView"];
    
}
- (UIView *)CTopView
{
    return objc_getAssociatedObject(self, &UICTopView);
}
- (void)setCBottomView:(UIView *)CBottomView
{
    [self willChangeValueForKey:@"CBottomView"];
    objc_setAssociatedObject(self, &UICBottomView,
                             CBottomView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"CBottomView"];
    
}
- (UIView *)CBottomView
{
    return objc_getAssociatedObject(self, &UICBottomView);
}

/// 重设frame
- (void)resetViewFrames
{
    // 从下往上推
    CGRect bottomRect = CGRectZero;
    if (self.CBottomView) {
        CGRect frame = self.CBottomView.frame;
        frame.origin.x = 0;
        frame.origin.y = -1*frame.size.height;
        frame.size.width = self.bounds.size.width;
        self.CBottomView.frame = frame;
        
        bottomRect = frame;
    }
    
    /// pullview
    CGRect pullRect = CGRectZero;
    if (self.pullToRefreshView && self.showsPullToRefresh) {
        
        CGRect frame = self.pullToRefreshView.frame;
        frame.size.width = self.bounds.size.width;
        frame.size.height = SVPullToRefreshViewHeight;
        frame.origin.x = 0;
        frame.origin.y = bottomRect.origin.y + -1*frame.size.height;
        self.pullToRefreshView.frame = frame;
        self.pullToRefreshView.realY = frame.origin.y;
        pullRect = frame;
    }
    
    /// 顶
    CGRect topRect = CGRectZero;
    if (self.CTopView) { // 如果有顶部
       
        CGRect frame = self.CTopView.frame;
        frame.size.width = self.bounds.size.width;
        frame.origin.x = 0;
        frame.origin.y = pullRect.origin.y + -1* frame.size.height;
        self.CTopView.frame = frame;
        
        topRect = frame;
    }
}

/// 默认加到顶部
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    [self addPullToRefreshWithActionHandler:actionHandler position:SVPullToRefreshPositionTop];
}
/// 手动触发刷新
- (void)triggerPullToRefresh {
    if (self.pullToRefreshView.state == SVPullToRefreshStateLoading || self.pullToRefreshView.state == SVPullToRefreshStateTriggered) {
        return;
    }
    self.pullToRefreshView.state = SVPullToRefreshStateTriggered;
    [self.pullToRefreshView startAnimating];
}
/// 设置下拉刷新样式
- (void)setPullToRefreshView:(SVPullToRefreshView *)pullToRefreshView {
    [self willChangeValueForKey:@"SVPullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"SVPullToRefreshView"];
}
/// 获取下拉刷新的view
- (SVPullToRefreshView *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}
/// 设置显示或隐藏下拉刷新view
- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh {
    self.pullToRefreshView.hidden = !showsPullToRefresh;
    
    if(!showsPullToRefresh) {
        if (self.pullToRefreshView.isObserving) {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [self.pullToRefreshView resetScrollViewContentInset];
            self.pullToRefreshView.isObserving = NO;
        }
    }
    else {
        if (!self.pullToRefreshView.isObserving) {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.pullToRefreshView.isObserving = YES;
            
            CGFloat yOrigin = 0;
            switch (self.pullToRefreshView.position) {
                case SVPullToRefreshPositionTop:
                {
                    [self resetViewFrames];
                }
                    
                    break;
                case SVPullToRefreshPositionBottom:
                {
                    yOrigin = self.contentSize.height;
                    self.pullToRefreshView.frame = CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight);
                }
                    break;
            }
            
            
        }
    }
}

- (BOOL)showsPullToRefresh {
    return !self.pullToRefreshView.hidden;
}

@end
/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*/
#pragma mark - SVPullToRefresh
@implementation SVPullToRefreshView

// public properties
@synthesize pullToRefreshActionHandler, textColor;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize showsPullToRefresh = _showsPullToRefresh;

@synthesize titleLabel = _titleLabel;


- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self setupViews];
        
        self.textColor = [UIColor darkGrayColor];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"DropdownRefresh", nil),
                             NSLocalizedString(@"flushRefresh", nil),
                             NSLocalizedString(@"lifeLoading", nil),
                                nil];
        
        self.state = SVPullToRefreshStateStopped;
        self.subtitles = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
        
        _stateCount = 3; // 上面几个数组的数量
        
        self.wasTriggeredByUser = YES;
        
    }
    
    return self;
}
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
///
- (void)setupViews
{
    // 总控添加
    UIView *tmpView = [[UIView alloc] initWithFrame:self.bounds];
    tmpView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tmpView.backgroundColor = [UIColor clearColor];
    [self addSubview:tmpView];
    
    float xishu = 3.0;
    CGFloat width = 125.0/xishu;
    CGFloat height = 57.0/xishu;
    
    self.yyView = [[RefreshControlView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [tmpView addSubview:self.yyView];
    [self.yyView addWidth:width];
    [self.yyView addHeight:height];
    [self.yyView addCenterX:0 toView:tmpView];
//    [self.yyView addCenterY:0 toView:tmpView];
    [self.yyView bottomToView:tmpView withSpace:10];
}


/// 当自己重写一个UIView的时候有可能用到这个方法,当本视图的父类视图改变的时候,系统会自动的执行这个方法.newSuperview是本视图的新父类视图.newSuperview有可能是nil.
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        //use self.superview, not self.scrollView. Why self.scrollView == nil here?
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsPullToRefresh) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "SVPullToRefreshView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)layoutSubviews {
    
    for(id otherView in self.viewForState) {
        if([otherView isKindOfClass:[UIView class]])
            [otherView removeFromSuperview];
    }
    /// 判断是否有自定义的view
    id customView = [self.viewForState objectAtIndex:self.state];
    BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
    
    self.titleLabel.hidden = hasCustomView;
    self.subtitleLabel.hidden = hasCustomView;
    
    if(hasCustomView) { /// 如果有自定view,就添加
        [self addSubview:customView];
        CGRect viewBounds = [(UIView*)customView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    }
    else { // 否则 判断各种状态
        switch (self.state) {
            case SVPullToRefreshStateAll:
            case SVPullToRefreshStateStopped:
                switch (self.position) {
                    case SVPullToRefreshPositionTop:
                        self.yyView.isLoading = NO;
                        [self changeImageviewAnimation:NO];
                        break;
                    case SVPullToRefreshPositionBottom:
                        [self changeImageviewAnimation:NO];
                        break;
                }
                break;
                
            case SVPullToRefreshStateTriggered:
                switch (self.position) {
                    case SVPullToRefreshPositionTop:
                        [self changeImageviewAnimation:YES];
                        break;
                    case SVPullToRefreshPositionBottom:
                        
                        break;
                }
                break;
                
            case SVPullToRefreshStateLoading:
                switch (self.position) {
                    case SVPullToRefreshPositionTop:
                        self.yyView.isLoading = YES;
                        [self changeImageviewAnimation:YES];
                        break;
                    case SVPullToRefreshPositionBottom:
                        
                        break;
                }
                break;
        }
        
        self.titleLabel.text = [self.titles objectAtIndex:self.state];
    }
    
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    BOOL isHidden;
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    switch (self.position) {
        case SVPullToRefreshPositionTop:
            currentInsets.top = self.originalTopInset;
            isHidden = YES;
            break;
        case SVPullToRefreshPositionBottom:
            currentInsets.bottom = self.originalBottomInset;
            currentInsets.top = self.originalTopInset;
            break;
    }
    
    
    
    UIEdgeInsets currentInsetn = UIEdgeInsetsMake(currentInsets.top, currentInsets.left, 0, currentInsets.right);
    
    //进入页面的加载的动画效果
    [self setScrollViewContentInset:currentInsetn isHidden:isHidden];
}

- (void)setScrollViewContentInsetForLoading {
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    switch (self.position) {
        case SVPullToRefreshPositionTop:
            currentInsets.top = MIN(offset, self.originalTopInset + fabs(self.frame.origin.y));
            break;
        case SVPullToRefreshPositionBottom:
            currentInsets.bottom = MIN(offset, self.originalBottomInset + self.bounds.size.height);
            break;
    }
    [self setScrollViewContentInset:currentInsets isHidden:NO];
}
/// isHidden == YES时，动画效果时间要慢一点
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset isHidden:(BOOL)isHidden {
    
    NSTimeInterval duration = 0.3;
    if (isHidden) {
        duration = 0.8;
    }

    /*  暂时关闭动画效果
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
     */
    
     self.scrollView.contentInset = contentInset;
}

#pragma mark - Observing
/// 监听变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        
        CGFloat yOrigin;
        switch (self.position) {
            case SVPullToRefreshPositionTop:
            {
                if (self.realY == 0) {
                    self.realY = -1*SVPullToRefreshViewHeight;
                }
                yOrigin = self.realY;
            }
                break;
            case SVPullToRefreshPositionBottom:
                yOrigin = MAX(self.scrollView.contentSize.height, self.scrollView.bounds.size.height);
                break;
        }
        self.frame = CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight);
    }
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];

}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != SVPullToRefreshStateLoading) { // 如果不是加载
        CGFloat scrollOffsetThreshold = 0;
        switch (self.position) {
            case SVPullToRefreshPositionTop:
                scrollOffsetThreshold = self.frame.origin.y - self.originalTopInset;
                break;
            case SVPullToRefreshPositionBottom:
                scrollOffsetThreshold = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.bounds.size.height + self.originalBottomInset;
                break;
        }
        self.yyView.triggerHeight = fabs(scrollOffsetThreshold);
        if (self.position == SVPullToRefreshPositionTop) {
            self.yyView.offsetY = contentOffset.y;
        }
        if(!self.scrollView.isDragging && self.state == SVPullToRefreshStateTriggered)
        {
            self.state = SVPullToRefreshStateLoading;
        }
        
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionTop)
            self.state = SVPullToRefreshStateTriggered;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionTop)
            self.state = SVPullToRefreshStateStopped;
        
        else if(contentOffset.y > scrollOffsetThreshold && self.scrollView.isDragging && self.state == SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionBottom)
            self.state = SVPullToRefreshStateTriggered;
        else if(contentOffset.y <= scrollOffsetThreshold && self.state != SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionBottom)
            self.state = SVPullToRefreshStateStopped;
    } else {
        CGFloat offset;
        UIEdgeInsets contentInset;
        switch (self.position) {
            case SVPullToRefreshPositionTop:
                offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
                offset = MIN(offset, self.originalTopInset + fabs(self.frame.origin.y)); // + self.bounds.size.height
                contentInset = self.scrollView.contentInset;
                self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
                break;
            case SVPullToRefreshPositionBottom:
                if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height) {
                    offset = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.bounds.size.height, 0.0f);
                    offset = MIN(offset, self.originalBottomInset + self.bounds.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, offset, contentInset.right);
                } else if (self.wasTriggeredByUser) {
                    offset = MIN(self.bounds.size.height, self.originalBottomInset + self.bounds.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(-offset, contentInset.left, contentInset.bottom, contentInset.right);
                }
                break;
        }
    }
    
}

#pragma mark - Getters
- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"DropdownRefresh", nil);
        _titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = textColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if(!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = textColor;
        [self addSubview:_subtitleLabel];
    }
    return _subtitleLabel;
}

- (UILabel *)dateLabel {
    return self.showsDateLabel ? self.subtitleLabel : nil;
}

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dateFormatter.locale = [NSLocale currentLocale];
    return dateFormatter;
}

- (UIColor *)textColor {
    return self.titleLabel.textColor;
}

#pragma mark - Setters
- (void)setTitle:(NSString *)title forState:(SVPullToRefreshState)state {
    if(!title)
        title = @"";
    
    if(state == SVPullToRefreshStateAll)
        [self.titles replaceObjectsInRange:NSMakeRange(0, _stateCount) withObjectsFromArray:@[title, title, title]];
    else
        [self.titles replaceObjectAtIndex:state withObject:title];
    
    [self setNeedsLayout];
}

- (void)setSubtitle:(NSString *)subtitle forState:(SVPullToRefreshState)state {
    if(!subtitle)
        subtitle = @"";
    
    if(state == SVPullToRefreshStateAll)
        [self.subtitles replaceObjectsInRange:NSMakeRange(0, _stateCount) withObjectsFromArray:@[subtitle, subtitle, subtitle]];
    else
        [self.subtitles replaceObjectAtIndex:state withObject:subtitle];
    
    [self setNeedsLayout];
}


- (void)setTextColor:(UIColor *)newTextColor {
    textColor = newTextColor;
    self.titleLabel.textColor = newTextColor;
	self.subtitleLabel.textColor = newTextColor;
}

#pragma mark -

- (void)triggerRefresh {
    [self.scrollView triggerPullToRefresh];
}

- (void)startAnimating{
    switch (self.position) {
        case SVPullToRefreshPositionTop:
            
            if(fequalzero(self.scrollView.contentOffset.y)) {
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height) animated:YES];
                self.wasTriggeredByUser = NO;
            }
            else
                self.wasTriggeredByUser = YES;
            break;
        case SVPullToRefreshPositionBottom:
            
            if((fequalzero(self.scrollView.contentOffset.y) && self.scrollView.contentSize.height < self.scrollView.bounds.size.height)
               || fequal(self.scrollView.contentOffset.y, self.scrollView.contentSize.height - self.scrollView.bounds.size.height)) {
                [self.scrollView setContentOffset:(CGPoint){.y = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.frame.size.height} animated:YES];
                self.wasTriggeredByUser = NO;
            }
            else
                self.wasTriggeredByUser = YES;
            
            break;
    }
    self.state = SVPullToRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = SVPullToRefreshStateStopped;
    
    switch (self.position) {
        case SVPullToRefreshPositionTop:
            if(!self.wasTriggeredByUser)
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset) animated:YES];
            break;
        case SVPullToRefreshPositionBottom:
            if(!self.wasTriggeredByUser)
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.originalBottomInset) animated:YES];
            break;
    }
}

- (void)setState:(SVPullToRefreshState)newState {
    
    if(_state == newState)
        return;
    SVPullToRefreshState previousState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    switch (newState) {
        case SVPullToRefreshStateAll:
        case SVPullToRefreshStateStopped:
            [self resetScrollViewContentInset];
            break;
            
        case SVPullToRefreshStateTriggered:
            break;
            
        case SVPullToRefreshStateLoading:
            [self setScrollViewContentInsetForLoading];
            
            if(previousState == SVPullToRefreshStateTriggered && pullToRefreshActionHandler)
                pullToRefreshActionHandler();
            
            break;
    }
}
- (void)changeImageviewAnimation:(BOOL)animation
{
    if (animation) {
        [self.iconImageView startAnimating];
    } else {
        [self.iconImageView stopAnimating];
    }
}


@end

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*/

