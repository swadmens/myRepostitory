//
//  UploadDefines.h
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#ifndef AFTest_UploadDefines_h
#define AFTest_UploadDefines_h

#define kBackgroundUploadIdentifier   @"com.icash.background.upload"

/// obj为nil,则失败
/// 请求失败
typedef void(^didErrorUpload)(NSError *error);
typedef void(^didFinishedUpload)(id obj);
typedef void(^updateUploadProgress)(NSProgress *progress);

#import "OneFileModel.h"

#endif
