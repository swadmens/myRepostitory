//
//  RefreshRightView.h
//  UIBezierPath和CAShapeLayer画图
//
//  Created by icash on 16/5/19.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshRightView : UIView

/**
 * 外部传进来的偏移
 * 当偏移等于这个界面的高时，绘制完，并填充颜色
 */
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat triggerHeight;

@end
