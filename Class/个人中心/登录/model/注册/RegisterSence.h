//
//  RegisterSence.h
//  YaYaGongShe
//
//  Created by icash on 16-3-29.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "RequestSence.h"

@interface RegisterSence : RequestSence

@property (nonatomic, strong) NSString *phone;//手机号
@property (nonatomic, strong) NSString *pwd;//密码

@property (nonatomic, strong) NSString *username;//用户名
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *zone_number;

//@property(nonatomic,strong) NSString *openid;
@property(nonatomic,strong) NSString *ThirdCode;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *headimgurl;


@end
