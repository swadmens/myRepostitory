//
//  TwoLineLabelView.h
//  TaoChongYouPin
//
//  Created by icash on 16/8/19.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoLineLabelView : UIControl

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
/// 两者之间的偏移，默认是4.0
@property (nonatomic) CGFloat offsetBetweenImageAndTitle;

///
- (void)setBGColor:(UIColor *)color forState:(UIControlState)state;

@end
