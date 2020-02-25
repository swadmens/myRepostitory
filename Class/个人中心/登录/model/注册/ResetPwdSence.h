//
//  ResetPwdSence.h
//  YaYaGongShe
//
//  Created by icash on 16-4-7.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "RequestSence.h"

@interface ResetPwdSence : RequestSence
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *zone_number;


@end
