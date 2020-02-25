//
//  GeneralWebViewController.h
//  YanGang
//
//  Created by 汪伟 on 2018/11/8.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>
NS_ASSUME_NONNULL_BEGIN

@interface GeneralWebViewController : WWViewController
/// 使用跳转规则前，先dismissViewController
@property (nonatomic, assign) BOOL dismissWhenPushTarget;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *url;
@property(nonatomic,assign) BOOL isDetailIndex;
- (BOOL)canWebViewPageUsePanToBack;
/// 是不是已经首次加载了
@property (nonatomic, assign, readonly) BOOL isLoadAtFirst;
/// 右边拖动条的指示位置
@property (nonatomic, assign) UIEdgeInsets rightScrollInsets;
/// scrollView滚动了
- (void)webScrollViewDidScroll:(UIScrollView *)scrollView;
/// 隐藏类似顶部searchbar
- (void)hideTopSearchBar:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
