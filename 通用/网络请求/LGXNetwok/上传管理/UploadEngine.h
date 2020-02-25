//
//  UploadEngine.h
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadDefines.h"
#import "SharedClient.h"
/**
 支持后台上传
 */
@interface UploadEngine : NSObject

+ (UploadEngine *)sharedInstance;
- (NSURLSessionUploadTask *)addUploadFiles:(NSArray *)files with:(NSDictionary *)params to:(NSString *)url completion:(didFinishedUpload)finishedBlock error:(didErrorUpload)errorBlock progress:(updateUploadProgress)progressBlock;
/// 取消
- (void)cancelUploadTask:(NSURLSessionUploadTask *)task;
@end
