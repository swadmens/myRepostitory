//
//  LGXConstraint.m
//  LGXLayout
//
//  Created by icash on 2017/6/22.
//  Copyright © 2017年 iCash. All rights reserved.
//

#import "LGXConstraint.h"
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSUInteger, LayoutOffsetType) {
    LayoutOffsetDefault = 0,
    LayoutOffsetSize,
    LayoutOffsetPoint,
};

typedef NS_ENUM(NSInteger, LayoutAutoSizeType) {
    LayoutAutoSizeNone = -99, // 不处理
    LayoutAutoSizeHigher = 1, // 高于
    LayoutAutoSizeBoth = 0, // 两个
    LayoutAutoSizeLower = -1, // 低于
};

@interface LGXConstraint ()

/// 优先级记录
@property (nonatomic, assign) LGXLayoutPriority layoutPriority;
/// 乘数的记录
@property (nonatomic, assign) CGFloat layoutMultiplier;
/// 等式记录
@property (nonatomic, assign) NSLayoutRelation layoutRelation;

/// 第二个view的属性记录
@property (nonatomic, strong) LGXConstraint *secondViewAttribute;

#pragma mark - *属性 - 偏移值的记录
@property (nonatomic) LayoutOffsetType offsetType;
@property (nonatomic, assign) CGSize layoutSizeOffset;
@property (nonatomic, assign) CGFloat layoutOffset;
@property (nonatomic, assign) CGPoint layoutPointOffset;

@property (nonatomic, assign) CGFloat autoSizeWidth; // 用于记录自动换算
@property (nonatomic) LayoutAutoSizeType autoSizeType;

@end

@implementation LGXConstraint

- (id)initWithView:(UIView *)view byAttribute:(LGXAttribute)attribute
{
    self = [super init];
    if (self) {
        // 设置默认值
        self.layoutPriority = LGXLayoutPriorityRequired;
        self.layoutRelation = NSLayoutRelationEqual;
        self.layoutMultiplier = 1;
        self.offsetType = LayoutOffsetDefault;
        self.autoSizeType = LayoutAutoSizeNone;
        self.autoSizeWidth = 0;
        
        _layoutAttribute = attribute;
        _view = view;
    }
    return self;
}
#pragma mark - 操作
- (void)installBy:(MASConstraintMaker *)make
{
    UIView *fromView = self.view;
    NSArray *fromAttributes = [self getLayoutAttributesBy:self.layoutAttribute];
    
    NSArray *toAttributes = nil;
    UIView *toView = self.secondViewAttribute.view;
    if (self.secondViewAttribute) {
        toAttributes = [self getLayoutAttributesBy:self.secondViewAttribute.layoutAttribute];
    }
    [self make:make setupConstraints:fromAttributes inView:fromView toView:toView byConstraint:toAttributes];
}
- (void)make:(MASConstraintMaker *)make
setupConstraints:(NSArray *)fromAttributes inView:(UIView *)fromView
      toView:(UIView *)toView byConstraint:(NSArray *)toAttributes
{
    for (int i =0; i<fromAttributes.count; i++) {
        NSLayoutAttribute oneAttribute = [[fromAttributes objectAtIndex:i] integerValue];
        MASConstraint *mas_left_att = [self getMASConstraintBy:oneAttribute withObject:make];
        MASViewAttribute *mas_right_att = nil;
        if (toView && i<toAttributes.count) {
            NSLayoutAttribute twoAttribute = [[toAttributes objectAtIndex:i] integerValue];
            mas_right_att = [self getMASConstraintBy:twoAttribute withObject:toView];
        }
        // 关系
        if (mas_right_att) {
            if (self.layoutRelation == LGXLessThan) mas_left_att.lessThanOrEqualTo(mas_right_att);
            else if (self.layoutRelation == LGXEqualTo) mas_left_att.equalTo(mas_right_att);
            else if (self.layoutRelation == LGXGreaterThan) mas_left_att.greaterThanOrEqualTo(mas_right_att);
        }
        // 偏移
        if (self.offsetType == LayoutOffsetDefault) mas_left_att.offset([self autoSizeByValue:self.layoutOffset]);
        else if (self.offsetType == LayoutOffsetSize) mas_left_att.sizeOffset([self autoSizeBySize:self.layoutSizeOffset]);
        else if (self.offsetType == LayoutOffsetPoint){
            if (oneAttribute == NSLayoutAttributeCenterX || oneAttribute == NSLayoutAttributeCenterY ||
                oneAttribute == NSLayoutAttributeCenterXWithinMargins || oneAttribute == NSLayoutAttributeCenterYWithinMargins) {
                
                mas_left_att.centerOffset([self autoSizeByPoint:self.layoutPointOffset]); // 这个要独立写
                
            } else if (oneAttribute == NSLayoutAttributeLeft || oneAttribute == NSLayoutAttributeRight) {
                // x轴方向
                mas_left_att.offset([self autoSizeByValue:self.layoutPointOffset.x]);
                
            } else if (oneAttribute == NSLayoutAttributeTop || oneAttribute == NSLayoutAttributeBottom) {
                // y轴方向
                mas_left_att.offset([self autoSizeByValue:self.layoutPointOffset.y]);
            } else {
                // 抛异常
                NSAssert(1, @"lgx_pointOffset属性不支持");
            }
        }
        
        // 乘数 self.layoutMultiplier
        mas_left_att.multipliedBy(self.layoutMultiplier);
        // 优先级
        mas_left_att.priority(self.layoutPriority);
    }
}
/// obj 传入MASConstraintMaker 或 UIView
- (id)getMASConstraintBy:(NSLayoutAttribute)attribute withObject:(id)obj
{
    id returnObject;
    
    MASConstraintMaker *make = nil;
    UIView *toView = nil;
    if ([obj isKindOfClass:[MASConstraintMaker class]]) {
        make = (MASConstraintMaker *)obj;
    } else {
        toView = (UIView *)obj;
    }
    
    if (attribute ==  NSLayoutAttributeLeft) returnObject = make?make.left:toView.mas_left;
    else if (attribute ==  NSLayoutAttributeRight) returnObject = make?make.right:toView.mas_right;
    else if (attribute ==  NSLayoutAttributeTop) returnObject = make?make.top:toView.mas_top;
    else if (attribute ==  NSLayoutAttributeBottom) returnObject = make?make.bottom:toView.mas_bottom;
    else if (attribute ==  NSLayoutAttributeLeading) returnObject = make?make.leading:toView.mas_leading;
    else if (attribute ==  NSLayoutAttributeTrailing) returnObject = make?make.trailing:toView.mas_trailing;
    else if (attribute ==  NSLayoutAttributeWidth) returnObject = make?make.width:toView.mas_width;
    else if (attribute ==  NSLayoutAttributeHeight) returnObject = make?make.height:toView.mas_height;
    else if (attribute ==  NSLayoutAttributeCenterX) returnObject = make?make.centerX:toView.mas_centerX;
    else if (attribute ==  NSLayoutAttributeCenterY) returnObject = make?make.centerY:toView.mas_centerY;
    else if (attribute ==  NSLayoutAttributeBaseline) returnObject = make?make.baseline:toView.mas_baseline;
    
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    else if (attribute ==  NSLayoutAttributeFirstBaseline) returnObject = make?make.firstBaseline:toView.mas_firstBaseline;
    else if (attribute ==  NSLayoutAttributeLastBaseline) returnObject = make?make.lastBaseline:toView.mas_lastBaseline;
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    else if (attribute ==  NSLayoutAttributeLeftMargin) returnObject = make?make.leftMargin:toView.mas_leftMargin;
    else if (attribute ==  NSLayoutAttributeRightMargin) returnObject = make?make.rightMargin:toView.mas_rightMargin;
    else if (attribute ==  NSLayoutAttributeTopMargin) returnObject = make?make.topMargin:toView.mas_topMargin;
    else if (attribute ==  NSLayoutAttributeBottomMargin) returnObject = make?make.bottomMargin:toView.mas_bottomMargin;
    else if (attribute ==  NSLayoutAttributeLeadingMargin) returnObject = make?make.leadingMargin:toView.mas_leadingMargin;
    else if (attribute ==  NSLayoutAttributeTrailingMargin) returnObject = make?make.trailingMargin:toView.mas_trailingMargin;
    else if (attribute ==  NSLayoutAttributeCenterXWithinMargins) returnObject = make?make.centerXWithinMargins:toView.mas_centerXWithinMargins;
    else if (attribute ==  NSLayoutAttributeCenterYWithinMargins) returnObject = make?make.centerYWithinMargins:toView.mas_centerYWithinMargins;
    
#endif

    return returnObject;
}

- (NSArray *)getLayoutAttributesBy:(LGXAttribute)attribute
{
    NSArray *array = nil;
    NSLayoutAttribute baseAtt = attribute / _baseMultiple;
    if (baseAtt >0) {
        NSLayoutAttribute otherAtt = attribute % _baseMultiple;
        if (otherAtt >0) {
            array = @[
                      @(baseAtt),
                      @(otherAtt)
                      ];
        } else {
            array = @[@(baseAtt)];
        }
        
    } else {
        array = @[@(attribute)];
    }
    return array;
}
#pragma mark - autosize 换算
- (CGSize)autoSizeBySize:(CGSize)sizeOffset
{
    return CGSizeMake([self autoSizeByValue:sizeOffset.width], [self autoSizeByValue:sizeOffset.height]);
}
- (CGPoint)autoSizeByPoint:(CGPoint)pointOffset
{
    return CGPointMake([self autoSizeByValue:pointOffset.x], [self autoSizeByValue:pointOffset.y]);
}
- (CGFloat)autoSizeByValue:(CGFloat)valueOffset
{
    if (self.autoSizeType == LayoutAutoSizeNone || self.autoSizeWidth <=0) {
        return valueOffset;
    }
    CGFloat finalValue = valueOffset;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if ((self.autoSizeType == LayoutAutoSizeLower && width < self.autoSizeWidth)    ||  // 屏幕尺寸 低于 设定值
        (self.autoSizeType == LayoutAutoSizeHigher && width > self.autoSizeWidth)   ||  // 屏幕尺寸 高于 设定值
        (self.autoSizeType == LayoutAutoSizeBoth && width != self.autoSizeWidth)        // 屏幕尺寸 不等 设定值
        ) {
        
        finalValue = valueOffset*(width / self.autoSizeWidth);
    }
    
    return finalValue;
}

#pragma mark - 值的设定
- (LGXConstraint * (^)(CGFloat))lgx_offset __deprecated_msg("use lgx_floatOffset")
{
    return self.lgx_floatOffset;
}
/// 偏移
- (LGXConstraint * (^)(CGFloat))lgx_floatOffset
{
    return ^id(CGFloat offset){
        self.offsetType = LayoutOffsetDefault;
        self.layoutOffset = offset;
        return self;
    };
}
/// 大小偏移
- (LGXConstraint * (^)(CGSize))lgx_sizeOffset
{
    return ^id(CGSize offset) {
        self.offsetType = LayoutOffsetSize;
        self.layoutSizeOffset = offset;
        return self;
    };
}
/// 位置偏移
- (LGXConstraint * (^)(CGPoint))lgx_pointOffset
{
    return ^id(CGPoint pointOffset){
        self.offsetType = LayoutOffsetPoint;
        self.layoutPointOffset = pointOffset;
        return self;
    };
}
#pragma mark - 关系
/// 等于
- (LGXConstraint * (^)(id))lgx_equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}
/// 大于等于
- (LGXConstraint * (^)(id))lgx_greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}
/// 小于等于
- (LGXConstraint * (^)(id))lgx_lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}
- (LGXConstraint * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attribute, NSLayoutRelation relation) {
        
        self.layoutRelation = relation;
        self.secondViewAttribute = attribute;
        
        return self;
    };
}
#pragma mark - 乘数
/// 乘数是多少
- (LGXConstraint * (^)(CGFloat))multipliedBy
{
    return ^id(CGFloat multiplier) {
        self.layoutMultiplier = multiplier;
        return self;
    };
}

/// 除以多少，dividedBy传入X，返回 1.0/x
- (LGXConstraint * (^)(CGFloat))dividedBy
{
    return ^id(CGFloat divider) {
        self.layoutMultiplier = 1.0/divider;
        return self;
    };
}

#pragma mark - 优先级
/// 优先级的值是多少
- (LGXConstraint * (^)(LGXLayoutPriority priority))priority
{
    return ^id(LGXLayoutPriority priority) {
        self.layoutPriority = priority;
        return self;
    };
}
/// 设置值为 LGXLayoutPriorityDefaultLow
- (LGXConstraint * (^)())priorityLow
{
    return ^id{
        self.priority(LGXLayoutPriorityDefaultLow);
        return self;
    };
}
/// 设置值为 LGXLayoutPriorityDefaultMedium
- (LGXConstraint * (^)())priorityMedium
{
    return ^id{
        self.priority(LGXLayoutPriorityDefaultMedium);
        return self;
    };
}
/// 设置值为 LGXLayoutPriorityDefaultHigh
- (LGXConstraint * (^)())priorityHigh
{
    return ^id{
        self.priority(LGXLayoutPriorityDefaultHigh);
        return self;
    };
}
/// 设置值为 LGXLayoutPriorityMoreThanHigh
- (LGXConstraint * (^)())priorityMoreHigher
{
    return ^id{
        self.priority(LGXLayoutPriorityMoreThanHigh);
        return self;
    };
}

#pragma mark - 自动换算
- (LGXConstraint *(^)())lgx_autoSizeChosed
{
    return ^id{
        self.autoSizeType = LayoutAutoSizeNone;
        self.autoSizeWidth = 0;
        return self;
    };
}
- (LGXConstraint *(^)(CGFloat))lgx_autoSizeWhenScreenNotEqual
{
    return ^id (CGFloat width){
        self.autoSizeType = LayoutAutoSizeBoth;
        self.autoSizeWidth = width;
        return self;
    };
}
- (LGXConstraint *(^)(CGFloat))lgx_autoSizeWhenScreenMuchHigher
{
    return ^id (CGFloat width){
        self.autoSizeType = LayoutAutoSizeHigher;
        self.autoSizeWidth = width;
        return self;
    };
}
- (LGXConstraint *(^)(CGFloat))lgx_autoSizeWhenScreenMuchLower
{
    return ^id (CGFloat width){
        self.autoSizeType = LayoutAutoSizeLower;
        self.autoSizeWidth = width;
        return self;
    };
}
@end
