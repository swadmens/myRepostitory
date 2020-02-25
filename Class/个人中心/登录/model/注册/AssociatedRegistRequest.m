//
//  AssociatedRegistRequest.m
//  TaoChongYouPin
//
//  Created by 汪伟 on 2018/3/19.
//  Copyright © 2018年 FusionHK. All rights reserved.
//

#import "AssociatedRegistRequest.h"
#import "MyMD5.h"
@implementation AssociatedRegistRequest

- (void)doSetup
{
    [super doSetup];
    self.pathURL = @"connectuser/signup";
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
    
    //设备信息
    NSString *uuidString=[WWPhoneInfo getUUIDIdentifier];//UUID
    NSString *systemVersion=[WWPhoneInfo getSystemVersion];//系统版本
    NSString *systemName=[WWPhoneInfo getCustomName];//设备名称
    NSString *deviceString=[WWPhoneInfo deviceString];//设备型号名称
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.phone forKey:@"mobile"];
    [dic setObject:MD5(self.pwd) forKey:@"password"];
    [dic setObject:self.token forKey:@"token"];
    
    [dic setObject:self.ThirdCode forKey:@"code"];
    [dic setObject:self.nickname forKey:@"nickname"];
    [dic setObject:self.headimgurl forKey:@"headimgurl"];
    [dic setObject:self.openid forKey:@"openid"];
    [dic setObject:self.zone_number forKey:@"zone_number"];
    
    [dic setObject:uuidString forKey:@"device_udid"];
    [dic setObject:systemVersion forKey:@"device_os"];
    [dic setObject:systemName forKey:@"device_name"];
    [dic setObject:deviceString forKey:@"device_type"];
    [dic setObject:@"iOS" forKey:@"device_client"];
    
    return dic;
}

@end
