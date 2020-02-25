//
// UIScrollView+SVPullToRefresh.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>


@class SVPullToRefreshView;
/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*/
@interface UIScrollView (SVPullToRefresh)

typedef NS_ENUM(NSUInteger, SVPullToRefreshPosition) {
    SVPullToRefreshPositionTop = 0,
    SVPullToRefreshPositionBottom,
};

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(SVPullToRefreshPosition)position;
- (void)triggerPullToRefresh;

@property (nonatomic, strong, readonly) SVPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;


/**
 * 增加下拉刷新下面的，自定view
 * @param cview 必须提前设定好高度,cview = nil时移除相应位置的view
 * @param position 0:上，1:下。添加到下拉刷新view的顶还是底
 */
- (void)addCustomView:(UIView *)cview atPosition:(NSInteger)position;



@end


typedef NS_ENUM(NSUInteger, SVPullToRefreshState) {
    SVPullToRefreshStateStopped = 0,
    SVPullToRefreshStateTriggered,
    SVPullToRefreshStateLoading,
    SVPullToRefreshStateAll = 10
};

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*/

@interface SVPullToRefreshView : UIView

/// 文本颜色
@property (nonatomic, strong) UIColor *textColor;
/// 左边图片
@property (nonatomic, strong, readonly) UIImageView *iconImageView;
/// 主标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/// 副标题
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
/// 刷新状态
@property (nonatomic, readonly) SVPullToRefreshState state;
/// 刷新位置
@property (nonatomic, readonly) SVPullToRefreshPosition position;

- (void)setTitle:(NSString *)title forState:(SVPullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(SVPullToRefreshState)state;

/// 开始动画
- (void)startAnimating;
/// 停止动画
- (void)stopAnimating;



@end
