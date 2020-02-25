//
//  EPBannerView.h
//  EpetMallV3
//
//  Created by icash on 16/9/27.
//  Copyright © 2016年 com.epetbar.deals. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EPBannerClickedBlock)(NSInteger index); // 点击了触发
typedef void(^EPBannerEndTrigger)(void); // 最后拖动完了，触发，如进入详情页


typedef enum : NSUInteger {
    EPPageControlDefault = 0,
    EPPageControlNumber = 1,
    EPPageControlLong = 99, // 选中时，是长的
} EPPageControlType;

/** EPBannerDelegate -- BEGIN */

@class EPBannerView;

@protocol EPBannerDelegate <NSObject>

@optional
/** 返回样式,如果不实现，默认返回展示网络图片的imageView */
- (UIView *)banner:(EPBannerView *)banner viewForItemAtIndex:(NSInteger)index;

/// 注册样式,下面两个配合使用，同时不会再调用以上方法 - (UIView *)banner:(EPBannerView *)banner viewForItemAtIndex:(NSInteger)index
- (void)makeItemRegistTo:(UICollectionView *)collection;
- (UICollectionViewCell *)bannerCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

/** EPBannerDelegate -- END */



@interface EPBannerView : UIView

/** 指示器的样式 */
@property (nonatomic, assign) EPPageControlType PControlType;
/**
 *  选中的颜色 [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *selectedColor;
/**
 *  未选中的颜色 [UIColor colorWithWhite:1 alpha:0.6]
 */
@property (nonatomic, strong) UIColor *unSelectedColor;

/** 是否需要循环滚动, 默认为 YES */
@property (nonatomic, assign) IBInspectable BOOL shouldLoop;

/** 是否自动滑动, 默认为 YES */
@property (nonatomic, assign) IBInspectable BOOL autoScroll;

/** 自动滑动间隔时间(s), 默认为 3.0 */
@property (nonatomic, assign) IBInspectable CGFloat scrollInterval;

/** 是否显示footer, 默认为 NO (此属性为YES时, shouldLoop会被置为NO) */
@property (nonatomic, assign) IBInspectable BOOL showFooter;

/// 常态文本，如继续拖动查看详情页
@property (nonatomic, strong) NSString *footerNormalText;
/// 触发文本，如释放查看详情页
@property (nonatomic, strong) NSString *footerTriggerText;
/** item大小，默认为当前view的大小 */
@property (nonatomic, assign) CGSize itemSize;
/// 重新加载
- (void)reloadWithData:(NSArray *)array;
@property (nonatomic, weak) id<EPBannerDelegate> delegate;
/// 回调
@property (nonatomic, copy) EPBannerClickedBlock clickedBlock;
/// 最后拖动,进入详情页等触发
@property (nonatomic, copy) EPBannerEndTrigger moreTriggerBlock;


@end
