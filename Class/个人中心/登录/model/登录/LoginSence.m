//
//  LoginSence.m
//  YaYaGongShe
//
//  Created by icash on 16-3-29.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "LoginSence.h"
#import "MyMD5.h"
@implementation LoginSence

- (void)doSetup
{
    [super doSetup];
    self.pathURL = @"auth/login";
    self.requestMethod = @"POST";
}

- (NSMutableDictionary *)params
{
    //设备信息
    NSString *uuidString=[WWPhoneInfo getUUIDIdentifier];//UUID
    NSString *systemVersion=[WWPhoneInfo getSystemVersion];//系统版本
    NSString *systemName=[WWPhoneInfo getCustomName];//设备名称
    NSString *deviceString=[WWPhoneInfo deviceString];//设备型号名称
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:uuidString forKey:@"device_udid"];
    [dic setObject:systemVersion forKey:@"device_os"];
    [dic setObject:systemName forKey:@"device_name"];
    [dic setObject:deviceString forKey:@"device_type"];
    [dic setObject:@"iOS" forKey:@"device_client"];
    
    
    [dic setObject:self.user_id forKey:@"user_id"];
    [dic setObject:self.ec_salt forKey:@"ec_salt"];
    [dic setObject:self.passwd forKey:@"passwd"];
    [dic setObject:self.login_key forKey:@"login_key"];
    [dic setObject:self.region forKey:@"region"];
    [dic setObject:self.longitude forKey:@"longitude"];
    [dic setObject:self.latitude forKey:@"latitude"];

    
    
    if ([_kUserModel.userInfo.session_id isKindOfClass:[NSString class]]) {
        NSString *alphsetStr=[WWPublicMethod makeAlphabeticOrdering:dic];
        [dic setObject:alphsetStr forKey:kSignKey];
    }
 
    
    
    return dic;
}


@end
