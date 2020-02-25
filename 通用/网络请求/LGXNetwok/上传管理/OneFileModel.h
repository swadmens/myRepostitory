//
//  OneFileModel.h
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 一个上传体
 */
@interface OneFileModel : NSObject

/// 自动取fileName的file  ,xxx.xx 取出来是xxx
@property (nonatomic, strong) NSString *keyName;
///
@property (nonatomic, strong) NSString *fileName;
/// 默认：multipart/form-data
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSData *fileData;

@end
