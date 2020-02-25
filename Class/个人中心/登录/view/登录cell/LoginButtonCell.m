//
//  LoginButtonCell.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/19.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "LoginButtonCell.h"


@interface LoginButtonCell()

@property (nonatomic,strong) UIButton *loginButton;

@end

@implementation LoginButtonCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    
    _loginButton = [UIButton new];
    [_loginButton setBackgroundImage:UIImageWithFileName(@"add_pet_save_button") forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    _loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_loginButton addTarget:self action:@selector(upLoadDataButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_loginButton];
    [_loginButton topToView:self.contentView withSpace:30];
    [_loginButton leftToView:self.contentView withSpace:25];
    [_loginButton rightToView:self.contentView withSpace:25];
    [_loginButton bottomToView:self.contentView];
    [_loginButton addHeight:48];
    
}
-(void)upLoadDataButtonClick
{
    if (_loginButtonClick) {
        self.loginButtonClick();
    }
}
-(void)makeCellData:(NSString*)title
{
    [_loginButton setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];

}


@end
