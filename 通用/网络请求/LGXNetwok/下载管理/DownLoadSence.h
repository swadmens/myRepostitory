//
//  DownLoadSence.h
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^FinishedBlock)(NSString *filePath);
typedef void(^ProgressDidUpdateBlock)(float progress);

@interface DownLoadSence : NSObject

/// 下载文件路径
@property (nonatomic, strong) NSString *url;
/// 下载到哪里
@property (nonatomic, strong) NSString *filePath;
/// 下载的文件名是什么, 需要带后缀名
@property (nonatomic, strong) NSString *fileName;
/// 是否需要重新下载,如果YES，在取消时会删除，否则会暂时保存
@property (nonatomic) BOOL needReDownload;

/// 开始下载
- (void)startDownload;
/// 取消下载
- (void)cancel;

/// 返回path为nil则为失败
@property (nonatomic, copy) FinishedBlock finishedBlock;
@property (nonatomic, copy) ProgressDidUpdateBlock progressBlock;

@end





