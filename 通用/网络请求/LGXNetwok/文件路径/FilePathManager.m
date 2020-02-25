//
//  FilePathManager.m
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import "FilePathManager.h"

@implementation FilePathManager
/// 默认缓存路径
+ (NSString *)cacheFilePath
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kCachePathName];
    path = [self createPath:path]?path:nil;
    return path;
}
+ (NSString *)appTmpPath
{
    NSString *path =  NSTemporaryDirectory();
    return path;
}
/// 默认下载路径
+ (NSString *)defaultDownloadPath
{
    NSString *path = [FilePathManager cacheFilePath];
    return path;
}
/// 临时文件
+ (NSString *)tmpFilePath
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kTmpPathName];
    path = [self createPath:path]?path:nil;
    return path;
}
/// 创建路径，返回NO则失败
+ (BOOL)createPath:(NSString *)path
{
    BOOL succ = YES;
    NSFileManager *aManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if ([aManager fileExistsAtPath:path isDirectory:&isDir] == NO) {
        NSError *error = nil;
        succ = [aManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    }
    return succ;
}

/// 写入文件
+(void)writeFile:(NSString*)url withPath:(NSString*)path
{
    NSString *documentsPath =[self cacheFilePath];
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:@"iOS.txt"];
    NSString *content = @"我要写数据啦";
    BOOL isSuccess = [content writeToFile:iOSPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (isSuccess) {
        NSLog(@"write success");
    } else {
        NSLog(@"write fail");
    }
}

///读取文件
+(NSString*)readFileContent:(NSString*)path
{
    NSString *documentsPath =[self cacheFilePath];
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:@"iOS.txt"];
    NSString *content = [NSString stringWithContentsOfFile:iOSPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"read success: %@",content);
    return content;
}



/// 读缓存并返回
+ (void)readCachesWhenFinished:(void(^)(float cacheSize))finishedRead
{
    [[GCDQueue globalQueue] queueBlock:^{
        NSFileManager  *_filemanager = [NSFileManager defaultManager];
        
        NSArray *_cachePaths =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        
        NSString  *_filecacheDirectory = [_cachePaths objectAtIndex:0];
        
        NSArray  *_cacheFileList;
        
        NSEnumerator *_cacheEnumerator;
        
        NSString *_cacheFilePathTemp;
        
        unsigned long long int _cacheFolderSize = 0;
        
        _cacheFileList = [ _filemanager subpathsAtPath:_filecacheDirectory];
        
        _cacheEnumerator = [_cacheFileList objectEnumerator];
        
        while (_cacheFilePathTemp = [_cacheEnumerator nextObject])
        {
            NSString *identifier = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleIdentifierKey];
            //排除com.xxx.xx/下面的缓存
            if (![_cacheFilePathTemp isEqualToString:identifier] && ![_cacheFilePathTemp hasPrefix:identifier]) {
                NSString *detailPath = [_filecacheDirectory stringByAppendingPathComponent:_cacheFilePathTemp];
                //                DLog(@"\n ~~~~缓存目录=%@ \n",detailPath);
                NSError *error = nil;
                NSDictionary *_cacheFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:detailPath error:&error];
                
                _cacheFolderSize += [_cacheFileAttributes fileSize];
            }
        }
        float sizefloat = (float)((_cacheFolderSize - 0.0) / 1024.0/1024.0);
        if (finishedRead) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finishedRead(sizefloat);
            });
        }
    }];
}
/// 清除缓存
+ (void)clearCachesWhenFinished:(void(^)(float cacheSize))finished
{
    [[GCDQueue globalQueue] queueBlock:^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        
        NSString *identifier = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleIdentifierKey];
        
        for (NSString *p in files) {
            
            //排除com.xxx.xx/下面的缓存
            if (![p isEqualToString:identifier] && ![p hasPrefix:identifier]) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
        }
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finished(0);
            });
        }
    }];
}
@end
