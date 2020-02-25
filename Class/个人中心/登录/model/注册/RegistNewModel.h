//
//  RegistNewModel.h
//  TaoChongYouPin
//
//  Created by 汪伟 on 2017/9/8.
//  Copyright © 2017年 FusionHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistNewModel : NSObject

@property(nonatomic,strong) NSString *phone;//手机号
@property(nonatomic,strong) NSString *pwd;//密码
@property(nonatomic,strong) NSString *username;//用户名
@property(nonatomic,strong) NSString *agent_sn;//邀请码
@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *yanzhengma;//验证码


@end
