//
//  SharedClient.h
//  AFTest
//
//  Created by icash on 15-7-22.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^NetworkChangedHandle)(AFNetworkReachabilityStatus status);


@interface SharedClient : AFHTTPSessionManager

/// 服务器地址
@property (nonatomic, strong) NSString *serverURL;

/// 不包含http的域，如：apitext.gutou.com
+ (NSString *)domainURL;
/// 初始化单例
+ (SharedClient *)sharedInstance;
/// 读取cookie
- (NSArray *)readCookies;
/// 清除cookie
- (void)clearCookies;
+ (NSString *)requestURL;
/// 根据参数重建URL
- (NSString *)rebuildURL:(NSString *)url byParams:(NSDictionary *)dict;
/// 获取公共参
- (NSDictionary *)getPublicParams;
/// 添加一些公共参数
- (NSMutableDictionary *)paramsToPublicWith:(NSDictionary *)params;
/// 网络攺变了
@property (nonatomic, copy) NetworkChangedHandle networkStatusDidChanged;
@property (nonatomic, readonly) AFNetworkReachabilityStatus networkStatus;
///moid
@property (nonatomic, readonly) NSMutableDictionary *returnDic;
/// 更新用户地址
- (void)shouldUploadUserLocation;
/**
 get请求
 
 @param url @"xxx.html?do=xx" 或 @"xxx.html"
 @param params 请求参数
 
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)requestGet:(NSString *)url parameters:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion;
/**
 post请求
 
 @param url @"xxx.html?do=xx" 或 @"xxx.html"
 @param params 请求参数
 
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)requestPost:(NSString *)url parameters:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion;
/**
 文件上传
 
 @param url @"xxx.html?do=xx" 或 @"xxx.html"
 @param params 请求参数
 @param files 文件 @"data":(NSData *) ,@"name":<#(NSString *)#> , @"fileName":<#(NSString *)#> @"mimeType":(NSString *)
 
 @return NSURLSessionDataTask
 */
- (NSURLSessionUploadTask *)uploadFiles:(NSArray *)files with:(NSDictionary *)params to:(NSString *)url completion:( void (^)(id results, NSError *error) )completion;
/**
 body请求
 
 @param url @"xxx.html?do=xx" 或 @"xxx.html"
 @param params 请求参数
 @param body 请求的dateBody
 
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)requestBody:(NSString *)url parameters:(NSDictionary *)params body:(NSData *)body completion:( void (^)(id results, NSError *error) )completion;

@end
