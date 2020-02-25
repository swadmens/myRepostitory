//
//  HikUtils.h
//  HikVideoPlayer_Example
//
//  Created by lifeng on 2019/12/26.
//  Copyright © 2019 wangchuanyin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HikUtils : NSObject

+ (void)convertPlayViewRect:(CGRect)rect toSpecificRect:(CGRect *)specificRect zoomScale:(CGFloat)zoomScale touchPoint:(CGPoint)touchPoint;

+ (void)rectIntersectionBetweenRect:(CGRect)rect specificRect:(CGRect *)specificRect;

@end

NS_ASSUME_NONNULL_END
