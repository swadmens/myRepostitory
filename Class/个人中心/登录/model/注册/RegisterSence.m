//
//  RegisterSence.m
//  YaYaGongShe
//
//  Created by icash on 16-3-29.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "RegisterSence.h"
#import "MyMD5.h"
@implementation RegisterSence

- (void)doSetup
{
    [super doSetup];
    self.pathURL = @"auth/register";
}
- (NSString *)username
{
    if (!_username) {
        _username = @"";
    }
    return _username;
}
- (NSString *)pwd
{
    if (!_pwd) {
        _pwd = @"";
    }
    return _pwd;
}

- (NSString *)phone
{
    if (!_phone) {
        _phone = @"";
    }
    return _phone;
}

- (NSMutableDictionary *)params
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.phone forKey:@"phone"];
    [dic setObject:MD5(self.pwd) forKey:@"pwd"];
    [dic setObject:self.token forKey:@"token"];
    [dic setObject:self.zone_number forKey:@"zone_number"];
    
    return dic;
}


@end
