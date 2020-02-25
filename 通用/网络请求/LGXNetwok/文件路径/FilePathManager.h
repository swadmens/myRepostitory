//
//  FilePathManager.h
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCachePathName  @"GutouFileCache"
#define kTmpPathName    @"GutouTmpFileCache"

@interface FilePathManager : NSObject
/// 默认缓存路径
+ (NSString *)cacheFilePath;
/// 默认下载路径
+ (NSString *)defaultDownloadPath;
/// 临时文件
+ (NSString *)tmpFilePath;
/// 创建路径，返回NO则失败
+ (BOOL)createPath:(NSString *)path;
/// 获取tmp目录
+ (NSString *)appTmpPath;

/// 写入文件
+(void)writeFile:(NSString*)url withPath:(NSString*)path;

///读取文件
+(NSString*)readFileContent:(NSString*)path;



/// 读缓存并返回
+ (void)readCachesWhenFinished:(void(^)(float cacheSize))finishedRead;
/// 清除缓存
+ (void)clearCachesWhenFinished:(void(^)(float cacheSize))finished;
@end
