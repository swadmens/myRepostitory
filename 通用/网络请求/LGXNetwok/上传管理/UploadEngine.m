//
//  UploadEngine.m
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import "UploadEngine.h"
#import "AFURLSessionManager.h"

@interface UploadEngine ()

@property (nonatomic, strong) AFURLSessionManager *backgroundManager;

@end



@implementation UploadEngine

+ (UploadEngine *)sharedInstance
{
    static UploadEngine *_engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _engine = [[UploadEngine alloc] init];
    });
    return _engine;
}
- (AFURLSessionManager *)backgroundManager
{
    if (!_backgroundManager) {
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kBackgroundUploadIdentifier];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _backgroundManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
//        _backgroundManager.attemptsToRecreateUploadTasksForBackgroundSessions = YES;
        _backgroundManager.responseSerializer = [AFJSONResponseSerializer serializer];
//        _backgroundManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _backgroundManager;
}
/**
 *
 * files : OneFileModel 的集合
 */
- (NSURLSessionUploadTask *)addUploadFiles:(NSArray *)files with:(NSDictionary *)params to:(NSString *)url completion:(didFinishedUpload)finishedBlock error:(didErrorUpload)errorBlock progress:(updateUploadProgress)progressBlock
{
#warning ~~~~~ 自定错误记得到时候写一下定义
    if (url == nil || [url isEqual:@""]) {
        if (errorBlock) {
            errorBlock([NSError errorWithDomain:@"" code:-9999 userInfo:nil]);
        }
        return nil;
    }
    __block NSError *error = nil;
    NSMutableDictionary *finalParams = [[SharedClient sharedInstance] paramsToPublicWith:params];
    DLog(@"\n 上传的参数=%@\n\n",finalParams);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:finalParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i =0; i<files.count; i++) {
            
            OneFileModel *oneFile = [files objectAtIndex:i];
            NSData *data = oneFile.fileData;
            if (data) {
                
                NSString *name = oneFile.keyName;
                NSString *fileName = oneFile.fileName;
                NSString *mimeType = oneFile.mimeType;
                
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
            }
            
        }
    } error:&error];
    
    NSProgress *progress = nil;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//     config.HTTPMaximumConnectionsPerHost = 1; // 连接到同一host的最大联接数. 否则会同时全部上传
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {

    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSString *shabi =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"\n responseObject=%@ ,error=%@\n",responseObject,error);
        if (error) {
            // 请求失败
            if (errorBlock) {
                errorBlock(error);
            }
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            // 自定错误
            if (errorBlock) {
                errorBlock([NSError errorWithDomain:url code:-9999 userInfo:nil]);
            }
            return;
        }
        if (finishedBlock) {
            finishedBlock(responseObject);
        }

    }];
//    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        //        NSString *shabi =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"\n responseObject=%@ ,error=%@\n",responseObject,error);
//        if (error) {
//            // 请求失败
//            if (errorBlock) {
//                errorBlock(error);
//            }
//            return;
//        }
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        if (httpResponse.statusCode != 200) {
//            // 自定错误
//            if (errorBlock) {
//                errorBlock([NSError errorWithDomain:url code:-9999 userInfo:nil]);
//            }
//            return;
//        }
//        if (finishedBlock) {
//            finishedBlock(responseObject);
//        }
//
//    }];

    [manager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (progressBlock) {
            progressBlock(progress);
        }
    }];
    /// 后台完成任务?
    /*
    [self.backgroundManager setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
        
        
        
    }];
    */
    [task resume];
    return task;
}
/// 取消
- (void)cancelUploadTask:(NSURLSessionUploadTask *)task
{
    [task cancel];
}
/*
[progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        DLog(@"\n ~~~~ KVO进度=%f \n",progress.fractionCompleted);
        //progress.fractionCompleted tells you the percent in CGFloat
    }
}
 */
@end
