//
//  UploadSence.h
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadEngine.h"
@interface UploadSence : NSObject
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *url;
/// OneFileModel的集合
@property (nonatomic, strong) NSArray *files;
/// 参数
@property (nonatomic, strong) NSDictionary *params;
/// 开始下载
- (void)startUpload;
/// 取消下载
- (void)cancel;
@property (nonatomic, strong) NSError *customError;

@property (nonatomic, copy) didFinishedUpload finishedBlock;
@property (nonatomic, copy) didErrorUpload errorBlock;
@property (nonatomic, copy) void(^progressBlock)(float progress);

@property (nonatomic, readonly) float progress;
@end
