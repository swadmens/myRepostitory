//
//  WWTableView.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWTableView.h"
#import "SVPullToRefresh.h"

@interface WWTableView ()

@property (nonatomic, readwrite) WWScrollingState state;

@end

@implementation WWTableView
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self doSetup];
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self doSetup];
    }
    return self;
}
/**
 * 增加下拉刷新下面的，自定view
 * @param cview 必须提前设定好高度,cview = nil时移除相应位置的view
 * @param position 0:上，1:下。添加到下拉刷新view的顶还是底
 */
- (void)addOneCustomView:(UIView *)cview atPosition:(NSInteger)position
{
    [self addCustomView:cview atPosition:position];
}
- (void)doSetup
{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.backgroundColor = kColorBackgroundColor;
    
    self.hideLoadingMoreWhenRefreshing = YES;
    self.stopLoadingMoreWhenRefresh = YES;
    
    __weak typeof(self) weak_self = self;
    [self addPullToRefreshWithActionHandler:^{
        [weak_self loadNewData];
    }];
    // 增加上拉更多
    [self addInfiniteScrollingWithActionHandler:^{
        [weak_self loadMoreData];
    }];
    self.showsInfiniteScrolling = NO;
    self.showsPullToRefresh = NO;
    
}
- (void)setRefreshEnable:(BOOL)refreshEnable
{
    _refreshEnable = refreshEnable;
    self.showsPullToRefresh = _refreshEnable;
}
- (void)setLoadingMoreEnable:(BOOL)loadingMoreEnable
{
    _loadingMoreEnable = loadingMoreEnable;
    [[GCDQueue mainQueue] queueBlock:^{
        self.showsInfiniteScrolling = self.loadingMoreEnable;
        self.openPriorLoading = YES; // 开启预加载
    }];
    
}
/// 手动触发刷新
- (void)startRefresh
{
    if (self.refreshEnable) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self triggerPullToRefresh];
        });
    }
}
/// 手动触发更多
- (void)startLoadMore
{
    if (self.loadingMoreEnable) {
        [self triggerInfiniteScrolling];
    }
}
/// 停止加载
- (void)stopLoading
{
    // 如果是停止状态，就不用管了
    if (self.state == WWScrollingStateStopped) {
        return;
    }
    WWScrollingState oldState = self.state;
    /// 先返回状态
    self.state = WWScrollingStateStopped;
    if (self.actionHandle) {
        self.actionHandle(self.state);
    }
    
    if (oldState == WWScrollingStateRefreshing) { // 刷新
        [self.pullToRefreshView stopAnimating];
        if (self.hideLoadingMoreWhenRefreshing && self.loadingMoreEnable) {
            self.showsInfiniteScrolling = YES;
        }
        
    }else if (oldState == WWScrollingStateLoadingMore) { //
        
        [self.infiniteScrollingView stopAnimating];
        
    }
    
}
- (WWScrollingState)scrollState
{
    return self.state;
}
/// 加载新数据
- (void)loadNewData
{
    /// 如果有加载更多，将先停止加载更多
    if (self.stopLoadingMoreWhenRefresh && self.loadingMoreEnable) {
        [self.infiniteScrollingView stopAnimating];
    }
    if (self.hideLoadingMoreWhenRefreshing) {
        self.showsInfiniteScrolling = NO;
    }
    self.state = WWScrollingStateRefreshing;
    if (self.actionHandle) {
        self.actionHandle(self.state);
    }
}
/// 加载更多数据
- (void)loadMoreData
{
    self.state = WWScrollingStateLoadingMore;
    if (self.actionHandle) {
        self.actionHandle(self.state);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
