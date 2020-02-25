//
//  SharedClient.m
//  AFTest
//
//  Created by icash on 15-7-22.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import "SharedClient.h"
#import "RequestSence.h"
#import "AFURLRequestSerialization.h"
#define _DEVURLKey @"taochong.dev.serverURL"



@interface SharedClient ()

@property (nonatomic, readwrite) AFNetworkReachabilityStatus networkStatus;
@property (nonatomic, strong) NSMutableArray *allNetBlocks;
@property (nonatomic, readwrite) NSMutableDictionary *returnDic;

@end

@implementation SharedClient
@synthesize serverURL = _serverURL;

-(NSMutableDictionary *)returnDic{
    if (!_returnDic) {
        _returnDic = [[NSMutableDictionary alloc] init];
    }
    return _returnDic;
}
+ (NSString *)domainURL
{
    NSString *url = nil;
#ifdef DEBUG
    url = [[NSUserDefaults standardUserDefaults] objectForKey:_DEVURLKey];
    if (url == nil) {
        url = @"http://tyuapi.fundog.cn/"; // 开发用的
    }
#else
    url = @"https://api.vipet.com.cn/"; // 正式服务器
#endif
    return url;
}
+ (NSString *)requestURL
{
    NSString *url = [self domainURL];
//    NSString *middle = @"v2/"; // v1.0.0/
//    url = [NSString stringWithFormat:@"%@/%@",url,middle];
    return url;
}
/// 初始化单例
+ (SharedClient *)sharedInstance
{
    static SharedClient *_client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString:[SharedClient requestURL]];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"TuneStore iOS 1.0"}];
        /*
        //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        [config setURLCache:cache];
        */
        _client = [[SharedClient alloc] initWithBaseURL:baseURL
                                         sessionConfiguration:config];
        _client.responseSerializer = [AFJSONResponseSerializer serializer];
        
        _client.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi; // 用_client.reachabilityManager.networkReachabilityStatus;读出来不正确。
        /// 注册网络变化
        [_client.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            _client.networkStatus = status;
            [_client.allNetBlocks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NetworkChangedHandle nblock = obj;
                nblock(status);
            }];
        }];
        [_client.reachabilityManager startMonitoring];
        
    });
    return _client;
}
- (NSMutableArray *)allNetBlocks
{
    if (!_allNetBlocks) {
        _allNetBlocks = [NSMutableArray array];
    }
    return _allNetBlocks;
}
- (void)setNetworkStatusDidChanged:(void (^)(AFNetworkReachabilityStatus))networkStatusDidChanged
{
    _networkStatusDidChanged = networkStatusDidChanged;
    if (_networkStatusDidChanged) {
        [self.allNetBlocks addObject:_networkStatusDidChanged];
    }
}
/// 根据参数重建URL
- (NSString *)rebuildURL:(NSString *)url byParams:(NSDictionary *)dict
{
    if ([url isKindOfClass:[NSString class]] == NO || url.length <=0) {
        return nil;
    }
    if ([dict isKindOfClass:[NSDictionary class]] == NO || dict.count <=0) {
        return url;
    }
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (id key in dict) {
        NSString *value = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
        NSString *exKey = [NSString stringWithFormat:@"%@",key];
        NSString *str = [NSString stringWithFormat:@"%@=%@",[exKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [mutablePairs addObject:str];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *query = [mutablePairs componentsJoinedByString:@"&"];
    
    NSString *finalURL = [[request.URL absoluteString] stringByAppendingFormat:request.URL.query ? @"&%@" : @"?%@", query];
    DLog(@"\n~~~~~拼装好的url=%@\n",finalURL);
    return finalURL;
}
/// 获取公共参
- (NSDictionary *)getPublicParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"ios" forKey:@"system"];
//    NSString *versionstr = [WWPhoneInfo getAPPVersion];
    [params setObject:APPVersion forKey:@"version"];
//    if ([_kUserModel.userInfo.session_id isKindOfClass:[NSString class]]) {
//        [params setObject:_kUserModel.userInfo.session_id forKey:@"session_id"];
//    }
    
//    if (![_kUserModel.userInfo.language_lang isEqualToString:@"0"]) {
//        [params setObject:_kUserModel.userInfo.language_lang forKey:@"lang"];
//    }else{
//
//        NSString *udfLanguageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
//        if ([udfLanguageCode isEqualToString:@"en-CN"]) {
//            [params setObject:@"english" forKey:@"lang"];
//        }else if ([udfLanguageCode isEqualToString:@"zh-Hans-CN"]){
//            [params setObject:@"zh_cn" forKey:@"lang"];
//        }else{
//            [params setObject:@"spanish" forKey:@"lang"];
//        }
//    }
 
    return params;
}
/// 添加一些公共参数
- (NSMutableDictionary *)paramsToPublicWith:(NSDictionary *)params
{
    if (params == nil) {
        params = @{};
    }
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionaryWithDictionary:params];
#ifdef DEBUG
    //[finalParams setObject:@"epetdemo2012" forKey:@"testloginpass"];
#else
    
#endif
    [finalParams addEntriesFromDictionary:[self getPublicParams]];

    return finalParams;
}

/// 更新用户地址
- (void)shouldUploadUserLocation
{
//    [_kMapManager uploadUserCurrentLocation];
}

/// get请求
- (NSURLSessionDataTask *)requestGet:(NSString *)url parameters:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion
{
    if (self.networkStatus == AFNetworkReachabilityStatusNotReachable || self.networkStatus == AFNetworkReachabilityStatusUnknown) {
        if (completion) {

            NSError *err = [NSError errorWithDomain:self.baseURL.absoluteString code:-1001 userInfo:nil];
            completion(nil, err);
        }
        return nil;
    }
    
    [self shouldUploadUserLocation];
    
    if (params == nil) {
        params = @{};
    }
    
    NSMutableDictionary *finalParams=[NSMutableDictionary dictionary];
    if ([url rangeOfString:@"downLoad/version"].location != NSNotFound) {
        [finalParams setObject:@"ios" forKey:@"system"];
        NSString *versionstr = [WWPhoneInfo getAPPVersion];
        [finalParams setObject:versionstr forKey:@"version"];
        [finalParams setObject:versionstr forKey:@"branch"];
    }else{
        finalParams = [self paramsToPublicWith:params];
    }
    DLog(@"\n请求参数 = %@ \n",finalParams);
    NSURLSessionDataTask *task = [self GET:url parameters:finalParams success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        DLog(@"\n~~~~~完成请求地址:%@\n",httpResponse.URL.absoluteString);
        if (httpResponse.statusCode == 200) {
            completion(responseObject, nil);
        } else {
            NSError *err = [NSError errorWithDomain:self.baseURL.absoluteString code:httpResponse.statusCode userInfo:nil];
            completion(nil, err);
        }
        
        if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            [self.returnDic setValue:responseObject forKey:@"moid"];
        }
        
        DLog(@"Received: %@", responseObject);
        DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 请求失败
        completion(nil, error);
    }];
    return task;
}
/// POST 请求
- (NSURLSessionDataTask *)requestPost:(NSString *)url parameters:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion
{
    if (self.networkStatus == AFNetworkReachabilityStatusNotReachable || self.networkStatus == AFNetworkReachabilityStatusUnknown) {
        if (completion) {
            
            NSError *err = [NSError errorWithDomain:self.baseURL.absoluteString code:-1001 userInfo:nil];
            completion(nil, err);
        }
        return nil;
    }
    
    [self shouldUploadUserLocation];
    
    if (params == nil) {
        params = @{};
    }
    NSMutableDictionary *finalParams=[NSMutableDictionary dictionary];
    if ([url rangeOfString:@"downLoad/version"].location != NSNotFound) {
        [finalParams setObject:@"ios" forKey:@"system"];
        NSString *versionstr = [WWPhoneInfo getAPPVersion];
        [finalParams setObject:versionstr forKey:@"version"];
        [finalParams setObject:versionstr forKey:@"branch"];
    }else{
        finalParams = [self paramsToPublicWith:params];
    }

    DLog(@"\n请求参数 = %@ \n",finalParams);
    NSURLSessionDataTask *task = [self POST:url parameters:finalParams success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            completion(responseObject, nil);
        } else {
            NSError *err = [NSError errorWithDomain:self.baseURL.absoluteString code:httpResponse.statusCode userInfo:nil];
            completion(nil, err);
        }
        DLog(@"Received: %@", responseObject);
        DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 请求失败
        completion(nil, error);
    }];
    return task;
}
///
- (NSURLSessionUploadTask *)uploadFiles:(NSArray *)files with:(NSDictionary *)params to:(NSString *)url completion:( void (^)(id results, NSError *error) )completion
{
    __block NSError *error = nil;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    url = [NSString stringWithFormat:@"%@%@",self.baseURL.absoluteString,url];
    NSMutableDictionary *finalParams = [self paramsToPublicWith:params];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:finalParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i =0; i<files.count; i++) {
            NSDictionary *dic = [files objectAtIndex:i];
            NSString *name = [dic objectForKey:@"name"];
            NSString *fileName = [dic objectForKey:@"fileName"];
            NSString *mimeType = [dic objectForKey:@"mimeType"];
            NSData *data = [dic objectForKey:@"data"];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        }
    } error:&error];
//    NSProgress *progress = nil;
//    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            // 请求失败
//            completion(nil, error);
//            return ;
//        }
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        completion(responseObject, nil);
//    }];
    
    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            // 请求失败
            completion(nil, error);
            return ;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        completion(responseObject, nil);
    }];
    
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)requestBody:(NSString *)url parameters:(NSDictionary *)params body:(NSData *)body completion:( void (^)(id results, NSError *error) )completion
{
    __block NSError *error = nil;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSMutableDictionary *finalParams = [self paramsToPublicWith:params];
    
    NSMutableArray *urlArr = [NSMutableArray array];
    [finalParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *string = [NSString stringWithFormat:@"%@=%@",key,obj];
        [urlArr addObject:string];
    }];
    
    NSString *strUrl =[NSString stringWithFormat:@"?%@",[urlArr componentsJoinedByString:@"&"]];
    url = [NSString stringWithFormat:@"%@%@%@",self.baseURL.absoluteString,url,strUrl];
    DLog(@"\n请求参数 = %@ \n",finalParams);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:finalParams error:nil];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:body];

    
//    NSProgress *progress = nil;
//    NSURLSessionDataTask *task = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            // 请求失败
//            completion(nil, error);
//            return ;
//        }
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        completion(responseObject, nil);
//    }];
//    [task resume];
    
    NSURLSessionDataTask *task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            // 请求失败
            completion(nil, error);
            return ;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        completion(responseObject, nil);
    }];
    [task resume];
    
    return task;
}

- (void)download
{
    
    
    
}
/// 读取cookie
- (NSArray *)readCookies
{
    NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    // HTTPCookieAcceptPolicy  决定了什么情况下 session 应该接受从服务器发出的 cookie
    // HTTPShouldSetCookies 指定了请求是否应该使用 session 存储的 cookie，即 HTTPCookieSorage 属性的值
    NSArray *cookies = [storage cookies];
    DLog(@"\n cookies = %@ \n",cookies);
    return cookies;
}
/// 清除cookie
- (void)clearCookies
{
    NSArray *arr = [self readCookies];
    NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [storage deleteCookie:obj];
    }];
}

#pragma mark - 自控参数

- (NSString *)serverURL
{
    if (!_serverURL) {
        _serverURL = [[NSUserDefaults standardUserDefaults] objectForKey:_DEVURLKey];
        if (!_serverURL) {
            _serverURL = @"https://api.vipet.com.cn/"; // 请求地址
        }
    }
    return _serverURL;
}
- (void)setServerURL:(NSString *)serverURL
{
    if ([serverURL isEqualToString:_serverURL]) {
        return;
    }
    _serverURL = serverURL;
    [[NSUserDefaults standardUserDefaults] setObject:_serverURL forKey:_DEVURLKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end








