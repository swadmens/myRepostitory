//
//  UIView+LGXLayout.m
//  LGXAutoLayout
//
//  Created by icash on 2017/6/22.
//  Copyright © 2017年 iCash. All rights reserved.
//

#import "UIView+LGXLayout.h"
#import <Masonry/Masonry.h>

#pragma mark -属性添加、更新、重制 操作
/** 属性添加、更新、重制 操作 */
@implementation UIView (operation)
- (NSArray *)lgx_makeConstraints:(void(^)(LGXLayoutMaker *))block
{
    LGXLayoutMaker *make = [[LGXLayoutMaker alloc] initWithView:self];
    block(make);
    return [make install];
}
- (NSArray *)lgx_updateConstraints:(void(^)(LGXLayoutMaker *))block
{
    LGXLayoutMaker *make = [[LGXLayoutMaker alloc] initWithView:self];
    block(make);
    return [make update];
}
- (NSArray *)lgx_remakeConstraints:(void(^)(LGXLayoutMaker *))block
{
    LGXLayoutMaker *make = [[LGXLayoutMaker alloc] initWithView:self];
    block(make);
    return [make remake];
}
@end

#pragma mark - 一些属性
@implementation UIView (LGXLayout)


#pragma mark - LGXAttribute 属性
/** = = = 顶部属性 = = = */
- (LGXConstraint *)lgx_topEdge {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeTop];
}
- (LGXConstraint *)lgx_topCenter
{
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeTopCenter];
}

/** = = = 左边属性 = = = */
- (LGXConstraint *)lgx_leftEdge
{
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeLeft];
}
- (LGXConstraint *)lgx_leftTop
{
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeLeftTop];
}
- (LGXConstraint *)lgx_leftCenter
{
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeLeftCenter];
}
- (LGXConstraint *)lgx_leftBottom
{
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeLeftBottom];
}

/** = = = 底部属性 = = = */
- (LGXConstraint *)lgx_bottomEdge {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeBottom];
}
- (LGXConstraint *)lgx_bottomCenter
{
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeBottomCenter];
}

/** = = = 右边属性 = = = */
- (LGXConstraint *)lgx_rightEdge
{
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeRight];
}
- (LGXConstraint *)lgx_rightTop
{
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeRightTop];
}
- (LGXConstraint *)lgx_rightCenter
{
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeRightCenter];
}
- (LGXConstraint *)lgx_rightBottom
{
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeRightBottom];
}

/** = = = 中心属性 = = = */
- (LGXConstraint *)lgx_allCenter {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeCenter];
}
- (LGXConstraint *)lgx_xCenter {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeCenterX];
}

- (LGXConstraint *)lgx_yCenter {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeCenterY];
}

/** = = = 尺寸属性 = = = */
- (LGXConstraint *)lgx_size {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeSize];
}

- (LGXConstraint *)lgx_width {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeWidth];
}

- (LGXConstraint *)lgx_height {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeHeight];
}

/** = = = 基线类 = = = */
- (LGXConstraint *)lgx_baseline {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeBaseline];
}
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (LGXConstraint *)lgx_firstBaseline {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeFirstBaseline];
}
- (LGXConstraint *)lgx_lastBaseline {
    return [[LGXConstraint alloc] initWithView:self byAttribute:LGXAttributeLastBaseline];
}

#endif
- (LGXConstraint *(^)(LGXAttribute))lgx_attribute
{
    return ^(LGXAttribute attr) {
        return [[LGXConstraint alloc] initWithView:self byAttribute:attr];
    };
}


@end
#pragma mark - 快速方法
/** 一些快速的布局方法 */
@implementation UIView (quick)

#pragma makr - 快速位置设置
/** 填充到父窗 */
- (NSArray *)fillToSuperViewBy:(LGXEdgeInsets)insets
{
    NSAssert(self.superview, @"没有superView");
    NSMutableArray *array = [NSMutableArray array];
    if (insets.top) [array addObject:[self topToView:nil withSpace:[insets.top floatValue]]];
    if (insets.left) [array addObject:[self leftToView:nil withSpace:[insets.left floatValue]]];
    if (insets.bottom) [array addObject:[self bottomToView:nil withSpace:[insets.bottom floatValue]]];
    if (insets.right) [array addObject:[self rightToView:nil withSpace:[insets.right floatValue]]];
    
    return [NSArray arrayWithArray:array];
}

/** 中心点锚到toView, toView = nil时为 superView */
- (NSArray *)centerToView:(UIView *)toView
{
    return @[
             [self xCenterToView:toView],
             [self yCenterToView:toView],
             ];
}
/** 横向居中到toView */
- (NSLayoutConstraint *)xCenterToView:(UIView *)toView
{
    if (!toView) toView = self.superview;
    NSAssert(toView, @"必须指定toView");
    return [self makeAttribute:LGXAttributeCenterX relation:LGXEqualTo to:toView attribute:LGXAttributeCenterX];
}
/** 纵向居中到toView */
- (NSLayoutConstraint *)yCenterToView:(UIView *)toView
{
    if (!toView) toView = self.superview;
    NSAssert(toView, @"必须指定toView");
    return [self makeAttribute:LGXAttributeCenterY relation:LGXEqualTo to:toView attribute:LGXAttributeCenterY];
}

#pragma makr - 快速尺寸设置
/** 设置大小 */
- (NSArray *)setupSize:(CGSize)size
{
    return @[
             [self setupWidth:size.width],
             [self setupHeight:size.height],
             ];
}
/** 设置宽 */
- (NSLayoutConstraint *)setupWidth:(CGFloat)width
{
    return [self setupWidth:width byPriority:LGXLayoutPriorityRequired];
}
- (NSLayoutConstraint *)setupWidth:(CGFloat)width byPriority:(CGFloat)priority
{
    return [self makeAttribute:LGXAttributeWidth relation:LGXEqualTo to:nil attribute:LGXAttributeNotAnAttribute multipliedBy:1 offset:width byPriority:priority];
}
/** 宽等于toView的百分比 */
- (NSLayoutConstraint *)setupPercentWidth:(CGFloat)multipliedBy
{
    return [self setupPercentWidth:multipliedBy toView:nil];
}
/** 宽等于toView的百分比,toView为nil时表示super */
- (NSLayoutConstraint *)setupPercentWidth:(CGFloat)multipliedBy toView:(UIView *)toView
{
    return [self setupPercentWidth:multipliedBy toView:toView offset:0 byPriority:LGXLayoutPriorityRequired];
}
- (NSLayoutConstraint *)setupPercentWidth:(CGFloat)multipliedBy toView:(UIView *)toView offset:(float)offset byPriority:(CGFloat)priority
{
    if (!toView) toView = self.superview;
    NSAssert(toView, @"必须指定toView");
    
    return [self makeAttribute:LGXAttributeWidth relation:LGXEqualTo to:toView attribute:LGXAttributeWidth multipliedBy:multipliedBy offset:offset byPriority:priority];
}

/** 设置高 */
- (NSLayoutConstraint *)setupHeight:(CGFloat)height
{
    return [self setupHeight:height byPriority:LGXLayoutPriorityRequired];
}
- (NSLayoutConstraint *)setupHeight:(CGFloat)height byPriority:(CGFloat)priority
{
    return [self makeAttribute:LGXAttributeHeight relation:LGXEqualTo to:nil attribute:LGXAttributeNotAnAttribute multipliedBy:1 offset:height byPriority:priority];
}
/** 高等于toView的百分比 */
- (NSLayoutConstraint *)setupPercentHeight:(CGFloat)multipliedBy
{
    return [self setupPercentHeight:multipliedBy toView:nil];
}
/** 高等于toView的百分比,toView为nil时表示super */
- (NSLayoutConstraint *)setupPercentHeight:(CGFloat)multipliedBy toView:(UIView *)toView
{
    return [self setupPercentHeight:multipliedBy toView:toView offset:0 byPriority:LGXLayoutPriorityRequired];
}
- (NSLayoutConstraint *)setupPercentHeight:(CGFloat)multipliedBy toView:(UIView *)toView offset:(float)offset byPriority:(CGFloat)priority
{
    if (!toView) toView = self.superview;
    NSAssert(toView, @"必须指定toView");
    return [self makeAttribute:LGXAttributeHeight relation:LGXEqualTo to:toView attribute:LGXAttributeHeight multipliedBy:multipliedBy offset:offset byPriority:priority];
}

#pragma mark - 快速设置四条边
- (NSLayoutConstraint *)topToView:(UIView *)toView
{
    return [self topToView:toView withSpace:0];
}
- (NSLayoutConstraint *)topToView:(UIView *)toView withSpace:(CGFloat)space
{
    return [self topToView:toView withSpace:space withPriority:LGXLayoutPriorityRequired];
}
- (NSLayoutConstraint *)topToView:(UIView *)toView withSpace:(CGFloat)space withPriority:(float)priority
{
    toView = [self checkEdgeView:toView];
    BOOL isSuperView = [self checkSuperView:toView];
    LGXAttribute otherAtt = LGXAttributeTop;
    if (!isSuperView) {
        otherAtt = LGXAttributeBottom;
    }
    return [self makeAttribute:LGXAttributeTop relation:LGXEqualTo to:toView attribute:otherAtt multipliedBy:1 offset:space byPriority:LGXLayoutPriorityRequired];
}

- (NSLayoutConstraint *)leftToView:(UIView *)toView
{
    return [self leftToView:toView withSpace:0];
}
- (NSLayoutConstraint *)leftToView:(UIView *)toView withSpace:(CGFloat)space
{
    return [self leftToView:toView withSpace:space withPriority:LGXLayoutPriorityRequired];
}
- (NSLayoutConstraint *)leftToView:(UIView *)toView withSpace:(CGFloat)space withPriority:(float)priority
{
    toView = [self checkEdgeView:toView];
    BOOL isSuperView = [self checkSuperView:toView];
    LGXAttribute otherAtt = LGXAttributeLeft;
    if (!isSuperView) {
        otherAtt = LGXAttributeRight;
    }
    return [self makeAttribute:LGXAttributeLeft relation:LGXEqualTo to:toView attribute:otherAtt multipliedBy:1 offset:space byPriority:LGXLayoutPriorityRequired];
}

- (NSLayoutConstraint *)bottomToView:(UIView *)toView
{
    return [self bottomToView:toView withSpace:0];
}
- (NSLayoutConstraint *)bottomToView:(UIView *)toView withSpace:(CGFloat)space
{
    return [self bottomToView:toView withSpace:space withPriority:LGXLayoutPriorityRequired];
}
- (NSLayoutConstraint *)bottomToView:(UIView *)toView withSpace:(CGFloat)space withPriority:(float)priority
{
    toView = [self checkEdgeView:toView];
    BOOL isSuperView = [self checkSuperView:toView];
    LGXAttribute otherAtt = LGXAttributeBottom;
    if (!isSuperView) {
        otherAtt = LGXAttributeTop;
    }
    space = -1*space;
    return [self makeAttribute:LGXAttributeBottom relation:LGXEqualTo to:toView attribute:otherAtt multipliedBy:1 offset:space byPriority:LGXLayoutPriorityRequired];
}

- (NSLayoutConstraint *)rightToView:(UIView *)toView
{
    return [self rightToView:toView withSpace:0];
}
- (NSLayoutConstraint *)rightToView:(UIView *)toView withSpace:(CGFloat)space
{
    return [self rightToView:toView withSpace:space withPriority:LGXLayoutPriorityRequired];
}
- (NSLayoutConstraint *)rightToView:(UIView *)toView withSpace:(CGFloat)space withPriority:(float)priority
{
    toView = [self checkEdgeView:toView];
    BOOL isSuperView = [self checkSuperView:toView];
    LGXAttribute otherAtt = LGXAttributeRight;
    if (!isSuperView) {
        otherAtt = LGXAttributeLeft;
    }
    space = -1*space;
    return [self makeAttribute:LGXAttributeRight relation:LGXEqualTo to:toView attribute:otherAtt multipliedBy:1 offset:space byPriority:LGXLayoutPriorityRequired];
}
- (UIView *)checkEdgeView:(UIView *)toView
{
    if (!toView) toView = self.superview;
    NSAssert(toView, @"必须指定toView");
    return toView;
}
- (BOOL)checkSuperView:(UIView *)toView
{
    if (toView == self.superview) {
        return YES;
    }
    return NO;
}
#pragma mark - 基本约束方法
- (NSLayoutConstraint *)makeAttribute:(LGXAttribute)attribute
                             relation:(LGXRelation)relation
                                   to:(UIView *)toView
                            attribute:(LGXAttribute)toAttribute
{
    return [self makeAttribute:attribute relation:relation to:toView attribute:toAttribute multipliedBy:1 offset:0 byPriority:LGXLayoutPriorityRequired];
}
- (NSLayoutConstraint *)makeAttribute:(LGXAttribute)attribute
                             relation:(LGXRelation)relation
                                   to:(UIView *)toView
                            attribute:(LGXAttribute)toAttribute
                         multipliedBy:(CGFloat)multipliedBy
                               offset:(float)offset
                           byPriority:(CGFloat)priority
{
    LGXConstraint *fromConstraint = [[LGXConstraint alloc] initWithView:self byAttribute:attribute];
    LGXConstraint *toConstraint = [[LGXConstraint alloc] initWithView:toView byAttribute:toAttribute];
    
    if (relation == LGXEqualTo) fromConstraint.lgx_equalTo(toConstraint);
    if (relation == LGXGreaterThan) fromConstraint.lgx_greaterThanOrEqualTo(toConstraint);
    if (relation == LGXLessThan) fromConstraint.lgx_lessThanOrEqualTo(toConstraint);
    
    NSArray *array = [self mas_makeConstraints:^(MASConstraintMaker *make) {
        [fromConstraint.multipliedBy(multipliedBy).lgx_floatOffset(offset).priority(priority) installBy:make];
    }];
    NSLayoutConstraint *constraint = (NSLayoutConstraint *)[array.lastObject valueForKeyPath:@"_layoutConstraint"];
    return constraint;
}


#pragma mark - 添加线条

/** 在顶部添加一条线，默认高度是0.5，居左居右0，默认颜色lightGrayColor */
- (UIView *)addTopLineByColor:(UIColor *)color
{
    return [self addTopLineByColor:color toLeft:0 andRight:0];
}
- (UIView *)addTopLineByColor:(UIColor *)color toLeft:(CGFloat)left andRight:(CGFloat)right
{
    return [self addLineToEdge:LGXEdgeTop byColor:color withSize:0.5 toFirstSide:left andSecondSide:right];
}

/** 在底部添加一条线，默认高度是0.5，居左居右0默认颜色lightGrayColor */
- (UIView *)addBottomLineByColor:(UIColor *)color
{
    return [self addBottomLineByColor:color toLeft:0 andRight:0];
}
- (UIView *)addBottomLineByColor:(UIColor *)color toLeft:(CGFloat)left andRight:(CGFloat)right
{
    return [self addLineToEdge:LGXEdgeBottom byColor:color withSize:0.5 toFirstSide:left andSecondSide:right];
}

/** 在左边添加一条线，默认宽度是0.5，居上居下0默认颜色lightGrayColor */
- (UIView *)addLeftLineByColor:(UIColor *)color
{
    return [self addLeftLineByColor:color toTop:0 andBottom:0];
}
- (UIView *)addLeftLineByColor:(UIColor *)color toTop:(CGFloat)top andBottom:(CGFloat)bottom
{
    return [self addLineToEdge:LGXEdgeLeft byColor:color withSize:0.5 toFirstSide:top andSecondSide:bottom];
}

/** 在右边添加一条线，默认宽度是0.5，居上居下0默认颜色lightGrayColor */
- (UIView *)addRightLineByColor:(UIColor *)color
{
    return [self addRightLineByColor:color toTop:0 andBottom:0];
}
- (UIView *)addRightLineByColor:(UIColor *)color toTop:(CGFloat)top andBottom:(CGFloat)bottom
{
    return [self addLineToEdge:LGXEdgeRight byColor:color withSize:0.5 toFirstSide:top andSecondSide:bottom];
}

/**
 * 添加一线
 * @param edgeType          在哪条这添加
 * @param color             线条颜色，默认是lightGrayColor
 * @param size              宽或者高
 * @param firstSpace        宽时为左，高时为上
 * @param secondSpace       宽时为右，高时为下
 */
- (UIView *)addLineToEdge:(LGXEdgeType)edgeType byColor:(UIColor *)color withSize:(CGFloat)size toFirstSide:(CGFloat)firstSpace andSecondSide:(CGFloat)secondSpace
{
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    if (color == nil) {
        color = [UIColor lightGrayColor];
    }
    lineView.backgroundColor = color;
    NSNumber *fistNumber = [NSNumber numberWithFloat:firstSpace];
    NSNumber *twoNumber = [NSNumber numberWithFloat:firstSpace];
    if (edgeType == LGXEdgeTop || edgeType == LGXEdgeBottom) {
        [lineView setupHeight:size];
        LGXEdgeInsets insets = LGXEdgeInsetsZero;
        if (edgeType == LGXEdgeTop) insets = LGXEdgeInsetsMake(@0, fistNumber, nil, twoNumber);
        if (edgeType == LGXEdgeBottom) insets = LGXEdgeInsetsMake(nil, fistNumber, @0, twoNumber);
        [lineView fillToSuperViewBy:insets];
    } else {
        [lineView setupWidth:size];
        LGXEdgeInsets insets = LGXEdgeInsetsZero;
        if (edgeType == LGXEdgeLeft) insets = LGXEdgeInsetsMake(fistNumber, @0, twoNumber, nil);
        if (edgeType == LGXEdgeRight) insets = LGXEdgeInsetsMake(fistNumber, nil, twoNumber, @0);
        [lineView fillToSuperViewBy:insets];
    }
    return lineView;
}

#pragma mark - 等view添加
/**
 * 在横轴方向上添加多个等view，上下距离super是0
 * @param viewsArray            views
 * @param viewSpace         view之前的space
 */
- (void)addHorizontalViews:(NSArray *)viewsArray byViewSpace:(CGFloat)viewSpace
{
    [self layoutSubViews:viewsArray toAxis:LGXAxisHorizontal byViewSpace:viewSpace withFirstSpace:0 andSecondSpace:0];
}
/**
 * 在纵轴方向上添加多个等view，左右距离super是0
 * @param viewsArray            views
 * @param viewSpace         view之前的space
 */
- (void)addVerticalViews:(NSArray *)viewsArray byViewSpace:(CGFloat)viewSpace
{
    [self layoutSubViews:viewsArray toAxis:LGXAxisVertical byViewSpace:viewSpace withFirstSpace:0 andSecondSpace:0];
}
/**
 * 在某个轴方向上布局多个等view
 * @param viewsArray        views
 * @param axisType          布局到哪个轴上
 * @param viewSpace         view之间的space
 * @param firstSpace        如果轴是LGXAxisHorizontal时表示 left ，LGXAxisVertical时表示 top
 * @param secondSpace       如果轴是LGXAxisHorizontal时表示 right ，LGXAxisVertical时表示 bottom
 */
- (void)layoutSubViews:(NSArray *)viewsArray toAxis:(LGXAxis)axisType byViewSpace:(CGFloat)viewSpace withFirstSpace:(CGFloat)firstSpace andSecondSpace:(CGFloat)secondSpace
{
    MASAxisType masaxisType = MASAxisTypeVertical;
    if (axisType == LGXAxisHorizontal)  masaxisType = MASAxisTypeHorizontal;
    
    [viewsArray mas_distributeViewsAlongAxis:masaxisType withFixedSpacing:viewSpace leadSpacing:firstSpace tailSpacing:secondSpace];
    [viewsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        if (masaxisType == MASAxisTypeHorizontal) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
        } else {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }
    }];
}
/**
 *  九宫格布局 固定ItemSize 固定ItemSpacing
 *  可由九宫格的内容控制SuperView的大小
 *  如果warpCount大于[viewsArray count]，该方法将会用空白的View填充到superview中
 *
 *  @param viewsArray            views
 *  @param fixedItemWidth        固定宽度，如果设置成0，则表示自适应
 *  @param fixedItemHeight       固定高度，如果设置成0，则表示自适应
 *  @param fixedLineSpacing      行间距,宫格之间行的间距，如果宫格只有一行，则不生效
 *  @param fixedInteritemSpacing 列间距,宫格之间列的间距，如果只有一列，则不生效
 *  @param warpCount             折行点的数量，如果设为3，表示一行排列3个
 *  @param topSpacing            顶间距
 *  @param bottomSpacing         底间距
 *  @param leadSpacing           左间距
 *  @param tailSpacing           右间距
 *
 *  @return 一般情况下会返回原viewsArray数组, 如果warpCount大于[viewsArray count]，则会返回一个被空白view填充过的数组，可以让你循环调用removeFromSuperview或者干一些其他的事情;
 */

- (NSArray *)layoutSubViews:(NSArray *)viewsArray
         WithFixedItemWidth:(CGFloat)fixedItemWidth
            fixedItemHeight:(CGFloat)fixedItemHeight
           fixedLineSpacing:(CGFloat)fixedLineSpacing
      fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                  warpCount:(NSInteger)warpCount
                 topSpacing:(CGFloat)topSpacing
              bottomSpacing:(CGFloat)bottomSpacing
                leadSpacing:(CGFloat)leadSpacing
                tailSpacing:(CGFloat)tailSpacing
{
    // 此方法的实现内容为 http://www.cnblogs.com/YHStar/p/5788896.html 提供
    
    NSInteger oricount = viewsArray.count;
    
    if (oricount < 1) {
        return viewsArray;
    }
    if (warpCount < 1) {
        NSAssert(false, @"warp count need to bigger than zero");
        return viewsArray;
    }
    
    MAS_VIEW *tempSuperView = self;
    
    NSArray *tempViews = viewsArray;
    if (warpCount > oricount) {
        for (int i = 0; i < warpCount - oricount; i++) {
            MAS_VIEW *tempView = [[MAS_VIEW alloc] init];
            [tempSuperView addSubview:tempView];
            tempViews = [tempViews arrayByAddingObject:tempView];
        }
    }
    
    NSInteger columnCount = warpCount;
    NSInteger rowCount = tempViews.count % columnCount == 0 ? tempViews.count / columnCount : tempViews.count / columnCount + 1;
    
    MAS_VIEW *prev;
    for (int i = 0; i < tempViews.count; i++) {
        
        MAS_VIEW *v = tempViews[i];
        NSInteger currentRow = i / columnCount;
        NSInteger currentColumn = i % columnCount;
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            if (prev) {
                // 固定宽度
                make.width.equalTo(prev);
                make.height.equalTo(prev);
            }
            else {
                // 如果写的item高宽分别是0，则表示自适应
                if (fixedItemWidth) {
                    make.width.equalTo(@(fixedItemWidth));
                }
                if (fixedItemHeight) {
                    make.height.equalTo(@(fixedItemHeight));
                }
            }
            
            // 第一行
            if (currentRow == 0) {
                make.top.equalTo(tempSuperView).offset(topSpacing);
            }
            // 最后一行
            if (currentRow == rowCount - 1) {
                // 如果只有一行
                if (currentRow != 0 && i-columnCount >= 0) {
                    make.top.equalTo(((MAS_VIEW *)tempViews[i-columnCount]).mas_bottom).offset(fixedLineSpacing);
                }
                make.bottom.equalTo(tempSuperView).offset(-bottomSpacing);
            }
            // 中间的若干行
            if (currentRow != 0 && currentRow != rowCount - 1) {
                make.top.equalTo(((MAS_VIEW *)tempViews[i-columnCount]).mas_bottom).offset(fixedLineSpacing);
            }
            
            // 第一列
            if (currentColumn == 0) {
                make.left.equalTo(tempSuperView).offset(leadSpacing);
            }
            // 最后一列
            if (currentColumn == columnCount - 1) {
                // 如果只有一列
                if (currentColumn != 0) {
                    make.left.equalTo(prev.mas_right).offset(fixedInteritemSpacing);
                }
                make.right.equalTo(tempSuperView).offset(-tailSpacing);
            }
            // 中间若干列
            if (currentColumn != 0 && currentColumn != warpCount - 1) {
                make.left.equalTo(prev.mas_right).offset(fixedInteritemSpacing);
            }
        }];
        prev = v;
    }
    return tempViews;
}



@end

#pragma mark - 一些废弃的方法
@implementation UIView (LGXLayoutDeprecated)

/** = = = 顶部属性 = = = */
- (LGXConstraint *)lgx_top
{
    return self.lgx_topEdge;
}
/** = = = 左边属性 = = = */
- (LGXConstraint *)lgx_left
{
    return self.lgx_leftEdge;
}
/** = = = 底部属性 = = = */
- (LGXConstraint *)lgx_bottom
{
    return self.lgx_bottomEdge;
}
/** = = = 右边属性 = = = */
- (LGXConstraint *)lgx_right
{
    return self.lgx_rightEdge;
}
/** = = = 中心属性 = = = */
- (LGXConstraint *)lgx_center {
    return self.lgx_allCenter;
}
@end



