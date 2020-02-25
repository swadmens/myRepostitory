//
//  CountryAreaCodeCell.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/21.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "CountryAreaCodeCell.h"

@interface  CountryAreaCodeCell()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *detailLabel;

@end

@implementation CountryAreaCodeCell
-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor=[UIColor whiteColor];
    
    _titleLabel=[UILabel new];
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font=[UIFont customFontWithSize:kFontSizeFifty];
    [_titleLabel sizeToFit];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel leftToView:self.contentView withSpace:15];
    [_titleLabel yCenterToView:self.contentView];
    
    
    _detailLabel=[UILabel new];
    _detailLabel.textColor = kColorMainViceTextColor;
    _detailLabel.font=[UIFont customFontWithSize:kFontSizeFifty];
    [_detailLabel sizeToFit];
    [self.contentView addSubview:_detailLabel];
    [_detailLabel rightToView:self.contentView withSpace:45];
    [_detailLabel yCenterToView:self.contentView];

}
-(void)makeTxetData:(NSString*)text withDetail:(NSString*)detail
{
    _titleLabel.text = text;
    _detailLabel.text = detail;
}
@end
