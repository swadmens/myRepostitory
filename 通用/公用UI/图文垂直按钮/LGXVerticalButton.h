//
//
//
//  Created by icash on 15-8-17.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGXVerticalButton : UIButton
/// 两者之间的偏移，默认是4.0
@property (nonatomic) CGFloat offsetBetweenImageAndTitle;

#pragma mark - 徽标
- (void)showBadgeViewOnImageView;
@property (nonatomic, strong) NSString *badgeValue;
@end
