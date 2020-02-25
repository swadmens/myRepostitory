//
//  EPPageControl.h
//  EpetMallV3
//
//  Created by icash on 16/9/27.
//  Copyright © 2016年 com.epetbar.deals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPPageControl : UIControl

/**
 *  页面的个数
 */
@property (nonatomic, assign) NSInteger numberOfPages;
/**
 *  当前页码
 */
@property (nonatomic, assign) NSInteger currentPage;
/**
 *  圆圈直径,默认5.0
 */
@property (nonatomic, assign) CGFloat ballDiameter;
/**
 *  选中时圆圈宽,默认是ballDiameter的两倍
 */
@property (nonatomic, assign) CGFloat selectedBallDiameter;

/**
 *  选中的颜色 [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *selectedColor;
/**
 *  未选中的颜色 [UIColor colorWithWhite:1 alpha:0.6]
 */
@property (nonatomic, strong) UIColor *unSelectedColor;
/**
 *  pageControl绑定的scrollview
 */
@property (nonatomic, strong) UIScrollView *bindingScrollView;
/**
 *  绑定的scrollView的cotentOffset.x
 */
@property (nonatomic, assign) CGFloat contentOffset_x;
/**
 *  绑定的scrollView的lastCotentOffset.x
 */
@property (nonatomic, assign) CGFloat lastContentOffset_x;
/**
 *  获取绑定关系这个是点的关系
 */
@property (nonatomic, strong, readonly) NSArray *constraintArray;
/**
 *  获取所有的点
 */
@property (nonatomic, strong, readonly) NSArray *viewsArray;

@end
