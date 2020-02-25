//
//  RequestSence.m
//  AFTest
//
//  Created by icash on 15-7-22.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import "RequestSence.h"
#import "SharedClient.h"
#import "AESHelper.h"
#import "MyMD5.h"
#import "JPUSHService.h"

//#import "GTUserModel.h"

NSString *_kStaticURL;

@interface RequestSence ()

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSString *uuidCode;


@end

@implementation RequestSence
@synthesize params = _params;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hostURL = @"";
        self.requestMethod = @"GET";
        self.cancelRequestWhenReuqestAgain = YES;
        [self doSetup];
    }
    return self;
}
/// 初始化调用
- (void)doSetup
{
    
}
- (NSString *)pathURL
{
    if (!_pathURL) {
        _pathURL = @"";
    }
    return _pathURL;
}
- (NSString *)requestUUID
{
    if (!_requestUUID) {
#warning requestUUID , MD5加密一下
        _requestUUID = @"";
    }
    return _requestUUID;
}
- (NSError *)customError
{
    return [self customErrorWithInfo:nil];
}
- (NSError *)customErrorWithInfo:(id)info
{
    return [NSError errorWithDomain:@"customError" code:_kCustomErrorCode userInfo:info];
}
/// 是否需要自己提示
+ (BOOL)shouldTipMessageWithError:(NSError *)error
{
    if (error.code == _kCustomErrorCode) {
        return [self shouldTipMessageWithObject:error.userInfo];
    }
    return YES;
}
/// 是否需要自己提示
+ (BOOL)shouldTipMessageWithObject:(id)obj
{
    NSString *msg = [obj objectForKey:@"msg"];
    if ([msg isKindOfClass:[NSString class]] && [msg isEqual:@""] == NO) {
        return NO;
    }
    return YES;
}
- (AFNetworkReachabilityStatus)networkStatus
{
    return [SharedClient sharedInstance].networkStatus;
}
- (NSString *)requestMethod
{
    if (_requestMethod == nil || [_requestMethod isKindOfClass:[NSString class]] == NO || [_requestMethod isEqual:@"(null)"] || [_requestMethod isEqual:@"<null>"]) {
        _requestMethod = @"POST";
    }
    return _requestMethod;
}
/// 开始请求
- (void)sendRequest
{
    if (self.cancelRequestWhenReuqestAgain) {
        [self cancel];
    }
    if ([self.requestMethod isEqual:@"GET"]) {
        
        self.task = [[SharedClient sharedInstance] requestGet:self.pathURL parameters:self.params completion:^(id results, NSError *error) {
            NSDictionary *dic = results;
            DLog(@"%@",[dic objectForKey:@"errorMsg"]);
            [self handleResult:results andError:error];
            
        }];
        
    }else if ([self.requestMethod isEqual:@"POST"]){
     
        self.task = [[SharedClient sharedInstance] requestPost:self.pathURL parameters:self.params completion:^(id results, NSError *error) {
            NSDictionary *dic = results;DLog(@"%@",[dic objectForKey:@"errorMsg"]);
            [self handleResult:results andError:error];
            
        }];
    }else if ([self.requestMethod isEqual:@"BODY"]){
        self.task = [[SharedClient sharedInstance] requestBody:self.pathURL parameters:self.params body:self.body completion:^(id results, NSError *error) {
            NSDictionary *dic = results;
            DLog(@"%@",[dic objectForKey:@"errorMsg"]);
            [self handleResult:results andError:error];
        }];
    }
}
- (void)handleResult:(id)results andError:(NSError *)error
{
    /// 调统一的target判断
//    [GTTargetEngine pushViewController:nil fromController:nil withTarget:[results objectForKey:@"showTarget"]];
    if (error) {
        DLog(@"\n ~~~~~~ 报错啦 : %@ \n ~~~~~~ \n",error);
        [self requestError:self.customError];
        return ;
    }
    @try {
        
        int errorCode = [[results objectForKey:@"code"] intValue];
        
        if (errorCode == -220) { // 没有登录
            // 提示没有登录，并显示登录界面
            _kUserModel.isLogined = NO;
            [_kUserModel checkLoginStatus];
            [self requestError:[self customErrorWithInfo:results]];
            return;
        }else if (errorCode == -221){ //被踢下线
            [_kHUDManager hideAfter:0.1 onHide:nil];
            
           
            
            /// 清除极光推送信息
            [JPUSHService setTags:[NSSet set] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
            }];
            
            
            NSString *msg = [results objectForKey:@"msg"];
            [[TCNewAlertView shareInstance] showAlert:NSLocalizedString(@"xxtz", nil) message:msg cancelTitle:nil viewController:nil confirm:^(NSInteger buttonTag) {
                if (buttonTag == 0) {
                    _kUserModel.isLogined = NO;
                    [_kUserModel checkLoginStatus];
                }
            } buttonTitles:NSLocalizedString(@"exitLogon", nil), nil];

            return;
        }else if (errorCode != 1) {
            [self requestError:[self customErrorWithInfo:results]];
            return ;
        }
        [self requestFinished:results];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
/// 请求完成
- (void)requestFinished:(id)result
{
    [[GCDQueue mainQueue] queueBlock:^{
        if (self.successBlock) {
            self.successBlock(result);
        }
    }];
}
/// 请求失败
- (void)requestError:(NSError *)error
{
    [[GCDQueue mainQueue] queueBlock:^{
        if (self.errorBlock) {
            self.errorBlock(error);
        }
    }];
}
- (BOOL)isRunning
{
    if (self.task && self.task.state == NSURLSessionTaskStateRunning) {
        return YES;
    }
    return NO;
}
/// 取消
- (void)cancel
{
    if (self.task == nil) {
        return;
    }
    if (self.task.state == NSURLSessionTaskStateCanceling) {
        return;
    }
    
    [self.task cancel];
    self.task = nil;
}
/// 获取cookie
- (NSArray *)cookies
{
    return [[SharedClient sharedInstance] readCookies];
}
/// 根据key来获取cookie
- (NSString *)readCookieValueBy:(NSString *)key
{
    __block NSString *str = @"";
    if (key == nil || [key isEqual:@""]) {
        return str;
    }
    
    NSArray *cookies = [self cookies];
    [cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSHTTPCookie *oneCookie = (NSHTTPCookie *)obj;
        if ([oneCookie.name isEqual:key]) {
            str = oneCookie.value;
            *stop = YES;
        }
    }];
    return str;
}
/// 清除cookie
+ (void)clearCookies
{
    [[SharedClient sharedInstance] clearCookies];
}
- (NSString *)uuidCode
{
    if (!_uuidCode) {
        _uuidCode = [WWPhoneInfo getUUIDIdentifier];
    }
    return _uuidCode;
}
///
- (NSString *)getSMSAuthCode
{
    NSString *SESSID = [self readCookieValueBy:@"X15t_ssid"];
    NSString *timeStr = [_kDatePicker timeIntervalStringWithDate:nil];
    NSString *code = [NSString stringWithFormat:@"|%@|%@",timeStr,SESSID];
    return code;
}
+ (NSNumber *)numberWithOjbect:(id)obj
{
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    int a = [obj intValue];
    return [NSNumber numberWithInt:a];
}
//md5加密
+ (NSString *)MD5EncryptWithString:(NSString *)str
{
    return [MyMD5 md5:str];
}

//aes加密
+ (NSString *)AESEncryptWithString:(NSString *)str
{
    return [AESHelper encryptString:str];
}
@end
