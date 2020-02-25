//
//  LGXLayoutMaker.h
//  Masonry iOS Examples
//
//  Created by iCash on 2017/7/11.
//  Copyright © 2017年 Jonas Budelmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGXConstraint.h"

@interface LGXLayoutMaker : NSObject

- (LGXLayoutMaker *)initWithView:(UIView *)view;
@property (nonatomic, strong, readonly) UIView *view;

#pragma mark - 操作
- (NSArray *)install;
- (NSArray *)update;
- (NSArray *)remake;

#pragma mark - 属性
#pragma mark - 位置属性

/** = = = 顶部属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* top __deprecated_msg("use topEdge");
@property (nonatomic, strong, readonly) LGXConstraint* topEdge;
@property (nonatomic, strong, readonly) LGXConstraint* topCenter;

/** = = = 左边属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* left __deprecated_msg("use leftEdge");
@property (nonatomic, strong, readonly) LGXConstraint* leftEdge;
@property (nonatomic, strong, readonly) LGXConstraint* leftTop;
@property (nonatomic, strong, readonly) LGXConstraint* leftCenter;
@property (nonatomic, strong, readonly) LGXConstraint* leftBottom;

/** = = = 底部属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* bottom __deprecated_msg("use bottomEdge");
@property (nonatomic, strong, readonly) LGXConstraint* bottomEdge;
@property (nonatomic, strong, readonly) LGXConstraint* bottomCenter;

/** = = = 右边属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* right __deprecated_msg("use rightEdge");
@property (nonatomic, strong, readonly) LGXConstraint* rightEdge;
@property (nonatomic, strong, readonly) LGXConstraint* rightTop;
@property (nonatomic, strong, readonly) LGXConstraint* rightCenter;
@property (nonatomic, strong, readonly) LGXConstraint* rightBottom;

/** = = = 中心属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* center __deprecated_msg("use allCenter");
@property (nonatomic, strong, readonly) LGXConstraint* allCenter;
@property (nonatomic, strong, readonly) LGXConstraint* xCenter;
@property (nonatomic, strong, readonly) LGXConstraint* yCenter;

#pragma mark - 尺寸属性

/** = = = 尺寸属性 = = = */
/** size 使用 LGXConstraint 的sizeOffset设置*/
@property (nonatomic, strong, readonly) LGXConstraint* size;
@property (nonatomic, strong, readonly) LGXConstraint* width;
@property (nonatomic, strong, readonly) LGXConstraint* height;

#pragma mark - 基线类
@property (nonatomic, strong, readonly) LGXConstraint *baseline;
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) LGXConstraint *firstBaseline;
@property (nonatomic, strong, readonly) LGXConstraint *lastBaseline;

#endif


@end
