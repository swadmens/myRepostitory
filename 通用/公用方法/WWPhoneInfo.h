//
//  WWPhoneInfo.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWPhoneInfo : NSObject
/// 推送标识
+ (NSString *)getPushIdentifier;
/// UUID
+ (NSString *)getUUIDIdentifier;
/// 应用标识
+ (NSString *)getBundleIdentifier;
/// 系统版本
+ (NSString *)getSystemVersion;
/// 手机型号 model
+ (NSString *)getPhoneModel;
/// 手机别名 name
+ (NSString *)getCustomName;
/// 设备名称 systemName
+ (NSString *)getSystemName;
///判断设备型号名称
+ (NSString*)deviceString;
/// 地方型号 localizedModel
+ (NSString *)getLocalizedModel;
/// 详细手机型号
+ (NSString *)getDetailModel;
/// 得到cpu 类型
+ (NSString *)getCPUType;
///  需要上传给服务器的手机型号 型号|系统
+ (NSString *)getPhoneDetailModel;
///  返回app版本
+ (NSString *)getAPPVersion;
/// 返回app名称
+ (NSString *)getAPPName;

+ (void)savePushIdentifier:(NSData *)pushToken;

#pragma mark - 各种检查
///  是否允许机册 照相机
+ (BOOL)isPhotoAllowedAndShowAlert:(BOOL)show;
///  用户是否允许 推送
+ (BOOL)isPushAllowedAndShowAlert:(BOOL)show;
@end
