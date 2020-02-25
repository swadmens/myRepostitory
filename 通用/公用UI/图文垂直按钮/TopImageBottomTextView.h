//
//  TopImageBottomTextView.h
//  TaoChongYouPin
//
//  Created by icash on 16/8/19.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface TopImageBottomTextView : UIControl

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
/// 两者之间的偏移，默认是0.0
@property (nonatomic) CGFloat offsetBetweenImageAndTitle;

#pragma mark - 徽标
- (void)showBadgeViewOnImageView;
@property (nonatomic, strong) NSString *badgeValue;
@end
