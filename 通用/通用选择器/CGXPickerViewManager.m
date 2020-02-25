//
//  CGXPickerViewManager.m
//  CGXPickerView
//
//  Created by 曹贵鑫 on 2018/1/8.
//  Copyright © 2018年 曹贵鑫. All rights reserved.
//

#import "CGXPickerViewManager.h"

@interface CGXPickerViewManager ()

@end
@implementation CGXPickerViewManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _kPickerViewH = 200;
        _kTopViewH = 50;
        _pickerTitleSize  =15;
        _pickerTitleColor = [UIColor blackColor];
        _lineViewColor =CGXPickerRGBColor(225, 225, 225, 1);
        
        _titleLabelColor = CGXPickerRGBColor(252, 96, 134, 1);
        _titleSize = 16;
        _titleLabelBGColor = [UIColor whiteColor];
        
        _rightBtnTitle = NSLocalizedString(@"sure", nil);
        _rightBtnBGColor =  [UIColor whiteColor];
        _rightBtnTitleSize = 16;
        _rightBtnTitleColor = kColorMainTextColor;
        
//        _rightBtnborderColor = [UIColor whiteColor];
//        _rightBtnCornerRadius = 6;
//        _rightBtnBorderWidth = 1;
        
        _leftBtnTitle = NSLocalizedString(@"cancel", nil);
        _leftBtnBGColor =  [UIColor whiteColor];
        _leftBtnTitleSize = 16;
        _leftBtnTitleColor = kColorMainTextColor;
        
//        _leftBtnborderColor = CGXPickerRGBColor(252, 96, 134, 1);
//        _leftBtnCornerRadius = 6;
//        _leftBtnBorderWidth = 1;
        
    }
    return self;
}
@end
