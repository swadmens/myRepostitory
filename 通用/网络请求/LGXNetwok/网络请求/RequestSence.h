//
//  RequestSence.h
//  AFTest
//
//  Created by icash on 15-7-22.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDObjC.h"
#import "AFNetworkReachabilityManager.h"
#define publickkey @"123456"
#define LGXMD5(s)                             [RequestSence MD5EncryptWithString:(s)]
#define LGXAES(s)                             [RequestSence AESEncryptWithString:(s)]

/// 自定的错误码
static int _kCustomErrorCode = -999;

/// 静态URL的域名
extern NSString *_kStaticURL;

/// 请求完成
typedef void(^RequestSuccessBlock)(id obj);
/// 请求失败
typedef void(^RequestErrorBlock)(NSError *error);
/// 返回缓存
typedef void(^RequestCacheBlock)(id obj);

/**
 * 所有的请求都继承自该类型
 */
@interface RequestSence : NSObject
/// 初始化调用
- (void)doSetup;
/// 主机,默认返回:
@property (nonatomic, strong) NSString *hostURL;
/// 请求path
@property (nonatomic, strong) NSString *pathURL;
/// 请求参数
@property (nonatomic, strong) NSMutableDictionary *params;
/// 请求Body
@property (nonatomic, strong) NSData *body;
/// 网络状态
@property (nonatomic, readonly) AFNetworkReachabilityStatus networkStatus;
/**
 * 请求方法
 * @"GET" \ @"POST" 默认:@"GET"
 */
@property (nonatomic, strong) NSString *requestMethod;
/// 是否使用缓存
@property (nonatomic) BOOL useCache;
/**
 * 用于区分请求的唯一标识
 * 默认是hostURL+pathURL的MD5加密
 */
@property (nonatomic, strong) NSString *requestUUID;

@property (nonatomic, strong) NSError *customError;
/// 再次请求时，是否取消前一次请求,默认为YES
@property (nonatomic) BOOL cancelRequestWhenReuqestAgain;

/// int bool 等转成number
+ (NSNumber *)numberWithOjbect:(id)obj;
/// 检查错误是否需要自己提示
+ (BOOL)shouldTipMessageWithError:(NSError *)error;
/// 是否需要自己提示
+ (BOOL)shouldTipMessageWithObject:(id)obj;

/// 开始请求
- (void)sendRequest;
/// 请求完成
- (void)requestFinished:(id)result;
/// 请求失败
- (void)requestError:(NSError *)error;
/// 各种block
/// 成功
@property (nonatomic, copy) RequestSuccessBlock successBlock;
/// 失败
@property (nonatomic, copy) RequestErrorBlock errorBlock;
/// 缓存
@property (nonatomic, copy) RequestCacheBlock cacheBlock;

/// 是否在请求中 
@property (nonatomic, readonly) BOOL isRunning;
/// 取消
- (void)cancel;
/// 获取cookie
- (NSArray *)cookies;
/// 根据key来获取cookie
- (NSString *)readCookieValueBy:(NSString *)key;
/// 清除cookie
+ (void)clearCookies;
/// 是否使用cookie
@property (nonatomic) BOOL useCookie;

/// 短信里面使用的返回：|时间戳|cookie ssid
- (NSString *)getSMSAuthCode;

//md5加密
+ (NSString *)MD5EncryptWithString:(NSString *)str;
//aes加密
+ (NSString *)AESEncryptWithString:(NSString *)str;

@end



