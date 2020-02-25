//
//  UIView+LGXLayout.h
//  LGXAutoLayout
//
//  Created by icash on 2017/6/22.
//  Copyright © 2017年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGXConstraint.h"
#import "LGXALUtilities.h"
#import "LGXLayoutMaker.h"
#pragma mark -属性添加、更新、重制 操作
/** 属性添加、更新、重制 操作 */
@interface UIView (operation)
- (NSArray *)lgx_makeConstraints:(void(^)(LGXLayoutMaker *make))block;
- (NSArray *)lgx_updateConstraints:(void(^)(LGXLayoutMaker *make))block;
- (NSArray *)lgx_remakeConstraints:(void(^)(LGXLayoutMaker *make))block;
@end

#pragma mark - 一些属性
/** 一些属性 */
@interface UIView (LGXLayout)

#pragma mark - 位置属性

/** = = = 顶部属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* lgx_topEdge;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_topCenter;

/** = = = 左边属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* lgx_leftEdge;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_leftTop;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_leftCenter;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_leftBottom;

/** = = = 底部属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* lgx_bottomEdge;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_bottomCenter;

/** = = = 右边属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* lgx_rightEdge;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_rightTop;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_rightCenter;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_rightBottom;

/** = = = 中心属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* lgx_allCenter;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_xCenter;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_yCenter;

#pragma mark - 尺寸属性

/** = = = 尺寸属性 = = = */
/** lgx_size 使用 LGXConstraint 的sizeOffset设置*/
@property (nonatomic, strong, readonly) LGXConstraint* lgx_size;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_width;
@property (nonatomic, strong, readonly) LGXConstraint* lgx_height;

#pragma mark - 基线类
@property (nonatomic, strong, readonly) LGXConstraint *lgx_baseline;
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) LGXConstraint *lgx_firstBaseline;
@property (nonatomic, strong, readonly) LGXConstraint *lgx_lastBaseline;

#endif

@end

#pragma mark - 快速方法
/** 一些快速的布局方法 */
@interface UIView (quick)
/** 填充到父窗 */
- (NSArray *)fillToSuperViewBy:(LGXEdgeInsets)insets;

/** 中心点锚到toView, toView = nil时为 superView */
- (NSArray *)centerToView:(UIView *)toView;
/** 横向居中到toView */
- (NSLayoutConstraint *)xCenterToView:(UIView *)toView;
/** 纵向居中到toView */
- (NSLayoutConstraint *)yCenterToView:(UIView *)toView;


/** 设置大小 */
- (NSArray *)setupSize:(CGSize)size;
/** 设置宽 */
- (NSLayoutConstraint *)setupWidth:(CGFloat)width;
- (NSLayoutConstraint *)setupWidth:(CGFloat)width byPriority:(CGFloat)priority;
/** 宽等于toView的百分比 */
- (NSLayoutConstraint *)setupPercentWidth:(CGFloat)multipliedBy;
/** 宽等于toView的百分比,toView为nil时表示super */
- (NSLayoutConstraint *)setupPercentWidth:(CGFloat)multipliedBy toView:(UIView *)toView;
- (NSLayoutConstraint *)setupPercentWidth:(CGFloat)multipliedBy toView:(UIView *)toView offset:(float)offset byPriority:(CGFloat)priority;

/** 设置高 */
- (NSLayoutConstraint *)setupHeight:(CGFloat)height;
- (NSLayoutConstraint *)setupHeight:(CGFloat)height byPriority:(CGFloat)priority;
/** 高等于toView的百分比 */
- (NSLayoutConstraint *)setupPercentHeight:(CGFloat)multipliedBy;
/** 高等于toView的百分比,toView为nil时表示super */
- (NSLayoutConstraint *)setupPercentHeight:(CGFloat)multipliedBy toView:(UIView *)toView;
- (NSLayoutConstraint *)setupPercentHeight:(CGFloat)multipliedBy toView:(UIView *)toView offset:(float)offset byPriority:(CGFloat)priority;

/** 基本约束方法 */
- (NSLayoutConstraint *)makeAttribute:(LGXAttribute)attribute
                             relation:(LGXRelation)relation
                                   to:(UIView *)toView
                            attribute:(LGXAttribute)toAttribute;


- (NSLayoutConstraint *)topToView:(UIView *)toView;
- (NSLayoutConstraint *)topToView:(UIView *)toView withSpace:(CGFloat)space;
- (NSLayoutConstraint *)topToView:(UIView *)toView withSpace:(CGFloat)space withPriority:(float)priority;

- (NSLayoutConstraint *)leftToView:(UIView *)toView;
- (NSLayoutConstraint *)leftToView:(UIView *)toView withSpace:(CGFloat)space;
- (NSLayoutConstraint *)leftToView:(UIView *)toView withSpace:(CGFloat)space withPriority:(float)priority;

- (NSLayoutConstraint *)bottomToView:(UIView *)toView;
- (NSLayoutConstraint *)bottomToView:(UIView *)toView withSpace:(CGFloat)space;
- (NSLayoutConstraint *)bottomToView:(UIView *)toView withSpace:(CGFloat)space withPriority:(float)priority;

- (NSLayoutConstraint *)rightToView:(UIView *)toView;
- (NSLayoutConstraint *)rightToView:(UIView *)toView withSpace:(CGFloat)space;
- (NSLayoutConstraint *)rightToView:(UIView *)toView withSpace:(CGFloat)space withPriority:(float)priority;

#pragma mark - 添加线条

/** 在顶部添加一条线，默认高度是0.5，居左居右0，默认颜色lightGrayColor */
- (UIView *)addTopLineByColor:(UIColor *)color;
- (UIView *)addTopLineByColor:(UIColor *)color toLeft:(CGFloat)left andRight:(CGFloat)right;

/** 在底部添加一条线，默认高度是0.5，居左居右0默认颜色lightGrayColor */
- (UIView *)addBottomLineByColor:(UIColor *)color;
- (UIView *)addBottomLineByColor:(UIColor *)color toLeft:(CGFloat)left andRight:(CGFloat)right;

/** 在左边添加一条线，默认宽度是0.5，居上居下0默认颜色lightGrayColor */
- (UIView *)addLeftLineByColor:(UIColor *)color;
- (UIView *)addLeftLineByColor:(UIColor *)color toTop:(CGFloat)top andBottom:(CGFloat)bottom;

/** 在右边添加一条线，默认宽度是0.5，居上居下0默认颜色lightGrayColor */
- (UIView *)addRightLineByColor:(UIColor *)color;
- (UIView *)addRightLineByColor:(UIColor *)color toTop:(CGFloat)top andBottom:(CGFloat)bottom;

/**
 * 添加一线
 * @param edgeType          在哪条这添加
 * @param color             线条颜色，默认是lightGrayColor
 * @param size              宽或者高
 * @param firstSpace        宽时为左，高时为上
 * @param secondSpace       宽时为右，高时为下
 */
- (UIView *)addLineToEdge:(LGXEdgeType)edgeType byColor:(UIColor *)color withSize:(CGFloat)size toFirstSide:(CGFloat)firstSpace andSecondSide:(CGFloat)secondSpace;

#pragma mark - 等view添加
/**
 * 在横轴方向上添加多个等view，上下距离super是0
 * @param viewsArray        views
 * @param viewSpace         view之间的space
 */
- (void)addHorizontalViews:(NSArray *)viewsArray byViewSpace:(CGFloat)viewSpace;
/**
 * 在纵轴方向上添加多个等view，左右距离super是0
 * @param viewsArray        views
 * @param viewSpace         view之间的space
 */
- (void)addVerticalViews:(NSArray *)viewsArray byViewSpace:(CGFloat)viewSpace;

/**
 * 在某个轴方向上布局多个等view
 * @param viewsArray        views
 * @param axisType          布局到哪个轴上
 * @param viewSpace         view之间的space
 * @param firstSpace        如果轴是LGXAxisHorizontal时表示 left ，LGXAxisVertical时表示 top
 * @param secondSpace       如果轴是LGXAxisHorizontal时表示 right ，LGXAxisVertical时表示 bottom
 */
- (void)layoutSubViews:(NSArray *)viewsArray
                toAxis:(LGXAxis)axisType
           byViewSpace:(CGFloat)viewSpace
        withFirstSpace:(CGFloat)firstSpace
        andSecondSpace:(CGFloat)secondSpace;

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
 *  以下4个为整个九宫格上左下右的间距
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
                tailSpacing:(CGFloat)tailSpacing;




@end

#pragma mark - 一些废弃的方法
@interface UIView (LGXLayoutDeprecated)

/** = = = 顶部属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* lgx_top __deprecated_msg("Use `lgx_topEdge`");

/** = = = 左边属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* lgx_left __deprecated_msg("Use `lgx_leftEdge`");

/** = = = 底部属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* lgx_bottom  __deprecated_msg("Use `lgx_bottomEdge`");

/** = = = 右边属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* lgx_right  __deprecated_msg("Use `lgx_rightEdge`");
/** = = = 中心属性 = = = */
@property (nonatomic, strong, readonly) LGXConstraint* lgx_center __deprecated_msg("Use `lgx_allCenter`");
@end



