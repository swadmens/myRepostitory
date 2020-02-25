//
//  MyMD5.m
//  GoodLectures
//
//  Created by yangshangqing on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyMD5.h"
#import "CommonCrypto/CommonDigest.h"

@implementation MyMD5

+(NSString *) md5: (NSString *) inPutText 
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+(NSString*)UrlEncoding:(NSString *)inputString
{
    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                  (CFStringRef)inputString, nil,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    return encodedValue;
}

+(NSMutableDictionary*)updataDic:(NSString*)phoneNum
{
    NSData* originData = [phoneNum dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *encodedValue = URLEncod(encodeResult);
    
    //获取当前时间戳
    NSDate *date = [NSDate date];
    NSTimeInterval currentTimeInterval = (int)[date timeIntervalSince1970];
    NSString *timeCurrent=[NSString stringWithFormat:@"%.0f",currentTimeInterval];
    
    
    NSString *newTimePhon=[NSString stringWithFormat:@"%@%@",encodeResult,timeCurrent];
    NSString *validation=URLEncod(MD5(newTimePhon));
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"phone":encodedValue,
                                                                                  @"timestamp":timeCurrent,
                                                                                  @"validation":validation,
                                                                                  }];
    
    return params;
}
///获取验证码，邮箱的加密处理
+(NSMutableDictionary*)updataEmailDic:(NSString*)email
{
    NSData* originData = [email dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *encodedValue = URLEncod(encodeResult);
    
    //获取当前时间戳
    NSDate *date = [NSDate date];
    NSTimeInterval currentTimeInterval = (int)[date timeIntervalSince1970];
    NSString *timeCurrent=[NSString stringWithFormat:@"%.0f",currentTimeInterval];
    
    
    NSString *newTimePhon=[NSString stringWithFormat:@"%@%@",encodeResult,timeCurrent];
    NSString *validation=URLEncod(MD5(newTimePhon));
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"email":encodedValue,
                                                                                  @"timestamp":timeCurrent,
                                                                                  @"validation":validation,
                                                                                  }];
    
    return params;
}


@end
