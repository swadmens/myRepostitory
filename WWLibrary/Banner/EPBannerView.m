//
//  EPBannerView.m
//  EpetMallV3
//
//  Created by icash on 16/9/27.
//  Copyright © 2016年 com.epetbar.deals. All rights reserved.
//

#import "EPBannerView.h"
#import "ZYBannerView.h"
#import "UIImageView+WebCache.h"
#import "EPPageControl.h"
#import <UIImageView+YYWebImage.h>



@interface EPBannerView ()<ZYBannerViewDataSource, ZYBannerViewDelegate>

@property (nonatomic, strong) ZYBannerView *banner;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) EPPageControl *pageControl;


@property (nonatomic,strong) UIView *numberView;
@property (nonatomic,strong) UILabel *indexLabel;

@end

@implementation EPBannerView
- (void)setShouldLoop:(BOOL)shouldLoop
{
    _shouldLoop = shouldLoop;
    self.banner.shouldLoop = _shouldLoop;
}
- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    self.banner.autoScroll = _autoScroll;
}
- (void)setScrollInterval:(CGFloat)scrollInterval
{
    _scrollInterval = scrollInterval;
    self.banner.scrollInterval = _scrollInterval;
}
- (void)setShowFooter:(BOOL)showFooter
{
    _showFooter = showFooter;
    self.banner.showFooter = _showFooter;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self dosetup];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self dosetup];
    }
    return self;
}
- (void)dosetup
{
    // 初始化
    self.banner = [[ZYBannerView alloc] init];
    self.banner.dataSource = self;
    self.banner.delegate = self;
    self.autoScroll = YES;
    self.shouldLoop = YES;
    [self addSubview:self.banner];
    [self.banner alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self];
   
    /// page control
    self.pageControl = [[EPPageControl alloc] init];
    [self addSubview:self.pageControl];
    [self.pageControl leftToView:self withSpace:0];
    [self.pageControl rightToView:self withSpace:0];
    [self.pageControl bottomToView:self withSpace:2.0];

    self.PControlType = EPPageControlDefault;
    
    
    
    self.numberView = [UIView new];
    self.numberView.backgroundColor = UIColorFromRGB(0x000000, 0.6);
    self.numberView.clipsToBounds = YES;
    self.numberView.layer.cornerRadius = 4;
    [self addSubview:self.numberView];
    [self.numberView xCenterToView:self];
    [self.numberView bottomToView:self withSpace:10.0];
    [self.numberView addWidth:45];
    [self.numberView addHeight:30];
    
    
    self.indexLabel = [UILabel new];
    self.indexLabel.textColor = [UIColor whiteColor];
    self.indexLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.numberView addSubview:self.indexLabel];
    [self.indexLabel centerToView:self.numberView];
    
}

- (void)setDelegate:(id<EPBannerDelegate>)delegate
{
    _delegate = delegate;
    // 通过外部来注册类
    if ([_delegate respondsToSelector:@selector(makeItemRegistTo:)]) {
        [_delegate makeItemRegistTo:self.banner.collectionView];
    }
}
- (void)setPControlType:(EPPageControlType)PControlType
{
    _PControlType = PControlType;
    if (self.dataArray.count <=1) {
        self.banner.pageControl.hidden = YES;
        self.pageControl.hidden = YES;
        return;
    }
    switch (PControlType) {
        case EPPageControlDefault:
        {
            self.banner.pageControl.hidden = NO;
            self.pageControl.hidden = YES;
            self.numberView.hidden = YES;
        }
            break;
        case EPPageControlLong:
        {
            self.pageControl.hidden = NO;
            self.banner.pageControl.hidden = YES;
            self.numberView.hidden = YES;

        }
            break;
        case EPPageControlNumber:
        {
            self.pageControl.hidden = YES;
            self.banner.pageControl.hidden = YES;
            self.numberView.hidden = NO;
        }
            break;
        default:
            break;
    }
}
- (void)reloadWithData:(NSArray *)array
{
    if ([array isEqualToArray:self.dataArray]) {
        return;
    }
    
    self.dataArray = array;
    self.pageControl.numberOfPages = array.count;
    [self.banner reloadData];
    /// 重新设置一下样式
    self.PControlType = self.PControlType;
//    self.indexLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.dataArray.count];
}
- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    self.banner.itemSize = itemSize;
}
#pragma mark - ZYBannerViewDataSource
// 返回Banner需要显示Item(View)的个数
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner
{
    return self.dataArray.count;
}

// 返回Banner在不同的index所要显示的View (可以是完全自定义的view, 且无需设置frame)
- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(banner:viewForItemAtIndex:)]) {
        return [self.delegate banner:self viewForItemAtIndex:index];
    }
    
    UIView *willShowView;
    // 取出数据
    id obj = [self.dataArray objectAtIndex:index];
    if ([obj isKindOfClass:[NSString class]]) {
        
        NSString *imageName = self.dataArray[index];
        // 创建将要显示控件
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        if ([imageName hasPrefix:@"http"]) {
            [imageView yy_setImageWithURL:[NSURL URLWithString:imageName] options:YYWebImageOptionSetImageWithFadeAnimation];
        } else {
            imageView.image = [UIImage imageNamed:imageName];
        }
        willShowView=imageView;
        
    }
    
    return willShowView;
}
- (UICollectionViewCell *)bannerCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(bannerCollectionView:cellForItemAtIndexPath:)]) {
        return [self.delegate bannerCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}
// 返回Footer在不同状态时要显示的文字
- (NSString *)banner:(ZYBannerView *)banner titleForFooterWithState:(ZYBannerFooterState)footerState
{

    if (footerState == ZYBannerFooterStateIdle) {
        return self.footerNormalText;
    } else if (footerState == ZYBannerFooterStateTrigger) {
        return self.footerTriggerText;
    }

    return nil;
}

#pragma mark - ZYBannerViewDelegate

// 在这里实现点击事件的处理
- (void)banner:(ZYBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
    if (self.clickedBlock) {
        self.clickedBlock(index);
    }
}

// 在这里实现拖动footer后的事件处理
- (void)bannerFooterDidTrigger:(ZYBannerView *)banner
{
    NSLog(@"触发了footer");
    if (self.moreTriggerBlock) {
        self.moreTriggerBlock();
    }
}
- (void)banner:(ZYBannerView *)banner didScrollsToPage:(NSInteger)index
{
    if (self.PControlType == EPPageControlLong) {
        self.pageControl.currentPage = index;
    }else if (self.PControlType == EPPageControlNumber){
        self.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)index+1,(unsigned long)self.dataArray.count];
    }
}
/// 滚动
- (void)banner:(ZYBannerView *)banner didScroll:(UIScrollView *)scrollView
{
    if (self.PControlType != EPPageControlLong) {
        return;
    }
    self.pageControl.contentOffset_x = scrollView.contentOffset.x;
}
#pragma mark - pagecontrol
- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    self.pageControl.selectedColor = _selectedColor;
    self.banner.pageControl.currentPageIndicatorTintColor = _selectedColor;
}
- (void)setUnSelectedColor:(UIColor *)unSelectedColor
{
    _unSelectedColor = unSelectedColor;
    self.pageControl.unSelectedColor = _unSelectedColor;
    self.banner.pageControl.pageIndicatorTintColor = _unSelectedColor;
}
@end











