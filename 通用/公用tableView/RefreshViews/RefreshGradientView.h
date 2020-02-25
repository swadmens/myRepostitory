//
//  RefreshGradientView
//  TaoChongYouPin
//
//  Created by icash on 16/11/14.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshGradientView : UIView

/**
 * 外部传进来的偏移
 * 当偏移等于这个界面的高时，绘制完，并填充颜色
 */
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat triggerHeight;

@end
