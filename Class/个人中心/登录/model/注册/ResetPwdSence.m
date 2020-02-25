//
//  ResetPwdSence.m
//  YaYaGongShe
//
//  Created by icash on 16-4-7.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "ResetPwdSence.h"
#import "MyMD5.h"
@implementation ResetPwdSence

- (void)doSetup
{
    [super doSetup];
    self.pathURL = @"auth/passwdback";
}
- (NSMutableDictionary *)params
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:MD5(self.password) forKey:@"pwd"];
    [dic setObject:self.phone forKey:@"phone"];
    [dic setObject:self.token forKey:@"token"];
    [dic setObject:self.zone_number forKey:@"zone_number"];

    return dic;
}
@end
