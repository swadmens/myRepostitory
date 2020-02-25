//
//  PhoneKeyView.h
//  TaoChongYouPin
//
//  Created by 汪伟 on 2017/8/21.
//  Copyright © 2017年 FusionHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneKeyView : UIView

@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong) UILabel *keyLabel;


@property(nonatomic,strong) UITextField *phoneTextField;
@property(nonatomic,strong) UITextField *keyTextField;


@property(nonatomic,strong) UILabel *verTwoLine;

@property(nonatomic,strong) UIButton *yanButton;


@end
