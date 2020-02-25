//
//  RetrievePasswordCell.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/21.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "RetrievePasswordCell.h"
#import "LGXButton.h"

@interface  RetrievePasswordCell()<UITextFieldDelegate>

@property(nonatomic,strong) UILabel *nameLabel;//名称
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) UIButton *codeButton;

@end

@implementation RetrievePasswordCell
-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor=kColorMainTextColor;
    _nameLabel.font=[UIFont customFontWithSize:kFontSizeSixteen];
    [_nameLabel sizeToFit];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel yCenterToView:self.contentView];
    [_nameLabel leftToView:self.contentView withSpace:15];
    [_nameLabel addWidth:60];
    
    
    _textField=[UITextField new];
    _textField.textColor=kColorMainTextColor;
    _textField.font=[UIFont customFontWithSize:kFontSizeSixteen];
    [self.contentView addSubview:_textField];
    [_textField addHeight:40];
    [_textField yCenterToView:self.contentView];
    [_textField leftToView:_nameLabel withSpace:10];
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
    
}
-(void)makeCellData:(NSString *)title withPlace:(NSString *)placeholder withTag:(NSInteger)tag withStyle:(NSString*)style
{
    _nameLabel.text = title;
    _textField.tag = tag;
    _textField.placeholder = placeholder;

    if (tag == 2) {
        self.codeButton.hidden = NO;
    }else if (tag == 3){
        _textField.secureTextEntry = YES;
        [self setupConfirmEyeButton:3];
    }
    
    if ([style isEqualToString:@"startSendCode"]) {
        self.codeButton.userInteractionEnabled = NO;
        [self startTimer];
    }else{
        self.codeButton.userInteractionEnabled = YES;
    }
}
- (void)contentDidChanged:(UITextField*)sender {
    
    if (self.textFieldText) {
        self.textFieldText(sender.text);
    }
}
-(void)sendCodeClick
{
    if (self.sendCodeButton) {
        self.sendCodeButton();
    }
}
- (void)startTimer
{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:NSLocalizedString(@"sendAgain", nil) forState:UIControlStateNormal];
                
            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *startTime = [NSString stringWithFormat:@"%@s", strTime];
                [self.codeButton setTitle:startTime forState:UIControlStateNormal];
                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
}
- (void)setupConfirmEyeButton:(NSInteger)textTag
{
    if (textTag != 3) {
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
@end
