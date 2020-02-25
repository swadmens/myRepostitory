//
//  LGXSMSEngine.h
//  YaYaGongShe
//
//  Created by icash on 16-4-3.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _SMSAppKey      @"1133242737c63"
#define _SMSAppSecret   @"7b98e76be1e102c4648c69d38fcc661b"

typedef enum : NSUInteger {
    VerificationRegister,
    VerificationForget,
} VerificationType;

typedef void (^SMSFinishedResultHandler) (BOOL success);

@interface LGXSMSEngine : NSObject

+ (void)setupSMS;
/// 获取验证码
+ (void)getVerificationCodeWithPhone:(NSString *)phoneNumber withType:(VerificationType)vType result:(SMSFinishedResultHandler)result;
/// 验证验证码
+ (void)commitVerificationCode:(NSString *)code withPhone:(NSString *)phoneNumber result:(SMSFinishedResultHandler)result;
@end
