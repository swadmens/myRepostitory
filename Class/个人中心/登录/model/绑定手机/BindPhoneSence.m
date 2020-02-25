//
//  YYBindPhoneSence.m
//  YaYaGongShe
//
//  Created by icash on 16-4-22.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "BindPhoneSence.h"

@implementation BindPhoneSence

- (void)doSetup
{
    [super doSetup];
    self.pathURL = @"User/bindphone";
    self.requestMethod = @"POST";
}
- (NSString *)phone
{
    if (!_phone) {
        _phone = @"0";
    }
    return _phone;
}
- (NSString *)code
{
    if (!_code) {
        _code = @"0";
    }
    return _code;
}
- (NSMutableDictionary *)params
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.phone forKey:@"mobile"];
    [dic setObject:self.code forKey:@"code"];
    return dic;
}
@end
