//
//  WWCollectionView.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWCollectionView.h"
#import "SVPullToRefresh.h"

@interface WWCollectionView ()

@property (nonatomic, readwrite) WWCollectionViewState state;

@end

@implementation WWCollectionView
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self doSetup];
}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self doSetup];
    }
    return self;
}
- (void)doSetup
{
    self.backgroundColor = kColorBackgroundColor;
    
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
/**
 * 增加下拉刷新下面的，自定view
 * @param cview 必须提前设定好高度,cview = nil时移除相应位置的view
 * @param position 0:上，1:下。添加到下拉刷新view的顶还是底
 */
- (void)addOneCustomView:(UIView *)cview atPosition:(NSInteger)position
{
    [self addCustomView:cview atPosition:position];
}
- (void)setRefreshEnable:(BOOL)refreshEnable
{
    _refreshEnable = refreshEnable;
    self.showsPullToRefresh = _refreshEnable;
}
- (void)setLoadingMoreEnable:(BOOL)loadingMoreEnable
{
    _loadingMoreEnable = loadingMoreEnable;
    self.showsInfiniteScrolling = _loadingMoreEnable;
    self.openPriorLoading = YES; // 开启预加载
}
/// 手动触发刷新
- (void)startRefresh
{
    if (self.refreshEnable) {
        [self triggerPullToRefresh];
    }
}
/// 停止加载
- (void)stopLoading
{
    // 如果是停止状态，就不用管了
    if (self.state == WWCollectionViewStateStopped) {
        return;
    }
    WWCollectionViewState oldState = self.state;
    /// 先返回状态
    self.state = WWCollectionViewStateStopped;
    if (self.actionHandle) {
        self.actionHandle(self.state);
    }
    
    if (oldState == WWCollectionViewStateRefreshing) { // 刷新
        [self.pullToRefreshView stopAnimating];
        if (self.hideLoadingMoreWhenRefreshing && self.loadingMoreEnable) {
            self.showsInfiniteScrolling = YES;
        }
        
    }else if (oldState == WWCollectionViewStateLoadingMore) { //
        
        [self.infiniteScrollingView stopAnimating];
        
    }
    
}
- (WWCollectionViewState)scrollState
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
    self.state = WWCollectionViewStateRefreshing;
    if (self.actionHandle) {
        self.actionHandle(self.state);
    }
}
/// 加载更数据
- (void)loadMoreData
{
    self.state = WWCollectionViewStateLoadingMore;
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
