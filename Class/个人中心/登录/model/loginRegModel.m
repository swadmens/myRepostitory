//
//  loginRegModel.m
//  TaoChongYouPin
//
//  Created by 汪伟 on 2017/8/12.
//  Copyright © 2017年 FusionHK. All rights reserved.
//

#import "loginRegModel.h"

@implementation loginRegModel

-(NSString*)phoneNumString
{
    if (!_phoneNumString) {
        _phoneNumString=[[NSString alloc]init];
    }
    return _phoneNumString;
}
-(NSString*)passWordStrinf
{
    if (!_passWordStrinf) {
        _passWordStrinf=[[NSString alloc]init];
    }
    return _passWordStrinf;
}

-(NSString*)yanZhengString
{
    if (!_yanZhengString) {
        _yanZhengString=[[NSString alloc]init];
    }
    return _yanZhengString;
}

-(NSString*)inviteString
{
    if (!_inviteString) {
        _inviteString=[[NSString alloc]init];
    }
    return _inviteString;
}



@end
