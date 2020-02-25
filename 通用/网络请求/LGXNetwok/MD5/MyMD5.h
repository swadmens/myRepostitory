//
//  MyMD5.h
//  GoodLectures
//
//  Created by yangshangqing on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MD5(str) [MyMD5 md5:str]

#define URLEncod(str) [MyMD5 UrlEncoding:str]
@interface MyMD5 : NSObject {
    
}
/*****
 2011.09.15
 创建： shen
 MD5 加密
 *****/

+(NSString *) md5: (NSString *) inPutText ;

///URLEncoding编码
+(NSString*)UrlEncoding:(NSString*)inputString;

///获取验证码，加密处理
+(NSMutableDictionary*)updataDic:(NSString*)phoneNum;

///获取验证码，邮箱的加密处理
+(NSMutableDictionary*)updataEmailDic:(NSString*)email;


@end
