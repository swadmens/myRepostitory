//
//  HikUtils.m
//  HikVideoPlayer_Example
//
//  Created by lifeng on 2019/12/26.
//  Copyright © 2019 wangchuanyin. All rights reserved.
//

#import "HikUtils.h"

@implementation HikUtils

+ (void)convertPlayViewRect:(CGRect)rect toSpecificRect:(CGRect *)specificRect zoomScale:(CGFloat)zoomScale touchPoint:(CGPoint)touchPoint {
    CGFloat originX = CGRectGetMinX(*specificRect);
    CGFloat originY = CGRectGetMinY(*specificRect);
    CGFloat width = CGRectGetWidth(*specificRect);
    CGFloat height = CGRectGetHeight(*specificRect);
    // 1. 计算比例
    CGFloat ratioOfX = ABS(touchPoint.x - originX) / width;
    CGFloat ratioOfY = ABS(touchPoint.y - originY) / height;
    // 2. 设置区域
    CGFloat zoomWidth = rect.size.width * zoomScale;
    CGFloat zoomHeight = rect.size.height * zoomScale;
    CGFloat zoomX = originX - ratioOfX * (zoomWidth - width);
    CGFloat zoomY = originY - ratioOfY * (zoomHeight - height);
    *specificRect = CGRectMake(zoomX, zoomY, zoomWidth, zoomHeight);
}

+ (void)rectIntersectionBetweenRect:(CGRect)rect specificRect:(CGRect *)specificRect {
    CGFloat originalX = CGRectGetMinX(rect);
    CGFloat originalY = CGRectGetMinY(rect);
    CGFloat originalRight = CGRectGetMaxX(rect);
    CGFloat originalBottom = CGRectGetMaxY(rect);
    CGFloat newX = CGRectGetMinX(*specificRect);
    CGFloat newY = CGRectGetMinY(*specificRect);
    CGFloat newRight = CGRectGetMaxX(*specificRect);
    CGFloat newBottom = CGRectGetMaxY(*specificRect);
    CGFloat newWidth = CGRectGetWidth(*specificRect);
    CGFloat newHeight = CGRectGetHeight(*specificRect);
    if (newX > originalX) {
        newX = originalX;
    }
    newRight = newX + newWidth;
    if (newY > originalY) {
        newY = originalY;
    }
    newBottom = newY + newHeight;
    if (newRight < originalRight) {
        newRight = originalRight;
        newX = newRight - newWidth;
    }
    if (newBottom < originalBottom) {
        newBottom = originalBottom;
        newY = newBottom - newHeight;
    }
    specificRect->origin.x = newX;
    specificRect->origin.y = newY;
}


@end
