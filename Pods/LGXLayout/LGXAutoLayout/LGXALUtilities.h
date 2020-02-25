//
//  LGXALUtilities.h
//  LGXAutoLayout
//
//  Created by icash on 2017/6/22.
//  Copyright © 2017年 iCash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef UILayoutPriority LGXLayoutPriority;
static const LGXLayoutPriority LGXLayoutPriorityRequired = UILayoutPriorityRequired; // 1000
static const LGXLayoutPriority LGXLayoutPriorityMoreThanHigh = 752; // 750
static const LGXLayoutPriority LGXLayoutPriorityDefaultHigh = UILayoutPriorityDefaultHigh; // 750
static const LGXLayoutPriority LGXLayoutPriorityDefaultMedium = 500; // 中间
static const LGXLayoutPriority LGXLayoutPriorityDefaultLow = UILayoutPriorityDefaultLow; // 250
static const LGXLayoutPriority LGXLayoutPriorityFittingSizeLevel = UILayoutPriorityFittingSizeLevel; // 50

/** 等式 */
/* LGXSize */
typedef struct LGXEdgeInsets {
    
    __unsafe_unretained NSNumber *top;
    __unsafe_unretained NSNumber *left;
    __unsafe_unretained NSNumber *bottom;
    __unsafe_unretained NSNumber *right;
    
}LGXEdgeInsets;

static inline LGXEdgeInsets LGXEdgeInsetsMake(NSNumber *top, NSNumber *left ,NSNumber *bottom, NSNumber *right) {
    LGXEdgeInsets insets = {top,left,bottom,right};
    return insets;
}
#define LGXEdgeInsetsZero LGXEdgeInsetsMake(@0,@0,@0,@0)


#define _baseMultiple 100

/// 一条边有3个位置，4条边一共 12个位置的定义
typedef enum : NSUInteger {
    
    LGXPostionTopLeft = NSLayoutAttributeTop*_baseMultiple+NSLayoutAttributeLeft,        // 上边界居左
    LGXPostionTopCenter = NSLayoutAttributeTop*_baseMultiple+NSLayoutAttributeCenterX,      // 上边界居中
    LGXPostionTopRight = NSLayoutAttributeTop*_baseMultiple+NSLayoutAttributeRight,       // 上边界居右
    
    LGXPostionLeftTop = NSLayoutAttributeLeft*_baseMultiple+NSLayoutAttributeTop,        // 左边界居上
    LGXPostionLeftCenter = NSLayoutAttributeLeft*_baseMultiple+NSLayoutAttributeCenterY,     // 左边界居中
    LGXPostionLeftBottom = NSLayoutAttributeLeft*_baseMultiple+NSLayoutAttributeBottom,     // 左边界居下
    
    LGXPostionBottomLeft = NSLayoutAttributeBottom*_baseMultiple+NSLayoutAttributeLeft,     // 下边界居左
    LGXPostionBottomCenter = NSLayoutAttributeBottom*_baseMultiple+NSLayoutAttributeCenterX,   // 下边界居中
    LGXPostionBottomRight = NSLayoutAttributeBottom*_baseMultiple+NSLayoutAttributeRight,    // 下边界居右
    
    LGXPostionRightTop = NSLayoutAttributeRight*_baseMultiple+NSLayoutAttributeTop,       // 右边界居上
    LGXPostionRightCenter = NSLayoutAttributeRight*_baseMultiple+NSLayoutAttributeCenterY,    // 右边界居中
    LGXPostionRightBottom = NSLayoutAttributeRight*_baseMultiple+NSLayoutAttributeBottom,    // 右边界居下
    
} LGXPostionType;

/** view四条边的定义*/
typedef enum : NSUInteger {
    LGXEdgeTop = NSLayoutAttributeTop,        /// 上边界
    LGXEdgeLeft = NSLayoutAttributeLeft,       // 左边界
    LGXEdgeBottom = NSLayoutAttributeBottom,     // 下边界
    LGXEdgeRight = NSLayoutAttributeRight,      // 右边界
}LGXEdgeType;


/** 宽高属性 */
typedef NS_ENUM(NSInteger, LGXDimension) {
    /** 宽属性 */
    LGXDimensionNone = NSLayoutAttributeNotAnAttribute,
    /** 宽属性 */
    LGXDimensionWidth = NSLayoutAttributeWidth,
    /** 高属性 */
    LGXDimensionHeight = NSLayoutAttributeHeight,
    /** size属性 */
    LGXDimensionSize = NSLayoutAttributeWidth*_baseMultiple+NSLayoutAttributeHeight,
};

/** 等式 */
typedef NS_ENUM(NSInteger, LGXRelation){
    LGXLessThan = NSLayoutRelationLessThanOrEqual,
    LGXEqualTo = NSLayoutRelationEqual,
    LGXGreaterThan = NSLayoutRelationGreaterThanOrEqual,
};
/** 轴方向 */
typedef NS_ENUM(NSInteger, LGXAxis){
    /** 中心点 */
    LGXAxisCenter = NSLayoutAttributeCenterX*_baseMultiple+NSLayoutAttributeCenterY,
    /** x轴 */
    LGXAxisHorizontal = NSLayoutAttributeCenterY,
    /** y轴 */
    LGXAxisVertical = NSLayoutAttributeCenterX,
};

/** 属性的集合 */
typedef NS_ENUM(NSInteger, LGXAttribute) {
    /** 左边界 */
    LGXAttributeLeft = LGXEdgeLeft,
    /** 右边界 */
    LGXAttributeRight = LGXEdgeRight,
    /** 上边界 */
    LGXAttributeTop = LGXEdgeTop,
    /** 下边界 */
    LGXAttributeBottom = LGXEdgeBottom,
    /** view的宽 */
    LGXAttributeWidth = LGXDimensionWidth,
    /** view的高 */
    LGXAttributeHeight = LGXDimensionHeight,
    /** size属性 */
    LGXAttributeSize = LGXDimensionSize,
    /** 中心点 */
    LGXAttributeCenter = LGXAxisCenter,
    /** 纵轴，从左到右的中心轴 */
    LGXAttributeCenterX = LGXAxisVertical,
    /** 横轴，从上到下的中心轴 */
    LGXAttributeCenterY = LGXAxisHorizontal,
    /** 文字的baseline */
    LGXAttributeBaseline = NSLayoutAttributeBaseline,
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    LGXAttributeFirstBaseline = NSLayoutAttributeFirstBaseline,
    LGXAttributeLastBaseline = NSLayoutAttributeLastBaseline,
 
#endif
    /** 什么都不是 */
    LGXAttributeNotAnAttribute = NSLayoutAttributeNotAnAttribute,
    
    /* 自定义的几个 */
    LGXAttributeTopLeft = LGXPostionTopLeft,        // 上边界居左
    LGXAttributeTopCenter = LGXPostionTopCenter,      // 上边界居中
    LGXAttributeTopRight = LGXPostionTopRight,       // 上边界居右
    
    LGXAttributeLeftTop = LGXPostionLeftTop,        // 左边界居上
    LGXAttributeLeftCenter = LGXPostionLeftCenter,     // 左边界居中
    LGXAttributeLeftBottom = LGXPostionLeftBottom,     // 左边界居下
    
    LGXAttributeBottomLeft = LGXPostionBottomLeft,     // 下边界居左
    LGXAttributeBottomCenter = LGXPostionBottomCenter,   // 下边界居中
    LGXAttributeBottomRight = LGXPostionBottomRight,    // 下边界居右
    
    LGXAttributeRightTop = LGXPostionRightTop,       // 右边界居上
    LGXAttributeRightCenter = LGXPostionRightCenter,    // 右边界居中
    LGXAttributeRightBottom = LGXPostionRightBottom,    // 右边界居下
    
};
