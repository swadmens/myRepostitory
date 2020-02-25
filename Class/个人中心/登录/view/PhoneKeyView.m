//
//  PhoneKeyView.m
//  TaoChongYouPin
//
//  Created by 汪伟 on 2017/8/21.
//  Copyright © 2017年 FusionHK. All rights reserved.
//

#import "PhoneKeyView.h"
#import "LGXButton.h"

@implementation PhoneKeyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView
{
 
    self.backgroundColor=[UIColor whiteColor];
    
    CGFloat space =15;
    CGFloat widthSpace = 75;
    
    self.phoneLabel=[UILabel new];
    self.phoneLabel.textColor=kColorMainTextColor;
    self.phoneLabel.font=[UIFont customFontWithSize:kFontSizeSixteen];
    [self addSubview:self.phoneLabel];
//    [self.phoneLabel addRightLineByColor:kColorLineColor];
    [self.phoneLabel addWidth:widthSpace];
    [self.phoneLabel lgx_makeConstraints:^(LGXLayoutMaker *make) {
        make.leftEdge.lgx_equalTo(self.lgx_leftEdge).lgx_floatOffset(space);
        make.yCenter.lgx_equalTo(self.lgx_topEdge).lgx_floatOffset(25);
    }];
    
   

    UILabel *midLine=[UILabel new];
    midLine.backgroundColor=kColorLineColor;
    [self addSubview:midLine];
    [midLine addHeight:0.5];
    [midLine lgx_makeConstraints:^(LGXLayoutMaker *make) {
        make.yCenter.lgx_equalTo(self.lgx_yCenter);
        make.leftEdge.lgx_equalTo(self.lgx_leftEdge);
        make.width.lgx_equalTo(self.lgx_width);
    }];

    
    self.keyLabel=[UILabel new];
    self.keyLabel.textColor=kColorMainTextColor;
    self.keyLabel.font=[UIFont customFontWithSize:kFontSizeSixteen];
    [self addSubview:self.keyLabel];
//    [self.keyLabel addRightLineByColor:kColorLineColor];
    [self.keyLabel addWidth:widthSpace];
    [self.keyLabel lgx_makeConstraints:^(LGXLayoutMaker *make) {
        make.leftEdge.lgx_equalTo(self.phoneLabel.lgx_leftEdge);
        make.yCenter.lgx_equalTo(self.lgx_bottomEdge).lgx_floatOffset(-25);
    }];
   
    
    self.keyTextField=[UITextField new];
    self.keyTextField.textColor=kColorMainTextColor;
    self.keyTextField.text=@"";
    self.keyTextField.font=[UIFont customFontWithSize:kFontSizeSixteen];
    [self addSubview:self.keyTextField];
    [self.keyTextField addHeight:40];
    [self.keyTextField lgx_makeConstraints:^(LGXLayoutMaker *make) {
        make.leftEdge.lgx_equalTo(self.keyLabel.lgx_rightEdge).lgx_floatOffset(12);
        make.yCenter.lgx_equalTo(self.keyLabel.lgx_yCenter);
        make.width.lgx_equalTo(self.lgx_width).lgx_floatOffset(-90);
    }];
    
    
    self.phoneTextField=[UITextField new];
    self.phoneTextField.textColor=kColorMainTextColor;
    self.phoneTextField.text=@"";
    self.phoneTextField.font=[UIFont customFontWithSize:kFontSizeSixteen];
    [self addSubview:self.phoneTextField];
    [self.phoneTextField addHeight:40];
    [self.phoneTextField lgx_makeConstraints:^(LGXLayoutMaker *make) {
        make.leftEdge.lgx_equalTo(self.keyTextField.lgx_leftEdge);
        make.yCenter.lgx_equalTo(self.phoneLabel.lgx_yCenter);
        make.width.lgx_equalTo(self.keyTextField.lgx_width);
    }];

    
    
    self.yanButton=[LGXButton buttonWithType:UIButtonTypeCustom];
    self.yanButton.clipsToBounds=YES;
    self.yanButton.layer.borderColor=kColorMainColor.CGColor;
    self.yanButton.layer.borderWidth=1.0f;
    self.yanButton.layer.cornerRadius=4;
    [self.yanButton setTitle:NSLocalizedString(@"sendedCode", nil) forState:UIControlStateNormal];
    [self.yanButton setTitleColor:kColorMainColor forState:UIControlStateNormal];
    self.yanButton.titleLabel.font=[UIFont customFontWithSize:kFontSizeThirteen];
    [self addSubview:self.yanButton];
    [self.yanButton addHeight:30];
    [self.yanButton addWidth:80];
    [self.yanButton lgx_makeConstraints:^(LGXLayoutMaker *make) {
        make.rightEdge.lgx_equalTo(self.lgx_rightEdge).lgx_floatOffset(-15);
        make.yCenter.lgx_equalTo(self.keyLabel.lgx_yCenter);
    }];

    self.verTwoLine=[UILabel new];
    self.verTwoLine.hidden=YES;
    self.verTwoLine.backgroundColor=UIColorFromRGB(0xe0e0e0, 1);
    [self addSubview:self.verTwoLine];
    [self.verTwoLine addWidth:1];
    [self.verTwoLine addHeight:22];
    [self.verTwoLine lgx_makeConstraints:^(LGXLayoutMaker *make) {
        make.yCenter.lgx_equalTo(self.keyLabel.lgx_yCenter);
        make.rightEdge.lgx_equalTo(self.yanButton.lgx_leftEdge);
    }];

}

@end
