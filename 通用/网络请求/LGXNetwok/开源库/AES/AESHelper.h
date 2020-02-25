//
//  AESHelper.h
//  MacauFirstBalloon
//
//  Created by user on 13-4-18.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESHelper : NSObject

//解密字符串
+ (NSString *)decryptionString:(NSString *)ciphertext;
//加密字符串
+ (NSString *)encryptString:(NSString *)plaintext;
@end
