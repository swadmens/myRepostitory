//
//  DownloadEngine.h
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//



#import "AFURLSessionManager.h"
#import "DownloadDefines.h"

@interface DownloadEngine :NSObject

+ (DownloadEngine *)sharedInstance;
/**
 * 增加一个普通下载
 */
- (NSURLSessionDownloadTask *)addDownload:(NSString *)url toPath:(NSString *)downloadPath withName:(NSString *)fileName reDownload:(BOOL)redown onCompletion:(DownloadDidFinished)finishBlock progress:(DownloadUpdateProgress)downloadProgress;
/// 取消下载
- (void)cancelDownloadTask:(NSURLSessionDownloadTask *)task;

@end
