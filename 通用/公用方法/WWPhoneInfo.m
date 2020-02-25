//
//  WWPhoneInfo.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

NSString *const __PUSHKEY = @"com.epet.gutou.pushToken";
NSString *const __ACCOUNTIDENTIFIER = @"com.epet.gutou.uuid";
NSString *const __ACCOUNTPASSWORD = @"com.epet.gutou.password";
NSString *const __ACCOUNTNAME = @"com.epet.gutou.account";

#import "WWPhoneInfo.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <mach/machine.h>
#import "sys/utsname.h"
#import "KeychainItemWrapper.h"

static NSString *_bundleSeedID = @"";


@implementation WWPhoneInfo
//推送标识
+ (NSString *)getPushIdentifier
{
    NSString *pushToken = [[NSUserDefaults standardUserDefaults] objectForKey:__PUSHKEY];
    if (pushToken == nil) pushToken = @"0";
    return pushToken;
}
+ (NSString *)bundleSeedID {
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge NSString *)kSecClassGenericPassword, (__bridge NSString *)kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kSecAttrAccessGroup];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}
//UUID
+ (NSString *)getUUIDIdentifier
{
    /*
    if ([_bundleSeedID isEqual:@""]) {
        _bundleSeedID = [WWPhoneInfo bundleSeedID];
    }
    /// 这个要跟 一样
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                         initWithIdentifier:@"UUID"
                                         accessGroup:[NSString stringWithFormat:@"%@.com.yaya.GenericKeychainUUID",_bundleSeedID]];
    
    NSString *strUUID = [keychainItem objectForKey:(id)CFBridgingRelease(kSecValueData)];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""])
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        strUUID = [strUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [keychainItem setObject:strUUID forKey:(id)CFBridgingRelease(kSecValueData)];
        
    }
    DLog(@"\n _____uuid=%@ \n",strUUID);
     */
    
    
    NSString *strUUID  = [UUIDManager getDeviceID];

    return strUUID;
}
//应用标识
+ (NSString *)getBundleIdentifier
{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];//获取info－plist
    NSString *appIdentifier = [dic objectForKey:@"CFBundleIdentifier"];//获取Bundle identifier
    return appIdentifier;
}


+ (void)savePushIdentifier:(NSData *)pushToken
{
    NSString *aToken = [[[[pushToken description]
                          stringByReplacingOccurrencesOfString:@"<" withString:@""]
                         stringByReplacingOccurrencesOfString:@">" withString:@""]
                        stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    [[NSUserDefaults standardUserDefaults] setObject:aToken forKey:__PUSHKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//系统版本
+ (NSString *)getSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
//手机型号 model
+ (NSString *)getPhoneModel
{
    return [[UIDevice currentDevice] model];
}
//手机别名 name
+ (NSString *)getCustomName
{
    return [[UIDevice currentDevice] name];
}
//设备名称 systemName
+ (NSString *)getSystemName
{
    return [[UIDevice currentDevice] systemName];
}
//地方型号 localizedModel
+ (NSString *)getLocalizedModel
{
    return [[UIDevice currentDevice] localizedModel];
}
+ (NSString *)getDetailModel
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    return platform;
}
/// 得到cpu 类型
+ (NSString *)getCPUType
{
    size_t size;
    sysctlbyname("hw.cputhreadtype", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.cputhreadtype", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    return platform;
}
// 返回app版本
+ (NSString *)getAPPVersion
{
    
    NSString *versionstring = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return versionstring;
}
/// 返回app名称
+ (NSString *)getAPPName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}
// 需要上传给服务器的手机型号 型号|系统
+ (NSString *)getPhoneDetailModel
{
    NSString *finalstring = [NSString stringWithFormat:@"%@|%@",[self getDetailModel],[self getSystemVersion]];
    DLog(@"\n finalstring = %@ \n",finalstring);
    return finalstring;
}

#pragma mark - 各种检查
+ (BOOL)isPhotoAllowedAndShowAlert:(BOOL)show
{
    BOOL isAllow = NO;
    NSString *name = [WWPhoneInfo getAPPName];
    NSInteger photostatus = [ALAssetsLibrary authorizationStatus];
    NSString *msg = @"";
    switch (photostatus) {
        case ALAuthorizationStatusNotDetermined: // 用户尚未做出了选择这个应用程序的问候
            show = NO;
            isAllow = YES;
            break;
        case ALAuthorizationStatusRestricted: //  此应用程序没有被授权访问的照片数据。可能是家长控制权限。
            msg = NSLocalizedString(@"haveNoAuthority", nil);
            break;
        case ALAuthorizationStatusDenied: // 用户已经明确否认了这一照片数据的应用程序访问.
            
            msg = [NSString stringWithFormat:NSLocalizedString(@"allowAccessAlbums", nil),name];
            break;
        case ALAuthorizationStatusAuthorized: // 允许
            isAllow = YES;
            show = NO;
            break;
            
        default:
            break;
    }
    if (isAllow == NO && show) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"accessRestricted", nil) message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"knowing", nil) otherButtonTitles: nil];
        [alert show];
        alert = nil;
    }
    return isAllow;
}
// 用户是否允许 推送
+ (BOOL)isPushAllowedAndShowAlert:(BOOL)show
{
    BOOL isAllow = YES;
    NSString *name = [WWPhoneInfo getAPPName];
    NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"allowSendNoticon", nil),name];
    if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
        isAllow = NO;
    }
    
    if (isAllow == NO && show) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"pushRestricted", nil) message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"knowing", nil) otherButtonTitles: nil];
        [alert show];
        alert = nil;
    }
    return isAllow;
}

+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *str_title = @"";
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    str_title= @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    str_title= @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    str_title= @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    str_title= @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    str_title= @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    str_title= @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    str_title= @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone5,1"])    str_title= @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    str_title= @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    str_title= @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    str_title= @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    str_title= @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    str_title= @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    str_title= @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    str_title= @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    str_title= @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    str_title= @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    str_title= @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    str_title= @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    str_title= @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])    str_title= @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])    str_title= @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])    str_title= @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] ||
        [deviceString isEqualToString:@"iPhone10,6"])   str_title= @"iPhone X";

    if ([deviceString isEqualToString:@"iPod1,1"])      str_title= @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      str_title= @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      str_title= @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      str_title= @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      str_title= @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    //    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    //    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    //    NSLog(@"NOTE: Unknown device type: %@", deviceString);

    deviceString = str_title;
    
    if ([WWPublicMethod isStringEmptyText:deviceString] == NO) {
        return @"iPhone X";
    }
    
#if TARGET_IPHONE_SIMULATOR//模拟器
    return @"iPhone X";
#elif TARGET_OS_IPHONE//真机
    return deviceString;
#endif
    
}

@end
