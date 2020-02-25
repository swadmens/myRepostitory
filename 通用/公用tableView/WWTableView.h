//
//  WWTableView.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import "WWTableViewCell.h"

enum {
    WWScrollingStateStopped = 0,
    WWScrollingStateRefreshing, // 刷新中
    WWScrollingStateLoadingMore, // 加载更多中
};
typedef NSUInteger WWScrollingState;
/**
 * 逻辑
 * 1. 下拉刷新时，将会停止加载更多
 */

@interface WWTableView : UITableView
- (void)doSetup;

/// 现在的状态
@property (nonatomic, readonly) WWScrollingState state;
/// 是否启用下拉刷新
@property (nonatomic) BOOL refreshEnable;
/// 是否启用上拉更多
@property (nonatomic) BOOL loadingMoreEnable;
/// 当刷新时，自动隐藏加载更多。默认为YES
@property (nonatomic) BOOL hideLoadingMoreWhenRefreshing;
/// 当下拉刷新时，停止加载更多。默认为YES
@property (nonatomic) BOOL stopLoadingMoreWhenRefresh;
/// 手动触发刷新
- (void)startRefresh;
/// 手动触发更多
- (void)startLoadMore;
/**
 * 增加下拉刷新下面的，自定view
 * @param cview 必须提前设定好高度,cview = nil时移除相应位置的view
 * @param position 0:上，1:下。添加到下拉刷新view的顶还是底
 */
- (void)addOneCustomView:(UIView *)cview atPosition:(NSInteger)position;
/// 停止加载,不管是加载更多还是刷新都调用这个方法
- (void)stopLoading;
/// 不管是加载还是停止都触发这个事件，根据state来判断
@property (nonatomic, copy) void(^actionHandle)(WWScrollingState state);
/// 读取状态
@property (nonatomic, readonly) WWScrollingState scrollState;

@end
