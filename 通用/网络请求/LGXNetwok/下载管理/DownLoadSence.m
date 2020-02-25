//
//  DownLoadSence.m
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import "DownLoadSence.h"
#import "DownloadEngine.h"

@interface DownLoadSence ()

@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@end

@implementation DownLoadSence


/// 开始下载
- (void)startDownload
{
    self.task = [[DownloadEngine sharedInstance] addDownload:self.url toPath:self.filePath withName:self.fileName reDownload:self.needReDownload onCompletion:^(NSString *filePath) {
        if (self.finishedBlock) {
            self.finishedBlock(filePath);
        }
    } progress:^(NSProgress *progress) {
        if (self.progressBlock) {
            float sprogress = (float)progress.fractionCompleted;
            if (sprogress >0.99) {
                DLog(@"\n~~~下载进度=%f\n",sprogress);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               self.progressBlock(sprogress);
            });
        }
    }];
}
/// 取消下载
- (void)cancel
{
    if (self.needReDownload) {
        [self.task cancel];
        return;
    }
    [[DownloadEngine sharedInstance] cancelDownloadTask:self.task];
}


@end
