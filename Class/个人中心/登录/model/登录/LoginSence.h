//
//  LoginSence.h
//  YaYaGongShe
//
//  Created by icash on 16-3-29.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "RequestSence.h"

@interface LoginSence : RequestSence


@property (nonatomic, strong) NSString *user_id;//用户ID
@property (nonatomic, strong) NSString *ec_salt;//用户随机码
@property (nonatomic, strong) NSString *passwd;//密码
@property (nonatomic, strong) NSString *login_key;//
@property (nonatomic, strong) NSString *region;//
@property (nonatomic, strong) NSString *longitude;//
@property (nonatomic, strong) NSString *latitude;//


@end
