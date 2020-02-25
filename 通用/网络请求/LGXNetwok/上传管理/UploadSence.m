//
//  UploadSence.m
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import "UploadSence.h"

@interface UploadSence ()

@property (nonatomic, strong) NSURLSessionUploadTask *task;
@property (nonatomic, readwrite) float progress;
@end

@implementation UploadSence
- (NSString *)baseURL
{
    if (!_baseURL) {
        _baseURL = [SharedClient requestURL];
    }
    return _baseURL;
}
- (NSDictionary *)params
{
    if (!_params) {
        _params = [NSDictionary dictionary];
    }
    return _params;
}
- (NSArray *)files
{
    if (!_files) {
        _files = [NSArray array];
    }
    return _files;
}
- (NSError *)customError
{
    return [self customErrorWithInfo:nil];
}
- (NSError *)customErrorWithInfo:(id)info
{
    return [NSError errorWithDomain:@"customError" code:-999 userInfo:info];
}
/// 开始上传
- (void)startUpload
{
    [[SharedClient sharedInstance] shouldUploadUserLocation];
    ///
    self.task = [[UploadEngine sharedInstance] addUploadFiles:self.files with:self.params to:self.url completion:^(id obj) {
        [self handleResult:obj andError:nil];
    } error:^(NSError *error) {
        
        [self handleResult:nil andError:error];
        
    } progress:^(NSProgress *progress) {
        self.progress = (float)progress.fractionCompleted;
        if (self.progressBlock) {
            DLog(@"\n ~~~~ 上传进度%f \n",self.progress);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressBlock(self.progress);
            });
        }
    }];
}
- (void)handleResult:(id)results andError:(NSError *)error
{
    /// 调统一的target判断
//    [GTTargetEngine pushViewController:nil fromController:nil withTarget:[results objectForKey:@"showTarget"]];
    if (error) {
        [self requestError:error]; // self.customError
        return ;
    }
    @try {
        
        int errorCode = [[results objectForKey:@"code"] intValue];
        
        
        if (errorCode == -220) { // 没有登录
            // 提示没有登录，并显示登录界面
//            _kUserModel.isLogined = NO;
//            [_kUserModel checkLoginStatus];
            [self requestError:[self customErrorWithInfo:results]];
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
- (void)requestFinished:(id)obj
{
    if (self.finishedBlock) {
        self.finishedBlock(obj);
    }
}
/// 请求失败
- (void)requestError:(NSError *)error
{
    if (self.errorBlock) {
        self.errorBlock(error);
    }
}
/// 取消下载
- (void)cancel
{
    if (self.task ==nil || self.task.state == NSURLSessionTaskStateCanceling) {
        return;
    }
    [self.task cancel];
}
@end
