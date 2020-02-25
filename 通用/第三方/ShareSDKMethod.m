//
//  ShareSDKMethod.m
//  QLYDPro
//
//  Created by QiLu on 2017/4/26.
//  Copyright © 2017年 zxy. All rights reserved.
//
//分享自定义UI
#import "ShareSDKMethod.h"
@implementation ShareSDKMethod

+(void)ShareTextActionWithParams:(LGXShareParams*)shareParams IsBlack:(BOOL)isBlack IsReport:(BOOL)isReport IsDelete:(BOOL)isDelete Black:(BlackBlock)blackBlock Report:(ReportBlock)reportBlock Delete:(DeleteBlock)deleteBlock Result:(ResultBlock)resultBlock
{
    
    //设置分享参数
    myReportBlock = reportBlock;
    myBlackBlock = blackBlock;
    myResultBlock = resultBlock;
    myDeleteBlock = deleteBlock;
    myIsReport = isReport;
    myIsBlack = isBlack;
    myIsDelete = isDelete;
    _shareParams = [NSMutableDictionary dictionary];
    
    [_shareParams SSDKSetupShareParamsByText:shareParams.content
                                     images:shareParams.images
                                        url:[NSURL URLWithString:shareParams.url]
                                      title:shareParams.title
                                       type:SSDKContentTypeAuto];
    
    //创建UI
    [self createCustomUIWithBlack:isBlack Report:isReport Delete:isDelete];
}
//自定义分享UI
+(void)createCustomUIWithBlack:(BOOL)isBlack Report:(BOOL)isReport Delete:(BOOL)isDelete
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    
    //透明蒙层
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    grayView.backgroundColor = UIColorFromRGB(0x000000, 0.8);
    grayView.tag = 60000;
    UITapGestureRecognizer *tapGrayView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShareAction)];
    [grayView addGestureRecognizer:tapGrayView];
    grayView.userInteractionEnabled = YES;
    [window addSubview:grayView];
    
    
    
    CGFloat spaceH = 360;
    if (!isBlack && !isReport && !isDelete) {
        spaceH = 225;
    }
    
    //分享控制器
    UIView *shareBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, spaceH)];
    shareBackView.backgroundColor = UIColorFromRGB(0xffffff, 0);
    shareBackView.tag = 60001;
    [window addSubview:shareBackView];
    
    //内容视图
    UIView *contentView = [UIView new];
    contentView.clipsToBounds = YES;
    contentView.layer.cornerRadius = 8;
    contentView.backgroundColor = [UIColor whiteColor];
    [shareBackView addSubview:contentView];
    [contentView alignTop:@"0" leading:@"10" bottom:@"80" trailing:@"10" toView:shareBackView];
    
    
    UILabel *shareToLabel = [UILabel new];
    shareToLabel.text = NSLocalizedString(@"shareTo", nil);
    shareToLabel.textColor = kColorThirdTextColor;
    shareToLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [contentView addSubview:shareToLabel];
    [shareToLabel leftToView:contentView withSpace:15];
    [shareToLabel topToView:contentView withSpace:15];
    
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = kColorLineColor;
    [contentView addSubview:lineLabel];
    [lineLabel bottomToView:contentView withSpace:125];
    [lineLabel leftToView:contentView withSpace:15];
    [lineLabel rightToView:contentView withSpace:15];
    [lineLabel addHeight:0.6];
    if (!isBlack && !isReport && !isDelete) {
        lineLabel.hidden = YES;
    }
    
    
    
    //取消按钮
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setBGColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    [cancelBtn addTarget:self action:@selector(cancelShareAction) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.clipsToBounds = YES;
    cancelBtn.layer.cornerRadius = 8;
    [shareBackView addSubview:cancelBtn];
    [cancelBtn xCenterToView:shareBackView];
    [cancelBtn addWidth:kScreenWidth - 20];
    [cancelBtn bottomToView:shareBackView withSpace:15];
    [cancelBtn addHeight:50];
    
    
    
    //分享图标和标题数组
    NSArray *imageNameArr = @[@"share_wechat_frined_image",@"share_wechat_circle_image",@"share_weibo_image",@"share_qqzone_image"];
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (NSString *imageName in imageNameArr) {
        UIImage *image = [UIImage imageNamed:imageName];
        [imagesArr addObject:image];
    }
    NSArray *titlesArr = @[NSLocalizedString(@"ShareType_1", nil),NSLocalizedString(@"ShareType_2", nil),NSLocalizedString(@"ShareType_3", nil),NSLocalizedString(@"ShareType_4", nil)];
    NSMutableArray *titleNameArr = [NSMutableArray array];
    for (NSString *title in titlesArr) {
        [titleNameArr addObject:title];
    }
    
    
    //分享栏中添加自己的功能，比如拉黑、举报之类的
    if (isReport) {
        [imagesArr addObject:[UIImage imageNamed:@"jubao_image"]];
        [titleNameArr addObject:NSLocalizedString(@"jubao", nil)];
    }
    
    if (isBlack) {
        [imagesArr addObject:[UIImage imageNamed:@"shield_image"]];
        [titleNameArr addObject:NSLocalizedString(@"shield", nil)];
    }
  
    if (isDelete) {
        [imagesArr addObject:[UIImage imageNamed:@"pet_circle_delete"]];
        [titleNameArr addObject:NSLocalizedString(@"delete", nil)];
    }
    
    
    //分享按钮
    CGFloat itemWidth = 60;
    CGFloat itemHeight = 60+25;
    
    CGFloat spaceX = (kScreenWidth - 290)/3;
    
    NSInteger rowCount = 4;
    for (int i =0; i<titleNameArr.count; i++) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.frame = CGRectMake(15 + (i%rowCount)*(itemWidth+spaceX), 48 + (i/rowCount)*(itemHeight + 45), itemWidth, itemWidth);
        [iconBtn setImage:imagesArr[i] forState:UIControlStateNormal];
        iconBtn.tag = 2000 + i;
        [iconBtn addTarget:self action:@selector(shareItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:iconBtn];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
        titleLabel.center = CGPointMake(CGRectGetMinX(iconBtn.frame)+itemWidth/2, CGRectGetMaxY(iconBtn.frame)+15);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kColorMainTextColor;
        titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
        titleLabel.text = titleNameArr[i];
        [contentView addSubview:titleLabel];
    }
    
    
    [UIView animateWithDuration:0.35 animations:^{
        shareBackView.frame = CGRectMake(0, kScreenHeight-shareBackView.frame.size.height, shareBackView.frame.size.width, shareBackView.frame.size.height);
    }];
    
}
+(void)shareItemAction:(UIButton*)button
{
    [self removeShareView];
    NSInteger sharetype = 0;
    NSMutableDictionary *publishContent = _shareParams;

    switch (button.tag) {
        case 2000:
        {
            sharetype = SSDKPlatformSubTypeWechatSession;
        }
            break;
        case 2001:
        {
            sharetype = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
        case 2002:
        {
            sharetype = SSDKPlatformTypeSinaWeibo;
            [publishContent SSDKEnableUseClientShare];
        }
            break;
        case 2003:
        {
            sharetype = SSDKPlatformSubTypeQZone;
        }
            break;
        case 2004:
        {
            if (myIsDelete)
            {
                if (myDeleteBlock) {
                    myDeleteBlock();
                }
            }else
            {
                if (myReportBlock) {
                    myReportBlock();
                }
            }
        }
            break;
        case 2005:
        {
            if (myBlackBlock) {
                myBlackBlock();
            }
        }
            break;
        default:
            break;
    }
    if (sharetype == 0)
    {
        [self removeShareView];
        
    }else
    {
        //调用ShareSDK的无UI分享方法
        [ShareSDK share:sharetype parameters:publishContent onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (myResultBlock) {
                myResultBlock(state,sharetype,userData,contentEntity,error);
            }
        }];
    }
}

//点击分享栏之外的区域 取消分享 移除分享栏
+(void)removeShareView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:60000];
    UIView *shareView = [window viewWithTag:60001];
    shareView.frame =CGRectMake(0, shareView.frame.origin.y, shareView.frame.size.width, shareView.frame.size.height);
    [UIView animateWithDuration:0.35 animations:^{
        shareView.frame = CGRectMake(0, kScreenHeight, shareView.frame.size.width, shareView.frame.size.height);
    } completion:^(BOOL finished) {
        
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
    
    
}
+(void)cancelShareAction{
    
    [self removeShareView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"KNotiVideoPlayForShare" object:nil];
}

@end
