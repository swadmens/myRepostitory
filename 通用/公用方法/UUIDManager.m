//
//  UUIDManager.m
//  获取设备的UUID
//
//  Created by WOSHIPM on 16/11/15.
//  Copyright © 2016年 WOSHIPM. All rights reserved.
//

#import "UUIDManager.h"
#import "AppKeyChain.h"
@implementation UUIDManager
+ (NSString *)getDeviceID {
    // 读取keyChain存储的UUID
    NSString * strUUID = (NSString *)[AppKeyChain loadForKey: @"uuid"];
    // 首次运行生成一个UUID并用keyChain存储
    if ([strUUID isEqualToString: @""] || !strUUID) {
        // 生成uuid
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        // 将该uuid用keychain存储
        [AppKeyChain saveData: strUUID forKey: @"uuid"];
    }
    
    if ([WWPublicMethod isStringEmptyText:strUUID] == NO) {
        return @"123456781234567";
    }
    
#if TARGET_IPHONE_SIMULATOR//模拟器
    return @"123456781234567";
#elif TARGET_OS_IPHONE//真机
    return strUUID;
#endif
    
}
@end
