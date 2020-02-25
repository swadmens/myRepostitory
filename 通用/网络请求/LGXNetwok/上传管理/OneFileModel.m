//
//  OneFileModel.m
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import "OneFileModel.h"

@implementation OneFileModel


//- (NSString *)keyName
//{
//    NSString *name = @"";
//    NSString *kuozhanming = [self.fileName pathExtension];
//    if (kuozhanming) {
//        name = [self.fileName substringToIndex:(self.fileName.length - kuozhanming.length-1)];
//    }
//    return name;
//}
- (NSString *)fileName
{
    if (!_fileName) {
        _fileName = @"";
    }
    return _fileName;
}
- (NSString *)mimeType
{
    if (!_mimeType) {
        _mimeType = @"application/octet-stream";
    }
    return _mimeType;
}

@end
