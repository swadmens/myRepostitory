//
//  LoginBottomViewCell.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/19.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

@interface LoginBottomViewCell : WWTableViewCell


@property (nonatomic,strong) void(^registerButtonClick)(void);//注册
@property (nonatomic,strong) void(^forgetButtonClick)(void);//忘记密码

@property (nonatomic,strong) void(^qqLoginButtonClick)(void);//QQ登录
@property (nonatomic,strong) void(^wxLoginButtonClick)(void);//微信登录
@property (nonatomic,strong) void(^wbLoginButtonClick)(void);//微博登录



@end
