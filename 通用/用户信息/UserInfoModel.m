//
//  UserInfoModel.m
//  TaoChongYouPin
//
//  Created by icash on 16/8/30.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "UserInfoModel.h"
#import "JPUSHService.h"

@implementation UserInfoModel
@synthesize user_id = _user_id;
- (NSString *)user_avatar
{
    if (_kUserModel.isLogined) {
        return _user_avatar;
    }
    return @"";
}
- (NSString *)collect
{
    if (!_collect) {
        _collect = @"0";
    }
    return _collect;
}
- (NSString *)message_num
{
    if (!_message_num) {
        _message_num = @"0";
    }
    return _message_num;
}
- (NSString *)language_lang
{
    if (!_language_lang) {
        _language_lang = @"0";
    }
    return _language_lang;
}
-(BOOL)isTest
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"istest"] == nil) {
        _isTest = YES;
    }else{
        _isTest = [[[NSUserDefaults standardUserDefaults] objectForKey:@"istest"] boolValue];
    }
    
    return _isTest;
}
-(BOOL)isClickLoginOut
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isClickLoginOut"] == nil) {
        _isClickLoginOut = NO;
    }else{
        _isClickLoginOut = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isClickLoginOut"] boolValue];
    }
    
    return _isTest;
}

- (NSString *)sellerStatus
{
    if (_kUserModel.isLogined == NO || _sellerStatus == nil) {
        _sellerStatus = @"0";
    }
    return _sellerStatus;
}
-(int)indexShowNum
{
    return 0;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSDictionary *valueDic = [self getPropertiesValues];
    NSArray *properArray = valueDic.allKeys;
    for (int i=0; i<properArray.count; i++) {
        id key = [properArray objectAtIndex:i];
        id value = [valueDic objectForKey:key];
        
        [aCoder encodeObject:value forKey:key];
    }
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        NSArray *properArray = [self getAllProperties];
        
        for (int i=0; i<properArray.count; i++) {
            id key = [properArray objectAtIndex:i];
            id value = [aDecoder decodeObjectForKey:key];
            SEL setMethod = [self creatSetterWithPropertyName:key];
            BOOL canRun = [self respondsToSelector:setMethod];
            if (canRun) {
                SuppressPerformSelectorLeakWarning(
                                                   ///2.3 把值通过setter方法赋值给实体类的属性
                                                   [self performSelectorOnMainThread:setMethod
                                                                          withObject:value
                                                                       waitUntilDone:[NSThread isMainThread]];
                                                   );
                
            }
        }
        
    }
    return self;
}
- (void)makeUserModelWithData:(NSDictionary *)uInfo
{
    
    self.user_name = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"user_name"]];
    self.sex = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"sex"]];
    self.integration = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"integration"]];
    self.email = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"email"]];
    self.user_money = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"user_money"]];
    self.birthday = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"birthday"]];
    
    self.pet_number = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"pet_number"]];
    self.user_age = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"age"]];
    self.user_remark = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"remark"]];
    self.user_region = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"region"]];
    self.user_qrcode = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"qrcode"]];
    self.notifys_number = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"notify_number"]];

    self.collect_word = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"collect_word"]];
    self.collect = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"collect"]];

    self.user_avatar = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"user_photo"]];
    self.mobile = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"mobile_phone"]];
    self.service_phone = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"service_phone"]];
    self.resource_url = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"resource_url"]];
    self.user_code = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"user_code"]];
    self.zone_number = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"zone_number"]];
    self.email = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"email"]];

    
    
    self.sns_wechat = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"sns_wechat"]];
    self.sns_qq = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"sns_qq"]];
    self.sns_weibo = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"sns_weibo"]];
    self.is_password = [[NSString stringWithFormat:@"%@",[uInfo objectForKey:@"is_password"]] boolValue];

    
    /// 状态信息
    NSDictionary *seller = [uInfo objectForKey:@"agent"];
    self.sellerStatus = [NSString stringWithFormat:@"%@",[seller objectForKey:@"status"]];
  
    int user_id = [[NSString stringWithFormat:@"%@",[uInfo objectForKey:@"user_id"]] intValue];
    self.user_id = [NSString stringWithFormat:@"%d",user_id];
    
    [self save];
    
    // 注册推送
    NSString *jalias = [uInfo objectForKey:@"jalias"];
    NSString *jtags = [uInfo objectForKey:@"jtags"];
    [self setTags:jtags andAlias:jalias];
    
    // 说明没有取到用户id，则认为退出
    if (user_id <=0) {
        _kUserModel.isLogined = NO;
    }
}
// tags 以,号为分割
- (void)setTags:(NSString *)tags andAlias:(NSString *)alias
{
    NSSet *pushtags;
    if ([tags isKindOfClass:[NSString class]] && tags.length >0) {
         pushtags = [NSSet setWithArray:[tags componentsSeparatedByString:@","]];
    }
    
    [JPUSHService setTags:pushtags alias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (void)save
{
    // vip信息保存
//    [self.vipModel save];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:data forKey:_kUserInfoModelKey];
    [user synchronize];
}

+ (UserInfoModel *)read
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:_kUserInfoModelKey];
    UserInfoModel *uInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return uInfo;
}

/// 更新我的微标
- (void)updateMineBadge
{
    
}

@end























