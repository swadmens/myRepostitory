//
//  RefreshLeftView.h
//  UIBezierPath和CAShapeLayer画图
//
//  Created by icash on 16/5/19.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshLeftView : UIView

/**
 * 外部传进来的偏移
 * 当偏移等于这个界面的高时，绘制完，并填充颜色
 */
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat triggerHeight;
@end

/*
//// General Declarations
CGContextRef context = UIGraphicsGetCurrentContext();


//// Image Declarations
UIImage* image2 = [UIImage imageNamed: @"image2.png"];
UIImage* image3 = [UIImage imageNamed: @"image3.png"];

//// 丫丫.psd Group
{
    //// Graphic 矢量智能对象 2 Drawing
    UIBezierPath* graphic2Path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 62, 57)];
    CGContextSaveGState(context);
    [graphic2Path addClip];
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawTiledImage(context, CGRectMake(0, 0, image2.size.width, image2.size.height), image2.CGImage);
    CGContextRestoreGState(context);
    
    
    //// Graphic 矢量智能对象 3 Drawing
    UIBezierPath* graphic3Path = [UIBezierPath bezierPathWithRect: CGRectMake(63, 0, 62, 57)];
    CGContextSaveGState(context);
    [graphic3Path addClip];
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawTiledImage(context, CGRectMake(63, 0, image3.size.width, image3.size.height), image3.CGImage);
    CGContextRestoreGState(context);
}
*/