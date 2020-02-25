//
//  AssociatedRegistRequest.h
//  TaoChongYouPin
//
//  Created by 汪伟 on 2018/3/19.
//  Copyright © 2018年 FusionHK. All rights reserved.
//

#import "RequestSence.h"

@interface AssociatedRegistRequest : RequestSence

@property (nonatomic, strong) NSString *phone;//手机号
@property (nonatomic, strong) NSString *pwd;//密码

@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *zone_number;


@property(nonatomic,strong) NSString *openid;
@property(nonatomic,strong) NSString *ThirdCode;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *headimgurl;

@end
