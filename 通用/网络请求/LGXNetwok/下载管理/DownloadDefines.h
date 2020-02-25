//
//  DownloadDefines.h
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#ifndef AFTest_DownloadDefines_h
#define AFTest_DownloadDefines_h

#import "MyMD5.h"

#define kBackgroundDownloadIdentifier   @"com.icash.background.download"

/// filePath ==nil即为下载失败
typedef void(^DownloadDidFinished)(NSString *filePath);
typedef void(^DownloadUpdateProgress)(NSProgress *progress);

#endif
