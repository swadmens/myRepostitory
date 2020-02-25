//
//  LGXLayoutMaker.m
//  Masonry iOS Examples
//
//  Created by iCash on 2017/7/11.
//  Copyright © 2017年 Jonas Budelmann. All rights reserved.
//

#import "LGXLayoutMaker.h"
#import "LGXALUtilities.h"
#import "LGXConstraint.h"
#import <Masonry/View+MASAdditions.h>

@interface LGXLayoutMaker ()

@property (nonatomic, strong) NSMutableArray *constraintsArray;

@end

@implementation LGXLayoutMaker
- (NSMutableArray *)constraintsArray
{
    if (!_constraintsArray) {
        _constraintsArray = [NSMutableArray array];
    }
    return _constraintsArray;
}
- (LGXLayoutMaker *)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _view = view;
    }
    return self;
}
#pragma mark - 操作
- (NSArray *)install
{
    return [self installConstraintsBy:0];
}
- (NSArray *)update
{
    return [self installConstraintsBy:1];
}
- (NSArray *)remake
{
    return [self installConstraintsBy:2];
}

/**
 * operation : 0 install; 1 update; 2 remake;
 */
- (NSArray *)installConstraintsBy:(NSInteger)operation
{
    NSArray *array = nil;
    if (operation == 0) // install
        array = [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            [self didMakeConstraintsBy:make];
        }];
    else if (operation == 1) // update
        array = [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
            [self didMakeConstraintsBy:make];
        }];
    else if (operation == 2) // remake
        array = [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            [self didMakeConstraintsBy:make];
        }];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:array.count];
    for (id masConstraint in array) {
        NSLayoutConstraint *constraint = (NSLayoutConstraint *)[masConstraint valueForKeyPath:@"_layoutConstraint"];
        [tempArray addObject:constraint];
    }
    [self.constraintsArray removeAllObjects];// 移除记录
    
    return [NSArray arrayWithArray:tempArray];
}
- (void)didMakeConstraintsBy:(MASConstraintMaker *)make
{
    for (LGXConstraint *constarint in self.constraintsArray) {
        
        [constarint installBy:make];
    }
}
#pragma mark - 属性
- (LGXConstraint *)addConstraintWithLayoutAttribute:(LGXAttribute)layoutAttribute
{
    LGXConstraint *viewConstraint = [[LGXConstraint alloc] initWithView:self.view byAttribute:layoutAttribute];
    [self.constraintsArray addObject:viewConstraint];
    return viewConstraint;
}
/** = = = 顶部属性 = = = */
- (LGXConstraint *)top {
    return self.topEdge;
}
- (LGXConstraint *)topEdge {
    return [self addConstraintWithLayoutAttribute:LGXAttributeTop];
}
- (LGXConstraint *)topCenter {
    return [self addConstraintWithLayoutAttribute:LGXAttributeTopCenter];
}

/** = = = 左边属性 = = = */
- (LGXConstraint *)left {
    return self.leftEdge;
}
- (LGXConstraint *)leftEdge {
    return [self addConstraintWithLayoutAttribute:LGXAttributeLeft];
}
- (LGXConstraint *)leftTop {
    return [self addConstraintWithLayoutAttribute:LGXAttributeLeftTop];
}
- (LGXConstraint *)leftCenter {
    return [self addConstraintWithLayoutAttribute:LGXAttributeLeftCenter];
}
- (LGXConstraint *)leftBottom {
    return [self addConstraintWithLayoutAttribute:LGXAttributeLeftBottom];
}
/** = = = 底部属性 = = = */
- (LGXConstraint *)bottom {
    return self.bottomEdge;
}
- (LGXConstraint *)bottomEdge {
    return [self addConstraintWithLayoutAttribute:LGXAttributeBottom];
}
- (LGXConstraint *)bottomCenter {
    return [self addConstraintWithLayoutAttribute:LGXAttributeBottomCenter];
}
/** = = = 右边属性 = = = */
- (LGXConstraint *)right {
    return self.rightEdge;
}
- (LGXConstraint *)rightEdge {
    return [self addConstraintWithLayoutAttribute:LGXAttributeRight];
}
- (LGXConstraint *)rightTop {
    return [self addConstraintWithLayoutAttribute:LGXAttributeRightTop];
}
- (LGXConstraint *)rightCenter {
    return [self addConstraintWithLayoutAttribute:LGXAttributeRightCenter];
}
- (LGXConstraint *)rightBottom {
    return [self addConstraintWithLayoutAttribute:LGXAttributeRightBottom];
}

/** = = = 中心属性 = = = */
- (LGXConstraint *)center {
    return self.allCenter;
}
- (LGXConstraint *)allCenter
{
    return [self addConstraintWithLayoutAttribute:LGXAttributeCenter];
}
- (LGXConstraint *)xCenter {
    return [self addConstraintWithLayoutAttribute:LGXAttributeCenterX];
}
- (LGXConstraint *)yCenter {
    return [self addConstraintWithLayoutAttribute:LGXAttributeCenterY];
}

#pragma mark - 尺寸属性

/** = = = 尺寸属性 = = = */
/** size 使用 LGXConstraint 的sizeOffset设置*/
- (LGXConstraint *)size {
    return [self addConstraintWithLayoutAttribute:LGXAttributeSize];
}
- (LGXConstraint *)width {
    return [self addConstraintWithLayoutAttribute:LGXAttributeWidth];
}
- (LGXConstraint *)height {
    return [self addConstraintWithLayoutAttribute:LGXAttributeHeight];
}

#pragma mark - 基线类
- (LGXConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:LGXAttributeBaseline];
}
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
- (LGXConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:LGXAttributeFirstBaseline];
}
- (LGXConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:LGXAttributeLastBaseline];
}

#endif


@end
