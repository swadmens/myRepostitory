//
//  LoginChooseCountriesCell.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/19.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "LoginChooseCountriesCell.h"

@interface  LoginChooseCountriesCell()

@property(nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *lineLabel;
@end

@implementation LoginChooseCountriesCell
-(void)dosetup
{
    [super dosetup];
    
    
    _titleLabel=[UILabel new];
    _titleLabel.textColor=kColorMainTextColor;
    _titleLabel.font=[UIFont customFontWithSize:kFontSizeFifty];
    [_titleLabel sizeToFit];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel yCenterToView:self.contentView];
    [_titleLabel leftToView:self.contentView withSpace:23];
    [_titleLabel topToView:self.contentView withSpace:15];
    [_titleLabel bottomToView:self.contentView withSpace:15];
    
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightImageView.image = UIImageWithFileName(@"chevron-right-12");
    [self.contentView addSubview:rightImageView];
    [rightImageView yCenterToView:self.contentView];
    [rightImageView rightToView:self.contentView withSpace:25];
    
    
    _lineLabel = [UILabel new];
    _lineLabel.backgroundColor=kColorLineColor;
    [self.contentView addSubview:_lineLabel];
    [_lineLabel bottomToView:self.contentView];
    [_lineLabel leftToView:self.contentView withSpace:25];
    [_lineLabel rightToView:self.contentView withSpace:25];
    [_lineLabel addHeight:1];

}
-(void)makeCellData:(NSString*)title withBackColor:(UIColor*)color withLineHide:(BOOL)hide
{
    self.contentView.backgroundColor = color;

    _titleLabel.text = title;
    _lineLabel.hidden = hide;

}

@end
