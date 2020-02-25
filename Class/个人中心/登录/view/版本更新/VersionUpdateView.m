//
//  VersionUpdateView.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/7/26.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "VersionUpdateView.h"

@implementation VersionUpdateView
#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化子视图
        [self initSubview];
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)initSubview
{
    UIImage *image = UIImageWithFileName(@"version_update_image");
    CGSize imageSize = image.size;
    UIImageView *topImage = [UIImageView new];
    topImage.image = image;
    [self addSubview:topImage];
    [topImage alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self];
    [topImage addWidth:imageSize.width];
    [topImage addHeight:imageSize.height];
    
    
    UIView *view1=[UIView new];
    view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:view1];
    [view1 alignTop:nil leading:@"0" bottom:@"-5" trailing:@"0" toView:self];
    [view1 addHeight:self.bounds.size.height - imageSize.height + 5];
    
    
    UILabel *vuLabel = [UILabel new];
    vuLabel.text = NSLocalizedString(@"bbgx", nil);
    vuLabel.textColor = kColorMainTextColor;
    vuLabel.font = [UIFont customFontWithSize:20];
    [vuLabel sizeToFit];
    [view1 addSubview:vuLabel];
    [vuLabel xCenterToView:view1];
    [vuLabel topToView:view1 withSpace:15];
    
    
    _expireLabel = [UILabel new];
    _expireLabel.textColor = kColorSecondTextColor;
    _expireLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    _expireLabel.numberOfLines = 0;
    [view1 addSubview:_expireLabel];
    [_expireLabel topToView:vuLabel withSpace:20];
    [_expireLabel xCenterToView:view1];
    [_expireLabel addWidth:imageSize.width - 30];
    

    
    self.btnView = [UIView new];
    self.btnView.backgroundColor = [UIColor whiteColor];
    [self.btnView addTopLineByColor:kColorLineColor];
    [view1 addSubview:self.btnView];
    [self.btnView alignTop:nil leading:@"0" bottom:@"-5" trailing:@"0" toView:view1];
    [self.btnView addHeight:53];
    
    
    UIButton *noUpdateBtn = [UIButton new];
    [noUpdateBtn addRightLineByColor:kColorLineColor];
    [noUpdateBtn setTitle:NSLocalizedString(@"jump", nil) forState:UIControlStateNormal];
    [noUpdateBtn setTitleColor:kColorMainViceTextColor forState:UIControlStateNormal];
    noUpdateBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    [noUpdateBtn addTarget:self action:@selector(noNeedUpdateClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:noUpdateBtn];
    [noUpdateBtn alignTop:@"0" leading:@"0" bottom:@"0" trailing:nil toView:self.btnView];
    [noUpdateBtn addWidth:imageSize.width/2];
    
    
    
    UIButton *needUpdateBtn = [UIButton new];
    [needUpdateBtn setTitle:NSLocalizedString(@"goUpdate", nil) forState:UIControlStateNormal];
    [needUpdateBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    needUpdateBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    [needUpdateBtn addTarget:self action:@selector(needUpdateClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:needUpdateBtn];
    [needUpdateBtn alignTop:@"0" leading:nil bottom:@"0" trailing:@"0" toView:self.btnView];
    [needUpdateBtn addWidth:imageSize.width/2];
    
    
    
    
    _updateBtn = [UIButton new];
    [_updateBtn addTopLineByColor:kColorLineColor];
    [_updateBtn setTitle:NSLocalizedString(@"goUpdate", nil) forState:UIControlStateNormal];
    [_updateBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    _updateBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    [_updateBtn addTarget:self action:@selector(needUpdateClick) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:_updateBtn];
    [_updateBtn alignTop:nil leading:@"0" bottom:@"-5" trailing:@"0" toView:view1];
    [_updateBtn addHeight:53];
    
     
}
- (void)noNeedUpdateClick {
    
    if (self.closeBackCoverButton) {
        self.closeBackCoverButton();
    }
}
-(void)needUpdateClick
{
    if (self.reviceBounsButton) {
        self.reviceBounsButton();
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
