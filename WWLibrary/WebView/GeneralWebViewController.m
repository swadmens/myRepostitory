//
//  GeneralWebViewController.m
//  YanGang
//
//  Created by 汪伟 on 2018/11/8.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "GeneralWebViewController.h"
//#import "WXApiManager.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "RequestSence.h"
typedef enum : NSUInteger {
    OrderPlatformWeixin = 1,
    OrderPlatformAlipay = 2,
} OrderPlatformType;

@interface GeneralWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler,UIScrollViewDelegate,UINavigationControllerDelegate>
//WXApiManagerDelegate

@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic, assign) double estimatedProgress;
/// 是不是已经首次加载了
@property (nonatomic, assign, readwrite) BOOL isLoadAtFirst;

@property(nonatomic,strong) NSString *order_sn;
@property(nonatomic,assign) BOOL isScreen;
@property(nonatomic,strong) WKWebViewConfiguration* configuration;

@end

@implementation GeneralWebViewController

#pragma mark - 进度
- (UIProgressView *)progressView
{
    if (!_progressView) {
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.tintColor = kColorMainColor;
        progressView.trackTintColor = [UIColor whiteColor];
        _progressView = progressView;
    }
    return _progressView;
}
- (void)setEstimatedProgress:(double)estimatedProgress
{
    _estimatedProgress = estimatedProgress;
    // self.currentSubView.webView.estimatedProgress
    
    [self.progressView setAlpha:1.0f];
    [self.progressView setProgress:_estimatedProgress animated:YES];
    
    if(_estimatedProgress >= 1.0f) {
        
        [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
        
    }
}
- (void)setupWKWebView
{
    
    //    CGFloat systemVersion =[[WWPhoneInfo getSystemVersion] floatValue];
    CGFloat space=0;
    if (IS_IPHONEX && self.isDetailIndex) {
        space=50;
    }
    
    _configuration = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
    _configuration.userContentController = [NSClassFromString(@"WKUserContentController") new];
    
    
    WKPreferences* preferences = [NSClassFromString(@"WKPreferences") new];
    preferences.javaScriptCanOpenWindowsAutomatically = NO;
    preferences.javaScriptEnabled = YES;
    _configuration.preferences = preferences;
    
    // 将所有cookie以document.cookie = 'key=value';形式进行拼接
    NSString *cookieValue=[NSString stringWithFormat:@"document.cookie = 'system=ios';document.cookie = 'version=%@';document.cookie = 'api_auth_cookie=%@';",APPVersion, _kUserModel.userInfo.api_auth_cookie];
    // 加cookie给h5识别
    WKUserScript * cookieScript = [[WKUserScript alloc]initWithSource: cookieValue injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    
    [_configuration.userContentController addUserScript:cookieScript];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [_configuration.userContentController addScriptMessageHandler:self name:@"excuteJSMethod"];
    
    if ([self.url containsString:@"api_auth_cookie"]) {
        [_configuration.userContentController removeAllUserScripts];
        [_configuration.userContentController removeScriptMessageHandlerForName:@"excuteJSMethod"];
        [_configuration.userContentController addUserScript:cookieScript];
    }
    
    
    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds configuration:_configuration];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    //    webView.allowsBackForwardNavigationGestures = YES;
    webView.backgroundColor = kColorBackgroundColor;
    webView.opaque = NO;
    webView.scrollView.delegate = self;
    
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView = webView;
    self.webView.frame=CGRectMake(0, 0, self.view.bounds.size.width, kMainScreenSize.height-space);
    [self.view addSubview:self.webView];
    [self.view sendSubviewToBack:self.webView];
    
    // 进度条
    //    [self.view addSubview:self.progressView];
    [self.progressView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    
    self.title = NSLocalizedString(@"loading", nil);
}
- (void)action_back:(id)sender
{
    
    if (self.isScreen){
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    if (self.presentingViewController) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } else {
        /// 可能是推进来的
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setupLeftItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:UIImageWithFileName(@"icon_back_gray") style:UIBarButtonItemStylePlain target:self action:@selector(action_back:)];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    DLog(@"\n~~~~cookies=%@\n",cookieStorage.cookies);
    
    [self setupWKWebView];
    [self setupLeftItem];
    
    if ([self.url hasPrefix:@"QRCode"]) {
        self.url=[self.url substringFromIndex:6];
        self.isScreen=YES;
    }else{
        self.isScreen=NO;
    }
    
    
    NSString *strParam = [NSString stringWithFormat:@"system=%@&version=%@&session_id=%@&lang=%@",@"ios",APPVersion,_kUserModel.userInfo.session_id,_kUserModel.userInfo.language_lang];
    
    if ([self.url containsString:@"?"]) {
        self.url=[NSString stringWithFormat:@"%@&%@",self.url,strParam];
    }else{
        self.url=[NSString stringWithFormat:@"%@?%@",self.url,strParam];
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

- (void)setRightScrollInsets:(UIEdgeInsets)rightScrollInsets
{
    _rightScrollInsets = rightScrollInsets;
    self.webView.scrollView.scrollIndicatorInsets = _rightScrollInsets;
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"excuteJSMethod"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        id body = message.body;
        if ([body isKindOfClass:[NSString class]]) {
            body = [WWPublicMethod objectTransFromJson:body];
        }
        DLog(@"\n~~~~~下发的body=%@\n",body);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *pushType = [body objectForKey:@"type"];
            if ([pushType isEqual:@"pay"]) { // 支付
                int platform = [[NSString stringWithFormat:@"%@",[body objectForKey:@"platform"]] intValue];
                self.order_sn=[NSString stringWithFormat:@"%@",[body objectForKey:@"order_sn"]];
                //                [self payOrderToPlatform:platform :body];
                return;
            } else if ([pushType isEqual:@"close"]) { // 关闭
                
                [self action_back:nil];
                
            } else if ([pushType isEqual:@"hideTopSearchBar"]) { // 用于类似首页的顶部隐藏
                BOOL topHidden = [[NSString stringWithFormat:@"%@",[body objectForKey:@"hidden"]] boolValue];
                [self hideTopSearchBar:topHidden];
                
            } else if ([pushType isEqual:@"justPushTarget"]) {
                /*
                 也是跳转规则，但是这里面不加任何判断，直接丢过去处理
                 目前只有一种情况使用，订单支付页面，跳转“线下支付”
                 */
                
                NSMutableDictionary *resetBody = [NSMutableDictionary dictionaryWithDictionary:body];
                [resetBody setObject:@"push" forKey:@"type"];
                
                [TargetEngine pushViewController:nil fromController:nil withTarget:resetBody];
                
            }else { // 跳转规则
                
                NSString *viewType = [body objectForKey:@"view"];
                if ([viewType isEqual:@"web"]) {
                    NSMutableDictionary *resetBody = [NSMutableDictionary dictionaryWithDictionary:body];
                    NSString *pushId =[NSString stringWithFormat:@"%@?api_auth_cookie=%@",[body objectForKey:@"pushId"],_kUserModel.userInfo.api_auth_cookie];
                    [resetBody setObject:pushId forKey:@"pushId"];
                    NSString *newPushId=[WWPublicMethod jsonTransFromObject:resetBody];
                    [TargetEngine pushViewController:nil fromController:nil withTarget:newPushId];
                    return ;
                }else{
                    if (self.dismissWhenPushTarget) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [TargetEngine pushViewController:nil fromController:nil withTarget:body];
                        }];
                    } else {
                        [TargetEngine pushViewController:nil fromController:nil withTarget:body];
                    }
                }
            }
        });
    }
}
/// 隐藏类似顶部searchbar
- (void)hideTopSearchBar:(BOOL)hidden
{
    
}
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            self.estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    else if ([keyPath isEqualToString:@"title"]) {
        self.title = change[NSKeyValueChangeNewKey];
    }
    else {
        [self willChangeValueForKey:keyPath];
        [self didChangeValueForKey:keyPath];
    }
}

- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name
{
    WKWebViewConfiguration* configuration = [self.webView configuration];
    [configuration.userContentController addScriptMessageHandler:scriptMessageHandler name:name];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL isLoadingDisableScheme = [self isLoadingWKWebViewDisableScheme:navigationAction.request.URL];
    
    if (!isLoadingDisableScheme) {
        
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

/// 页面开始加载时调用 类似 webViewDidStartLoad
- (void)webView:(WKWebView*)webView didStartProvisionalNavigation:(WKNavigation*)navigation
{
    
}
/// 完成加载 类似 webViewDidFinishLoad
- (void)webView:(WKWebView*)webView didFinishNavigation:(WKNavigation*)navigation
{
    self.isLoadAtFirst = YES;
}
/// 加载失败 类似 webViewDidFailLoadWithError
- (void)webView:(WKWebView*)webView didFailProvisionalNavigation:(WKNavigation*)navigation withError:(NSError*)error
{
    
}
///
- (void)webView:(WKWebView*)webView didFailNavigation:(WKNavigation*)navigation withError:(NSError*)error
{
    
}
#pragma mark - 基础方法
///判断当前加载的url是否是WKWebView不能打开的协议类型
- (BOOL)isLoadingWKWebViewDisableScheme:(NSURL*)url
{
    BOOL retValue = NO;
    
    //判断是否正在加载WKWebview不能识别的协议类型：phone numbers, email address, maps, etc.
    if ([url.scheme isEqualToString:@"tel"]) {
        UIApplication* app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            [app openURL:url];
            retValue = YES;
        }
    }
    
    return retValue;
}

- (id)reloadFromOrigin
{
    return [self.webView reloadFromOrigin];
}

- (void)evaluateJavaScript:(NSString*)javaScriptString completionHandler:(void (^)(id, NSError*))completionHandler
{
    return [(WKWebView*)self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}
- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)javaScriptString
{
    __block NSString* result = nil;
    __block BOOL isExecuted = NO;
    [self.webView evaluateJavaScript:javaScriptString completionHandler:^(id obj, NSError* error) {
        result = obj;
        isExecuted = YES;
    }];
    
    while (isExecuted == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return result;
}
- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    WKWebView* webView = self.webView;
    
    NSString* jScript = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);";
    
    WKUserContentController *userContentController = webView.configuration.userContentController;
    NSMutableArray<WKUserScript *> *array = [userContentController.userScripts mutableCopy];
    WKUserScript* fitWKUScript = nil;
    for (WKUserScript* wkUScript in array) {
        if ([wkUScript.source isEqual:jScript]) {
            fitWKUScript = wkUScript;
            break;
        }
    }
    if (scalesPageToFit) {
        if (!fitWKUScript) {
            fitWKUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [userContentController addUserScript:fitWKUScript];
        }
    }
    else {
        if (fitWKUScript) {
            [array removeObject:fitWKUScript];
        }
        ///没法修改数组 只能移除全部 再重新添加
        [userContentController removeAllUserScripts];
        for (WKUserScript* wkUScript in array) {
            [userContentController addUserScript:wkUScript];
        }
    }
}

- (NSInteger)countOfHistory
{
    WKWebView* webView = self.webView;
    return webView.backForwardList.backList.count;
}
- (void)gobackWithStep:(NSInteger)step
{
    if (self.webView.canGoBack == NO)
        return;
    
    if (step > 0) {
        WKWebView* webView = self.webView;
        WKBackForwardListItem* backItem = webView.backForwardList.backList[step];
        [webView goToBackForwardListItem:backItem];
    }
    else {
        
    }
}
#pragma mark -  如果没有找到方法 去realWebView 中调用
/*
 - (BOOL)respondsToSelector:(SEL)aSelector
 {
 BOOL hasResponds = [super respondsToSelector:aSelector];
 
 if (hasResponds == NO) {
 hasResponds = [self respondsToSelector:aSelector];
 }
 return hasResponds;
 }
 - (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
 {
 NSMethodSignature* methodSign = [super methodSignatureForSelector:selector];
 if (methodSign == nil) {
 if ([self.realWebView respondsToSelector:selector]) {
 methodSign = [self.realWebView methodSignatureForSelector:selector];
 }
 else {
 methodSign = [(id)self.delegate methodSignatureForSelector:selector];
 }
 }
 return methodSign;
 }
 - (void)forwardInvocation:(NSInvocation*)invocation
 {
 if ([self.realWebView respondsToSelector:invocation.selector]) {
 [invocation invokeWithTarget:self.realWebView];
 }
 else {
 [invocation invokeWithTarget:self.delegate];
 }
 }
 */
#pragma mark - 清理
- (void)dealloc
{
    WKWebView* webView = self.webView;
    webView.UIDelegate = nil;
    webView.navigationDelegate = nil;
    
    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [webView removeObserver:self forKeyPath:@"title"];
    
    [webView removeObserver:self forKeyPath:@"loading"];
    [webView scrollView].delegate = nil;
    [webView stopLoading];
    [webView removeFromSuperview];
    webView = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    /// 网上搜索到的所有清webview缓存的方法都没有用
    
}
- (BOOL)canWebViewPageUsePanToBack
{
    return self.webView.canGoBack;
}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    _webView = nil;
//    [self cleanCacheAndCookie];
//}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
