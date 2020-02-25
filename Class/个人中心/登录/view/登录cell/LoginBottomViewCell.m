//
//  LoginBottomViewCell.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/19.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "LoginBottomViewCell.h"

@implementation LoginBottomViewCell
-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    
    /// 找回
    UIButton *forgetButton=[UIButton new];
    [forgetButton setTitleColor:kColorMainColor forState:UIControlStateNormal];
    [forgetButton setTitle:NSLocalizedString(@"forgetPassword", nil) forState:UIControlStateNormal];
    forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgetButton addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [self.contentView addSubview:forgetButton];
    [forgetButton topToView:self.contentView withSpace:15];
    [forgetButton rightToView:self.contentView withSpace:25];

   
    
    
    /// 立即注册
    UIButton *registerButton=[UIButton new];
    [registerButton addTarget:self action:@selector(gotoRegisterController) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:NSLocalizedString(@"quickReg", nil) forState:UIControlStateNormal];
    [registerButton setTitleColor:kColorMainColor forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [self.contentView addSubview:registerButton];
    [registerButton yCenterToView:forgetButton];
    [registerButton leftToView:self.contentView withSpace:25];

   
    
    UILabel *label1=[UILabel new];
    label1.text = NSLocalizedString(@"oterWayLogin", nil);
    label1.textColor=kColorMainViceTextColor;
    label1.font=[UIFont customFontWithSize:kFontSizeFifty];
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 sizeToFit];
    [self.contentView addSubview:label1];
    [label1 xCenterToView:self.contentView];
    [label1 topToView:self.contentView withSpace:53];
    
    
    CGFloat laFloat = [WWPublicMethod widthForLabel:label1.text fontSize:[UIFont customFontWithSize:kFontSizeFifty]];
    CGFloat width = kScreenWidth - laFloat - 70;
    
    UILabel *leftLine=[UILabel new];
    leftLine.backgroundColor=kColorLineColor;
    [self.contentView addSubview:leftLine];
    [leftLine addHeight:1];
    [leftLine yCenterToView:label1];
    [leftLine addWidth:width / 2];
    [leftLine leftToView:self.contentView withSpace:25];

    UILabel *rightLine=[UILabel new];
    rightLine.backgroundColor=kColorLineColor;
    [self.contentView addSubview:rightLine];
    [rightLine addHeight:1];
    [rightLine yCenterToView:label1];
    [rightLine rightToView:self.contentView withSpace:25];
    [rightLine addWidth:width / 2];
    
    
    UIButton *qqButton=[UIButton new];
    [qqButton setBackgroundImage:UIImageWithFileName(@"icon_QQ") forState:UIControlStateNormal];
    [qqButton addTarget:self action:@selector(qqLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:qqButton];
    [qqButton topToView:label1 withSpace:20];
    [qqButton xCenterToView:self.contentView];
    [qqButton bottomToView:self.contentView withSpace:30];
    
    
    
    UIButton *wechatButton=[UIButton new];
    [wechatButton setBackgroundImage:UIImageWithFileName(@"icon_WX") forState:UIControlStateNormal];
    [wechatButton addTarget:self action:@selector(wechatLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:wechatButton];
    [wechatButton yCenterToView:qqButton];
    [wechatButton rightToView:qqButton withSpace:75];
    
    
    
    UIButton *sinaButton=[UIButton new];
    [sinaButton setBackgroundImage:UIImageWithFileName(@"icon_WB") forState:UIControlStateNormal];
    [sinaButton addTarget:self action:@selector(SinaWeiboLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sinaButton];
    [sinaButton yCenterToView:qqButton];
    [sinaButton leftToView:qqButton withSpace:75];
    
}
-(void)resetPassword
{
    if (self.forgetButtonClick) {
        self.forgetButtonClick();
    }
}
-(void)gotoRegisterController
{
    if (_registerButtonClick) {
        self.registerButtonClick();
    }
}
-(void)qqLoginButton
{
    if (_qqLoginButtonClick) {
        self.qqLoginButtonClick();
    }
}
-(void)wechatLoginButton
{
    if (_wxLoginButtonClick) {
        self.wxLoginButtonClick();
    }
 
}
-(void)SinaWeiboLoginButton
{
    if (_wbLoginButtonClick) {
        self.wbLoginButtonClick();
    }
}


@end
