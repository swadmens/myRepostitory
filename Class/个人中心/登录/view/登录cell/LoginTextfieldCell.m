//
//  LoginTextfieldCell.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/19.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "LoginTextfieldCell.h"
#import "LGXButton.h"

@interface  LoginTextfieldCell()<UITextFieldDelegate>

@property(nonatomic,strong) UIImageView *iconImageView;//名称
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) UIButton *codeButton;

@end

@implementation LoginTextfieldCell
-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = kColorBackgroundColor;
    
   
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView topToView:self.contentView withSpace:15];
    [_iconImageView bottomToView:self.contentView withSpace:15];
    [_iconImageView leftToView:self.contentView withSpace:25];
    [_iconImageView addWidth:18];
    

    _textField=[UITextField new];
    _textField.textColor=kColorMainTextColor;
    _textField.font=[UIFont customFontWithSize:kFontSizeFifty];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:_textField];
    [_textField addHeight:40];
    [_textField yCenterToView:self.contentView];
    [_textField leftToView:_iconImageView withSpace:15];
    [_textField rightToView:self.contentView withSpace:15];
    [_textField addTarget:self action:@selector(contentDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    self.codeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.codeButton.hidden = YES;
    self.codeButton.clipsToBounds=YES;
    self.codeButton.layer.borderColor=kColorMainColor.CGColor;
    self.codeButton.layer.borderWidth=1.0f;
    self.codeButton.layer.cornerRadius=4;
    [self.codeButton setTitle:NSLocalizedString(@"sendedCode", nil) forState:UIControlStateNormal];
    [self.codeButton setTitleColor:kColorMainColor forState:UIControlStateNormal];
    self.codeButton.titleLabel.font=[UIFont customFontWithSize:kFontSizeThirteen];
    [self.codeButton addTarget:self action:@selector(sendCodeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.codeButton];
    [self.codeButton addHeight:30];
    [self.codeButton addWidth:80];
    [self.codeButton lgx_makeConstraints:^(LGXLayoutMaker *make) {
        make.rightEdge.lgx_equalTo(self.contentView.lgx_rightEdge).lgx_floatOffset(-15);
        make.yCenter.lgx_equalTo(self.contentView.lgx_yCenter);
    }];
    
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor=kColorLineColor;
    [self.contentView addSubview:lineLabel];
    [lineLabel bottomToView:self.contentView];
    [lineLabel leftToView:self.contentView withSpace:25];
    [lineLabel rightToView:self.contentView withSpace:25];
    [lineLabel addHeight:1];
    
    
}
-(void)makeCellData:(NSString*)icon withPlace:(NSString*)placeholder withTag:(NSInteger)tag withStyle:(NSString*)style
{
    _iconImageView.image = UIImageWithFileName(icon);
    _textField.tag = tag;
    _textField.placeholder = placeholder;
    
    
    if (tag == 1 && ![style isEqualToString:@"emailLogin"]) {
        _textField.text = _kUserModel.loginAcount;
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }

    if (tag == 2 && [style isEqualToString:@"login"]){
        _textField.secureTextEntry = YES;
        _textField.text = nil;
    }
    
    if (tag == 2  && ![style isEqualToString:@"login"]) {
        self.codeButton.hidden = NO;
        _textField.secureTextEntry = NO;
        _textField.clearButtonMode = UITextFieldViewModeNever;
        _textField.text = nil;
    }else{
        self.codeButton.hidden = YES;
    }
    
    if ([style isEqualToString:@"startSendCode"]) {
        self.codeButton.userInteractionEnabled = NO;
        [self startTimer:YES];
    }else{
        self.codeButton.userInteractionEnabled = YES;
    }
    
    if ([style isEqualToString:@"stopSendCode"]) {
        [self startTimer:NO];
    }
    
    if ([style isEqualToString:@"emailLogin"]) {
        if (tag == 0) {
            _textField.text = _kUserModel.userInfo.email;
            _textField.delegate = nil;
            _textField.keyboardType = UIKeyboardTypeDefault;
        }else{
            _textField.secureTextEntry = YES;
            _textField.text = nil;
        }
    }
    
    
}
- (void)setupConfirmEyeButton:(NSInteger)textTag
{
    if (textTag != 2) {
        return;
    }
    UIImage *eyeIcon = UIImageWithFileName(@"icon_yan");
    CGFloat space = 15;
    
    LGXButton *eyeButton = [LGXButton buttonWithType:UIButtonTypeCustom];
    eyeButton.useAlphaWhenHighlighted = YES;
    [eyeButton setImage:eyeIcon forState:UIControlStateNormal];
    [eyeButton setImage:UIImageWithFileName(@"icon_yan") forState:UIControlStateSelected];
    
    [eyeButton setTitle:@"" forState:UIControlStateNormal];
    eyeButton.contentMode = UIViewContentModeCenter;
    CGRect eyeFrame = eyeButton.frame;
    eyeFrame.size = eyeIcon.size;
    eyeFrame.size.width = eyeFrame.size.width + space*2;
    eyeButton.frame = eyeFrame;
    
    _textField.rightView = eyeButton;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    
    [eyeButton addTarget:self action:@selector(confirmeyeTwoClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)confirmeyeTwoClicked:(LGXButton *)sender
{
    _textField.secureTextEntry = !_textField.secureTextEntry;
    sender.selected = !_textField.secureTextEntry;;
    NSString *tempString = _textField.text;
    _textField.text = @"";
    _textField.text = tempString;
}
- (void)contentDidChanged:(UITextField*)sender {
    
    if (self.textFieldLogin) {
        self.textFieldLogin(sender.text);
    }
}
-(void)sendCodeClick
{
    if (self.sendCodeButton) {
        self.sendCodeButton();
    }
}
- (void)startTimer:(BOOL)open
{
    __block int timeout = 60; //倒计时时间
    if (open == NO) {
        timeout = 0;
        [self.codeButton setTitle:NSLocalizedString(@"sendedCode", nil) forState:UIControlStateNormal];
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:NSLocalizedString(@"sendAgain", nil) forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;

            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *startTime = [NSString stringWithFormat:@"%@s", strTime];
                [self.codeButton setTitle:startTime forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = NO;

                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
@end
