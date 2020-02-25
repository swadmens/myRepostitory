//
//  LGXConstraint.h
//  LGXLayout
//
//  Created by icash on 2017/6/22.
//  Copyright © 2017年 iCash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGXALUtilities.h"

@interface LGXConstraint : NSObject

- (id)initWithView:(UIView *)view byAttribute:(LGXAttribute)attribute;
@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, assign, readonly) LGXAttribute layoutAttribute;


#pragma mark - 操作
/// id = MASConstraintMaker *
- (void)installBy:(id)make;

#pragma mark - 值的获取/设定
- (LGXConstraint * (^)(CGFloat offset))lgx_offset __deprecated_msg("use lgx_floatOffset");
/// 偏移 NSLayoutConstraint 的 constant
- (LGXConstraint * (^)(CGFloat offset))lgx_floatOffset;
/// 大小 NSLayoutAttributeWidth, NSLayoutAttributeHeight
- (LGXConstraint * (^)(CGSize offset))lgx_sizeOffset;
/// 位置X，Y轴上的偏移
- (LGXConstraint * (^)(CGPoint offset))lgx_pointOffset;
#pragma mark - 关系

/// 等于
- (LGXConstraint * (^)(id attr))lgx_equalTo;
/// 大于等于
- (LGXConstraint * (^)(id attr))lgx_greaterThanOrEqualTo;
/// 小于等于
- (LGXConstraint * (^)(id attr))lgx_lessThanOrEqualTo;

#pragma mark - 乘数
/// 乘数是多少
- (LGXConstraint * (^)(CGFloat multiplier))multipliedBy;

/// 除以多少，dividedBy传入X，返回 1.0/x
- (LGXConstraint * (^)(CGFloat divider))dividedBy;

#pragma mark - 优先级

/// 优先级的值是多少
- (LGXConstraint * (^)(LGXLayoutPriority priority))priority;

/// 设置值为 LGXLayoutPriorityDefaultLow
- (LGXConstraint * (^)())priorityLow;
/// 设置值为 LGXLayoutPriorityDefaultMedium
- (LGXConstraint * (^)())priorityMedium;
/// 设置值为 LGXLayoutPriorityDefaultHigh
- (LGXConstraint * (^)())priorityHigh;
/// 设置值为 LGXLayoutPriorityMoreThanHigh
- (LGXConstraint * (^)())priorityMoreHigher;

#pragma mark - 自动换算
/// 当当前屏幕宽低于设定的尺寸时，进行自动换算
- (LGXConstraint * (^)(CGFloat width))lgx_autoSizeWhenScreenMuchLower;
/// 当当前屏幕宽大于设定的尺寸时，进行自动换算
- (LGXConstraint * (^)(CGFloat width))lgx_autoSizeWhenScreenMuchHigher;
/// 当设定的尺寸只要不等于当前屏幕宽，就进行自动换算
- (LGXConstraint * (^)(CGFloat width))lgx_autoSizeWhenScreenNotEqual;
/// 不使用自动换算,此为默认值(同时，以上设置项小于等于0时也不会自动换算)
- (LGXConstraint * (^)())lgx_autoSizeChosed;
@end
