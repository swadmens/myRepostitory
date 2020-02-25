//
// UIScrollView+SVInfiniteScrolling.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVInfiniteScrolling.h"


static CGFloat const SVInfiniteScrollingViewHeight = 60;
/// 偏移多少才能加载
static CGFloat const SVInfiniteScrollingOffHeight = 12.0;

@interface SVInfiniteScrollingDotView : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end



@interface SVInfiniteScrollingView ()

@property (nonatomic, copy) void (^infiniteScrollingHandler)(void);

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIButton *buttonView; //底部按钮
@property (nonatomic, readwrite) SVInfiniteScrollingState state;
@property (nonatomic, strong) NSMutableArray *viewForState;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForInfiniteScrolling;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

@end



#pragma mark - UIScrollView (SVInfiniteScrollingView)
#import <objc/runtime.h>

static char UIScrollViewInfiniteScrollingView;
UIEdgeInsets scrollViewOriginalContentInsets;

@implementation UIScrollView (SVInfiniteScrolling)

@dynamic infiniteScrollingView;
@dynamic openPriorLoading;

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {
    
    if(!self.infiniteScrollingView) {
        SVInfiniteScrollingView *view = [[SVInfiniteScrollingView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, SVInfiniteScrollingViewHeight)];
        view.infiniteScrollingHandler = actionHandler;
        view.scrollView = self;

        [self addSubview:view];
        
        view.originalBottomInset = self.contentInset.bottom;
        self.infiniteScrollingView = view;
        self.showsInfiniteScrolling = YES;
    }
}
- (void)setOpenPriorLoading:(BOOL)openPriorLoading
{
    self.infiniteScrollingView.openPriorLoading = openPriorLoading;
}
- (void)triggerInfiniteScrolling {
    self.infiniteScrollingView.state = SVInfiniteScrollingStateTriggered;
    [self.infiniteScrollingView startAnimating];
}

- (void)setInfiniteScrollingView:(SVInfiniteScrollingView *)infiniteScrollingView {
    [self willChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
    objc_setAssociatedObject(self, &UIScrollViewInfiniteScrollingView,
                             infiniteScrollingView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
}

- (SVInfiniteScrollingView *)infiniteScrollingView {
    return objc_getAssociatedObject(self, &UIScrollViewInfiniteScrollingView);
}

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling {
    
    self.infiniteScrollingView.hidden = !showsInfiniteScrolling;
    if(!showsInfiniteScrolling) {
        if (self.infiniteScrollingView.isObserving) {
            [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentOffset"];
            [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentSize"];
            [self.infiniteScrollingView resetScrollViewContentInset];
            self.infiniteScrollingView.isObserving = NO;
        }
    }
    else {
        if (!self.infiniteScrollingView.isObserving) {
            [self addObserver:self.infiniteScrollingView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.infiniteScrollingView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self.infiniteScrollingView setScrollViewContentInsetForInfiniteScrolling];
            self.infiniteScrollingView.isObserving = YES;
            
            [self.infiniteScrollingView setNeedsLayout];
            self.infiniteScrollingView.frame = CGRectMake(0, self.contentSize.height, self.infiniteScrollingView.bounds.size.width, SVInfiniteScrollingViewHeight);
        }
    }
}

- (BOOL)showsInfiniteScrolling {
    return !self.infiniteScrollingView.hidden;
}

@end


#pragma mark - SVInfiniteScrollingView
@implementation SVInfiniteScrollingView

// public properties
@synthesize infiniteScrollingHandler, activityIndicatorViewStyle;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize activityIndicatorView = _activityIndicatorView;


- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        // default styling values
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = SVInfiniteScrollingStateStopped;
        self.enabled = YES;
        
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsInfiniteScrolling) {
          if (self.isObserving) {
            [scrollView removeObserver:self forKeyPath:@"contentOffset"];
            [scrollView removeObserver:self forKeyPath:@"contentSize"];
            self.isObserving = NO;
          }
        }
    }
}

- (void)layoutSubviews {
    self.activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalBottomInset;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForInfiniteScrolling {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalBottomInset + SVInfiniteScrollingViewHeight;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {    
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.bounds.size.width, SVInfiniteScrollingViewHeight);
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    // 如果是向下拉。就返回
    if (contentOffset.y <=0) {
        return;
    }
    if(self.state != SVInfiniteScrollingStateLoading && self.enabled) {
        
        if (self.openPriorLoading) { // 如果开启了预加载
            CGFloat scrollViewContentHeight = self.scrollView.contentSize.height; // 滚动区域的高
            if (scrollViewContentHeight > self.scrollView.bounds.size.height) { // 得有滚动才算
                
                /// 没有拖动，并且准备触发，那就可以加载更多了 // !self.scrollView.isDragging &&
                if(self.state == SVInfiniteScrollingStateTriggered) {
                    self.state = SVInfiniteScrollingStateLoading;
                }
                else {
                    CGFloat leftOffset = scrollViewContentHeight - contentOffset.y; // 还剩余多少的高
                    CGFloat bili = leftOffset / self.scrollView.bounds.size.height;
                    if (bili <= 1.4) { // 触发
                        self.state = SVInfiniteScrollingStateTriggered;
                        
                    } else {
                        self.state = SVInfiniteScrollingStateStopped;
                    }
                }
                
                return;
            }
        }
        
         
        CGFloat scrollViewContentHeight = self.scrollView.contentSize.height;
        CGFloat scrollOffsetThreshold = scrollViewContentHeight - self.scrollView.bounds.size.height;
        if(!self.scrollView.isDragging && self.state == SVInfiniteScrollingStateTriggered)  {
            self.state = SVInfiniteScrollingStateLoading;
        }
        else if(contentOffset.y > (scrollOffsetThreshold + SVInfiniteScrollingOffHeight + SVInfiniteScrollingViewHeight) && self.state == SVInfiniteScrollingStateStopped && self.scrollView.isDragging){
            
            self.state = SVInfiniteScrollingStateTriggered;
            
        }
        else if(contentOffset.y < scrollOffsetThreshold  && self.state != SVInfiniteScrollingStateStopped){
            self.state = SVInfiniteScrollingStateStopped;
        }
        
    }
}
#pragma mark - Getters
- (UIActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

- (UIButton *)buttonView
{
    if (!_buttonView) {
        _buttonView = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonView.frame = self.bounds;
        _buttonView.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _buttonView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _buttonView.backgroundColor = [UIColor clearColor];
        [self updateButtonTitleColor];
        [_buttonView setTitle:NSLocalizedString(@"LoadMore", nil) forState:UIControlStateNormal];
        [_buttonView addTarget:self action:@selector(action_clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)updateButtonTitleColor
{
    UIColor *color = self.activityIndicatorView.color;
    [self.buttonView setTitleColor:color forState:UIControlStateNormal];
    [self.buttonView setTitleColor:[color colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
}
/// 按下加载
- (void)action_clicked:(id)sender
{
    [self triggerRefresh];
}
#pragma mark - Setters

- (void)setCustomView:(UIView *)view forState:(SVInfiniteScrollingState)state {
    id viewPlaceholder = view;
    
    if(!viewPlaceholder)
        viewPlaceholder = @"";
    
    if(state == SVInfiniteScrollingStateAll)
        [self.viewForState replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[viewPlaceholder, viewPlaceholder, viewPlaceholder]];
    else
        [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];
    
    self.state = self.state;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
    [self updateButtonTitleColor];
}

#pragma mark -

- (void)triggerRefresh {
    self.state = SVInfiniteScrollingStateTriggered;
    self.state = SVInfiniteScrollingStateLoading;
}

- (void)startAnimating{
    self.state = SVInfiniteScrollingStateLoading;
}

- (void)stopAnimating {
    self.state = SVInfiniteScrollingStateStopped;
}
//// 设置状态
- (void)setState:(SVInfiniteScrollingState)newState {
    
    if(_state == newState)
        return;
    
    SVInfiniteScrollingState previousState = _state;
    _state = newState;
    
    for(id otherView in self.viewForState) {
        if([otherView isKindOfClass:[UIView class]])
            [otherView removeFromSuperview];
    }
    
    id customView = [self.viewForState objectAtIndex:newState];
    BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
    
    if(hasCustomView) {
        [self addSubview:customView];
//        CGRect viewBounds = [customView bounds];
        CGRect viewBounds = [(UIView*)customView bounds];

        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    }
    else {
        CGRect viewBounds = [self.activityIndicatorView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [self.activityIndicatorView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
        
        switch (newState) {
            case SVInfiniteScrollingStateStopped:
            {
                [self.activityIndicatorView stopAnimating];
                self.buttonView.hidden = NO;
            }
                
                break;
                
            case SVInfiniteScrollingStateTriggered:
            {
                [self.activityIndicatorView startAnimating];
                self.buttonView.hidden = YES;
            }
                break;
                
            case SVInfiniteScrollingStateLoading:
            {
                [self.activityIndicatorView startAnimating];
                self.buttonView.hidden = YES;
            }
                break;
        }
    }
    
    if(previousState == SVInfiniteScrollingStateTriggered && newState == SVInfiniteScrollingStateLoading && self.infiniteScrollingHandler && self.enabled)
        self.infiniteScrollingHandler();
}

@end
