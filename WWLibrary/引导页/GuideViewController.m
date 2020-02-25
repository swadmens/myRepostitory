//
//  GuideViewController.m
//
//
//  Created by icash on 15-12-21.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import "GuideViewController.h"
#import "Masonry.h"
#import "EPPageControl.h"

@interface GuideViewController ()
{
    CGFloat _mainWidth;
    CGFloat _mainHeight;
    CGFloat _topBaseSpace;
    
    CGFloat _spaceBetweenCenterImageAndText; // 中间图片与下面的文本之间的间隙 55.0
    CGFloat _openButtonTop; // 开启按钮顶
    
    CGFloat  _p1_topImageHeight; // 中间1图片
    
    CGFloat  _bottomImageHeight; // 下图片高
    CGFloat _openButtonHeight; // 开启按钮的高
    
    CGFloat _baseHeight; // 基本比例
    
    CGFloat _pointToBottom; // 指示器到底部
}
/* = = = = = = = = = 全 = = = = = = = = */

/// 这个是顶部的基准
@property (nonatomic, strong) UIImageView *hiddenView;

/* = = = = = = = = = P1 = = = = = = = = */
/// 第一个图片 guide_p1_image
@property (nonatomic, strong) UIImageView *p1_top_image;
/// 第一个下面的文字 guide_p1_text
@property (nonatomic, strong) UIImageView *p1_bottom_image;

/* = = = = = = = = = P2 = = = = = = = = */
/// 第二个图片 guide_p2_image
@property (nonatomic, strong) UIImageView *p2_top_image;
/// 第二个下面的文字 guide_p2_text
@property (nonatomic, strong) UIImageView *p2_bottom_image;

/* = = = = = = = = = P3 = = = = = = = = */
/// 第三个图片 guide_p3_image
@property (nonatomic, strong) UIImageView *p3_top_image;
/// 第三个文字 guide_p3_yaoChongyou
@property (nonatomic, strong) UIImageView *p3_bottom_image;

/* = = = = = = = = = P4 = = = = = = = = */
/// 第四个图片 guide_p4_image
@property (nonatomic, strong) UIImageView *p4_top_image;
/// 第四个文字 guide_p3_yaoChongyou
@property (nonatomic, strong) UIImageView *p4_bottom_image;


/// 开启按钮 open_button@2x
@property (nonatomic, strong) UIButton *open_button;


/* = = = = = = = = = 页码标识 = = = = = = = = */
@property (nonatomic, strong) EPPageControl *pageView;

@end

@implementation GuideViewController

#define pagesCount 4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainWidth = [UIScreen mainScreen].bounds.size.width;
    _mainHeight = [UIScreen mainScreen].bounds.size.height;
    /// _topBaseSpace 是 iphone6高下面的比例
    /// 基本比例 _baseHeight，如果小于这个就算，否则就不管
    _baseHeight = 667.0;
    if (_baseHeight<= _mainHeight) { // 如果是iphone6及以上，则不改变
        _baseHeight = _mainHeight;
    }
    _topBaseSpace = (_mainHeight *75) / _baseHeight;  // 114   75
    _spaceBetweenCenterImageAndText = (_mainHeight *107) / _baseHeight; //40  107
    _openButtonTop = (_mainHeight *39.0) / _baseHeight;
    _pointToBottom = (_mainHeight *60) / _baseHeight;
    
    [self configureViews];
    [self configureAnimations];
}

- (void)configureViews
{
    /* = = = = = = = = = 全 = = = = = = = = */
    /// 这个跟顶部的V3是一样的。只是是隐藏的，用于做基准线
    
    self.hiddenView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    [self.contentView addSubview:self.hiddenView];
    self.hiddenView.hidden = YES;
    
    
    /* = = = = = = = = = P1 = = = = = = = = */
    // 中间的图片
    UIImage *p1centerimage = UIImageWithFileName(@"new_guide_p1_text");
     _p1_topImageHeight = (_mainHeight *p1centerimage.size.height) / _baseHeight;
    self.p1_top_image = [[UIImageView alloc] initWithImage:p1centerimage];
    [self.contentView addSubview:self.p1_top_image];
    self.p1_top_image.contentMode = UIViewContentModeScaleAspectFit;
    
    // 下
    UIImage *p1TextImage = UIImageWithFileName(@"new_guide_p1_img");
     _bottomImageHeight = (_mainHeight *p1TextImage.size.height) / _baseHeight;
    self.p1_bottom_image = [[UIImageView alloc] initWithImage:p1TextImage];
    [self.contentView addSubview:self.p1_bottom_image];
    self.p1_bottom_image.contentMode = UIViewContentModeScaleAspectFit;
    
    
    /* = = = = = = = = = P2 = = = = = = = = */
    //
    UIImage *p2centerimage = UIImageWithFileName(@"new_guide_p2_text");
    self.p2_top_image = [[UIImageView alloc] initWithImage:p2centerimage];
    [self.contentView addSubview:self.p2_top_image];
    self.p2_top_image.contentMode = UIViewContentModeScaleAspectFit;
    //
    
    self.p2_bottom_image = [[UIImageView alloc] initWithImage:UIImageWithFileName(@"new_guide_p2_img")];
    [self.contentView addSubview:self.p2_bottom_image];
    self.p2_bottom_image.contentMode = UIViewContentModeScaleAspectFit;
    
    /* = = = = = = = = = P3 = = = = = = = = */
    //
    UIImage *p3centerimage = UIImageWithFileName(@"new_guide_p3_text");
    self.p3_top_image = [[UIImageView alloc] initWithImage:p3centerimage];
    [self.contentView addSubview:self.p3_top_image];
    self.p3_top_image.contentMode = UIViewContentModeScaleAspectFit;
    //
    self.p3_bottom_image = [[UIImageView alloc] initWithImage:UIImageWithFileName(@"new_guide_p3_img")];
    [self.contentView addSubview:self.p3_bottom_image];
    self.p3_bottom_image.contentMode = UIViewContentModeScaleAspectFit;
    
    
    /* = = = = = = = = = P4 = = = = = = = = */
    //
    UIImage *p4centerimage = UIImageWithFileName(@"new_guide_p4_text");
    self.p4_top_image = [[UIImageView alloc] initWithImage:p4centerimage];
    [self.contentView addSubview:self.p4_top_image];
    self.p4_top_image.contentMode = UIViewContentModeScaleAspectFit;
    //
    self.p4_bottom_image = [[UIImageView alloc] initWithImage:UIImageWithFileName(@"new_guide_p4_img")];
    [self.contentView addSubview:self.p4_bottom_image];
    self.p4_bottom_image.contentMode = UIViewContentModeScaleAspectFit;
    
    
    // 开启按钮
    self.open_button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *openButtonImage = UIImageWithFileName(@"new_guide_open");
    self.open_button.frame = CGRectMake(0, 0, openButtonImage.size.width, openButtonImage.size.height);
    [self.open_button setImage:openButtonImage forState:UIControlStateNormal];
    [self.open_button addTarget:self action:@selector(action_finished) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.open_button];
    
    /* = = = = = = = = = 页码标识 = = = = = = = = */
    self.pageView = [[EPPageControl alloc] init];
    self.pageView.backgroundColor = [UIColor clearColor];
    self.pageView.selectedColor = UIColorFromRGB(0x0098fd, 1);
    self.pageView.unSelectedColor = UIColorFromRGB(0x9f9fa1, 1);
    self.pageView.bindingScrollView = self.scrollView;
    self.pageView.numberOfPages = pagesCount;
    
    [self.contentView addSubview:self.pageView];
    
}

/// 有多少个
- (NSUInteger)numberOfPages
{
    return pagesCount;
}
/// 配置动画
- (void)configureAnimations
{
//    [self configBackgroundColorAnimations];
    
    [self configHiddenViewAnimations];
    // p1
    [self config_P1_top_animations];
    [self config_P1_bottom_animations];

    // p2
    [self config_P2_top_animations];
    [self config_P2_bottom_animations];
    
    // p3
    [self config_P3_top_animations];
    [self config_P3_bottom_animations];
    
    // p4
    [self config_P4_top_animations];
    [self config_P4_bottom_animations];
    
    // 开启按钮
    [self config_open_animations];
    
    // 指示器
    [self configPagesAnimations];
}

/// 背景色变化
- (void)configBackgroundColorAnimations
{
    IFTTTBackgroundColorAnimation *backgroundColorAnimation = [IFTTTBackgroundColorAnimation animationWithView:self.view];
    [backgroundColorAnimation addKeyframeForTime:0 color:UIColorFromRGB(0x5cc0b8, 1)];
    [backgroundColorAnimation addKeyframeForTime:1 color:UIColorFromRGB(0xea5859, 1)];
    [backgroundColorAnimation addKeyframeForTime:2 color:UIColorFromRGB(0xf2bd3d, 1)];
    [backgroundColorAnimation addKeyframeForTime:3 color:UIColorFromRGB(0xf8fdff, 1)];
    [self.animator addAnimation:backgroundColorAnimation];
    
}
- (void)configHiddenViewAnimations
{
    [self keepView:self.hiddenView onPages:@[@(0),@(1),@(2),@(3)] atTimes:@[@(0),@(1),@(2),@(3)]];
    [self.hiddenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.height.offset(0);
    }];
}
#pragma mark - P1
/// P1 上
- (void)config_P1_top_animations
{
    int now = 0;
    int next = now + 1;
    
    float cha = 0.3;
    
    float fnow = now;
    float fnext = fnow - cha;
    
    [self keepView:self.p1_top_image onPages:@[@(fnow),@(fnext)] atTimes:@[@(now),@(next)]];
    [self.p1_top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hiddenView.mas_bottom).offset(_topBaseSpace);
        make.height.offset(_p1_topImageHeight);
    }];
}
/// p1 下
- (void)config_P1_bottom_animations
{
    int now = 0;
    int next = now + 1;
    
    float cha = 1.0;
    
    float fnow = now;
    float fnext = fnow - cha;
    
    [self keepView:self.p1_bottom_image onPages:@[@(fnow),@(fnext)] atTimes:@[@(now),@(next)]];
    [self.p1_bottom_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.p1_top_image.mas_bottom).offset(_spaceBetweenCenterImageAndText);
        make.height.offset( _bottomImageHeight);
    }];
}
#pragma mark - P2
/// p2 上
- (void)config_P2_top_animations
{
    int now = 1;
    int next = now + 1;
    int ex = now - 1;
    
    float cha = 0.3;
    
    float fnow = now;
    float fnext = fnow - cha;
    float fex = now + cha;
    
    [self keepView:self.p2_top_image onPages:@[@(fex),@(fnow),@(fnext)] atTimes:@[@(ex),@(now),@(next)]];
    [self.p2_top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hiddenView.mas_bottom).offset(_topBaseSpace);
        make.height.equalTo(self.p1_top_image.mas_height).offset(0);
    }];
}
/// p2 下
- (void)config_P2_bottom_animations
{
    int now = 1;
    int next = now + 1;
    int ex = now - 1;
    
    float cha = 1.0;
    
    float fnow = now;
    float fnext = fnow - cha;
    float fex = now + cha;
    
    [self keepView:self.p2_bottom_image onPages:@[@(fex),@(fnow),@(fnext)] atTimes:@[@(ex),@(now),@(next)]];
    [self.p2_bottom_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.p2_top_image.mas_bottom).offset(_spaceBetweenCenterImageAndText);
        make.height.equalTo(self.p1_bottom_image.mas_height).offset(0);
    }];
}
#pragma mark - P3
/// p3 上
- (void)config_P3_top_animations
{
    int now = 2;
    int next = now + 1;
    int ex = now - 1;
    
    float cha = 0.3;
    
    float fnow = now;
    float fnext = fnow - cha;
    float fex = now + cha;
    
    [self keepView:self.p3_top_image onPages:@[@(fex),@(fnow),@(fnext)] atTimes:@[@(ex),@(now),@(next)]];
    [self.p3_top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hiddenView.mas_bottom).offset(_topBaseSpace);
        make.height.equalTo(self.p1_top_image.mas_height).offset(0);
    }];
}
/// p3 下
- (void)config_P3_bottom_animations
{
    int now = 2;
    int next = now + 1;
    int ex = now - 1;
    
    float cha = 1.0;
    
    float fnow = now;
    float fnext = fnow - cha;
    float fex = now + cha;
    
    [self keepView:self.p3_bottom_image onPages:@[@(fex),@(fnow),@(fnext)] atTimes:@[@(ex),@(now),@(next)]];
    [self.p3_bottom_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.p3_top_image.mas_bottom).offset(_spaceBetweenCenterImageAndText);
        make.height.equalTo(self.p1_bottom_image.mas_height).offset(0);
    }];
}
#pragma mark - P4
/// p4 上
- (void)config_P4_top_animations
{
    int now = 3;
    int next = now + 1;
    int ex = now - 1;
    
    float cha = 0.3;
    
    float fnow = now;
    float fnext = fnow - cha;
    float fex = now + cha;
    
    [self keepView:self.p4_top_image onPages:@[@(fex),@(fnow),@(fnext)] atTimes:@[@(ex),@(now),@(next)]];
    [self.p4_top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hiddenView.mas_bottom).offset(_topBaseSpace);
        make.height.equalTo(self.p1_top_image.mas_height).offset(0);
    }];
}
/// p4 下
- (void)config_P4_bottom_animations
{
    int now = 3;
    int next = now + 1;
    int ex = now - 1;
    
    float cha = 1.0;
    
    float fnow = now;
    float fnext = fnow - cha;
    float fex = now + cha;
    
    [self keepView:self.p4_bottom_image onPages:@[@(fex),@(fnow),@(fnext)] atTimes:@[@(ex),@(now),@(next)]];
    [self.p4_bottom_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.p4_top_image.mas_bottom).offset(_spaceBetweenCenterImageAndText);
        make.height.equalTo(self.p1_bottom_image.mas_height).offset(0);
    }];
}
/// 开启按钮
- (void)config_open_animations
{
    int now = 3;

    [self keepView:self.open_button onPages:@[@(now - 1),@(now)] atTimes:@[@(now - 1),@(now)]]; // 保持在第4张
//    [self keepView:self.open_button onPages:@[@(0),@(1),@(2),@(3)]];
    NSLayoutConstraint *openVerticalConstraint = [NSLayoutConstraint constraintWithItem:self.open_button
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.p4_bottom_image
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1.f constant:_openButtonTop];

    [self.contentView addConstraint:openVerticalConstraint];

    IFTTTConstraintConstantAnimation *openVerticalAnimation = [IFTTTConstraintConstantAnimation animationWithSuperview:self.contentView
                                                                                                             constraint:openVerticalConstraint];

    [openVerticalAnimation addKeyframeForTime:(now-1) constant:_mainHeight/2.0];
    [openVerticalAnimation addKeyframeForTime:now constant:_openButtonTop];
    [self.animator addAnimation:openVerticalAnimation];
}
#pragma mark - 指示器
/// 指示器
- (void)configPagesAnimations
{
    CGSize point_size = self.pageView.frame.size;
    // 先中间的一个点
    [self keepView:self.pageView onPages:@[@(0),@(1),@(2)] atTimes:@[@(0),@(1),@(2)]];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1*_pointToBottom);
        make.width.offset(point_size.width);
        make.height.offset(point_size.height);
        
    }];
    
    NSArray *arr = self.pageView.constraintArray; // 关系的宽
    NSArray *viewsArr = self.pageView.viewsArray; // 关系view
    
    UIColor *chosedColor = self.pageView.selectedColor;
    UIColor *normalColor = self.pageView.unSelectedColor;
    
    int now = (int)arr.count - 1; // 最后一个不要
    for (int i =0; i<now; i++) {
        
        UIView *animationView = [viewsArr objectAtIndex:i];
        
        NSLayoutConstraint *constraint_width = [arr objectAtIndex:i];
        IFTTTConstraintConstantAnimation *constraintAnimation = [IFTTTConstraintConstantAnimation animationWithSuperview:animationView.superview
                                                                                                              constraint:constraint_width];
        IFTTTBackgroundColorAnimation *backgroundColorAnimation = [IFTTTBackgroundColorAnimation animationWithView:animationView];
        
        for (int j =0; j<now; j++) {
            
            UIColor *color = normalColor;
            CGFloat constant = 0;
            if (i==j) { // 选中状态
                color = chosedColor;
                constant = self.pageView.selectedBallDiameter;
            }
            
            // 背景动画
            [backgroundColorAnimation addKeyframeForTime:j color:color];
            [self.animator addAnimation:backgroundColorAnimation];
            
            //
            [constraintAnimation addKeyframeForTime:j constant:constant];
            [self.animator addAnimation:constraintAnimation];
        }
        
    }
    
}

- (void)action_finished
{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.alpha = 0.0;
        self.view.transform = CGAffineTransformMakeScale(6.0, 6.0);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];

        /// 更新为已经读过了
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:(NSString *)_USEDKEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        /// 保存版本信息
        NSString *versionstring = [WWPhoneInfo getAPPVersion];
        [[NSUserDefaults standardUserDefaults] setValue:versionstring forKey:(NSString *)_VERSIONKEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
